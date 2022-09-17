use futures::{
    channel::mpsc::{channel, Receiver, Sender},
    StreamExt,
};
use log::{info, warn};
use matrix_sdk::{
    event_handler::Ctx,
    room::Room as MatrixRoom,
    ruma::events::{typing::TypingEventContent, SyncEphemeralRoomEvent},
    Client as MatrixClient,
};
use parking_lot::Mutex;
use std::sync::Arc;

use super::{client::Client, RUNTIME};

#[derive(Clone, Debug)]
pub struct TypingNotificationEvent {
    room_id: String,
    user_ids: Vec<String>,
}

impl TypingNotificationEvent {
    pub(crate) fn new(room_id: String, user_ids: Vec<String>) -> Self {
        Self { room_id, user_ids }
    }

    pub fn room_id(&self) -> String {
        self.room_id.clone()
    }

    pub fn user_ids(&self) -> Vec<String> {
        self.user_ids.clone()
    }
}

#[derive(Clone)]
pub(crate) struct TypingNotificationController {
    event_tx: Sender<TypingNotificationEvent>,
    event_rx: Arc<Mutex<Option<Receiver<TypingNotificationEvent>>>>,
}

impl TypingNotificationController {
    pub fn new() -> Self {
        let (tx, rx) = channel::<TypingNotificationEvent>(10); // dropping after more than 10 items queued
        TypingNotificationController {
            event_tx: tx,
            event_rx: Arc::new(Mutex::new(Some(rx))),
        }
    }

    pub async fn setup(&self, client: &MatrixClient) {
        let me = self.clone();
        client
            .register_event_handler_context(me)
            .register_event_handler(
                |ev: SyncEphemeralRoomEvent<TypingEventContent>,
                 room: MatrixRoom,
                 Ctx(me): Ctx<TypingNotificationController>| async move {
                    me.clone().process_ephemeral_event(ev, &room);
                },
            )
            .await;
    }

    fn process_ephemeral_event(
        &self,
        ev: SyncEphemeralRoomEvent<TypingEventContent>,
        room: &MatrixRoom,
    ) {
        info!("typing: {:?}", ev.content.user_ids);
        let room_id = room.room_id();
        let mut user_ids = vec![];
        for user_id in ev.content.user_ids {
            user_ids.push(user_id.to_string());
        }
        let msg = TypingNotificationEvent::new(room_id.to_string(), user_ids);
        let mut event_tx = self.event_tx.clone();
        if let Err(e) = event_tx.try_send(msg) {
            warn!("Dropping ephemeral event for {}: {}", room_id, e);
        }
    }
}

impl Client {
    pub fn typing_notification_event_rx(&self) -> Option<Receiver<TypingNotificationEvent>> {
        self.typing_notification_controller.event_rx.lock().take()
    }
}
