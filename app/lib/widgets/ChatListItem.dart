import 'dart:io';

import 'package:effektio/common/store/themes/SeperatedThemes.dart';
import 'package:effektio/controllers/chat_list_controller.dart';
import 'package:effektio/controllers/receipt_controller.dart';
import 'package:effektio/screens/HomeScreens/chat/ChatScreen.dart';
import 'package:effektio/widgets/AppCommon.dart';
import 'package:effektio/widgets/CustomAvatar.dart';
import 'package:effektio_flutter_sdk/effektio_flutter_sdk_ffi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_link_previewer/flutter_link_previewer.dart';
import 'package:flutter_parsed_text/flutter_parsed_text.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ChatListItem extends StatefulWidget {
  final Client client;
  final Conversation room;
  final RoomMessage? latestMessage;
  final List<types.User> typingUsers;

  const ChatListItem({
    Key? key,
    required this.client,
    required this.room,
    this.latestMessage,
    required this.typingUsers,
  }) : super(key: key);

  @override
  State<ChatListItem> createState() => _ChatListItemState();
}

class _ChatListItemState extends State<ChatListItem> {
  Future<FfiBufferUint8>? avatar;
  String? displayName;
  String? userId;

  List<Member> activeMembers = [];

  @override
  void initState() {
    super.initState();

    widget.room.getProfile().then((value) {
      if (mounted) {
        setState(() {
          if (value.hasAvatar()) {
            avatar = value.getAvatar();
          }
          displayName = value.getDisplayName();
        });
      }
    });

    userId = widget.client.account().userId();

    getActiveMembers();
  }

  @override
  Widget build(BuildContext context) {
    String roomId = widget.room.getRoomId();
    // ToDo: UnreadCounter
    return Column(
      children: <Widget>[
        ListTile(
          onTap: () => handleTap(context),
          leading: CustomAvatar(
            uniqueKey: roomId,
            avatar: avatar,
            displayName: displayName,
            radius: 25,
            cacheHeight: 120,
            cacheWidth: 120,
            isGroup: true,
            stringName: simplifyRoomId(roomId)!,
          ),
          title: buildTitle(context),
          subtitle: GetBuilder<ChatListController>(
            id: 'chatroom-$roomId-subtitle',
            builder: (controller) => buildSubtitle(context),
          ),
          trailing: buildTrailing(context),
        ),
        const Padding(
          padding: EdgeInsets.only(bottom: 5),
          child: Divider(
            indent: 75,
            endIndent: 10,
            color: AppCommonTheme.dividerColor,
          ),
        ),
      ],
    );
  }

  void handleTap(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          client: widget.client,
          room: widget.room,
          roomName: displayName,
          roomAvatar: avatar,
        ),
      ),
    );
  }

  Widget buildTitle(BuildContext context) {
    if (displayName == null) {
      return Text(
        AppLocalizations.of(context)!.loadingName,
        style: ChatTheme01.chatTitleStyle,
      );
    }

    RoomEventItem? eventItem =
        widget.latestMessage == null ? null : widget.latestMessage!.eventItem();
    var senderID = '';
    var messageStatus;

    if (eventItem != null) {
      int ts = eventItem.originServerTs();

      var receiptController = Get.find<ReceiptController>();
      List<String> seenByList = receiptController.getSeenByList(
        widget.room.getRoomId(),
        ts,
      );

      senderID = widget.latestMessage!.eventItem()!.sender();

      messageStatus = seenByList.isEmpty
          ? types.Status.sent
          : seenByList.length < activeMembers.length
              ? types.Status.delivered
              : types.Status.seen;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          displayName!,
          style: ChatTheme01.chatTitleStyle,
        ),
        senderID == userId
            ? customStatusBuilder(messageStatus)
            : const SizedBox(),
      ],
    );
  }

  Widget buildSubtitle(BuildContext context) {
    if (widget.typingUsers.isNotEmpty) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 10),
        child: Text(
          getUserPlural(widget.typingUsers),
          style: ChatTheme01.latestChatStyle.copyWith(
            fontStyle: FontStyle.italic,
          ),
        ),
      );
    }
    if (widget.latestMessage == null) {
      return const SizedBox();
    }
    RoomEventItem? eventItem = widget.latestMessage!.eventItem();
    if (eventItem == null) {
      return const SizedBox();
    }
    String sender = eventItem.sender();
    String body = eventItem.textDesc()?.body() ?? 'Unknown item';
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ParsedText(
        text: '${simplifyUserId(sender)}: $body',
        style: ChatTheme01.latestChatStyle,
        regexOptions: const RegexOptions(multiLine: true, dotAll: true),
        maxLines: 2,
        parse: [
          MatchText(
            pattern: '(\\*\\*|\\*)(.*?)(\\*\\*|\\*)',
            style: ChatTheme01.latestChatStyle.copyWith(
              fontWeight: FontWeight.bold,
            ),
            renderText: ({required String str, required String pattern}) {
              return {'display': str.replaceAll(RegExp('(\\*\\*|\\*)'), '')};
            },
            onTap: (String value) => handleTap(context),
          ),
          MatchText(
            pattern: '_(.*?)_',
            style: ChatTheme01.latestChatStyle.copyWith(
              fontStyle: FontStyle.italic,
            ),
            renderText: ({required String str, required String pattern}) {
              return {'display': str.replaceAll('_', '')};
            },
            onTap: (String value) => handleTap(context),
          ),
          MatchText(
            pattern: '~(.*?)~',
            style: ChatTheme01.latestChatStyle.copyWith(
              decoration: TextDecoration.lineThrough,
            ),
            renderText: ({required String str, required String pattern}) {
              return {'display': str.replaceAll('~', '')};
            },
            onTap: (String value) => handleTap(context),
          ),
          MatchText(
            pattern: '`(.*?)`',
            style: ChatTheme01.latestChatStyle.copyWith(
              fontFamily: Platform.isIOS ? 'Courier' : 'monospace',
            ),
            renderText: ({required String str, required String pattern}) {
              return {'display': str.replaceAll('`', '')};
            },
            onTap: (String value) => handleTap(context),
          ),
          MatchText(
            pattern: regexEmail,
            style: ChatTheme01.latestChatStyle.copyWith(
              decoration: TextDecoration.underline,
            ),
            onTap: (String value) => handleTap(context),
          ),
          MatchText(
            pattern: regexLink,
            style: ChatTheme01.latestChatStyle.copyWith(
              decoration: TextDecoration.underline,
            ),
            onTap: (String value) => handleTap(context),
          ),
        ],
      ),
    );
  }

  Widget? buildTrailing(BuildContext context) {
    if (widget.latestMessage == null) {
      return null;
    }
    RoomEventItem? eventItem = widget.latestMessage!.eventItem();
    if (eventItem == null) {
      return null;
    }

    int ts = eventItem.originServerTs();

    return Text(
      DateFormat.Hm().format(
        DateTime.fromMillisecondsSinceEpoch(ts, isUtc: true),
      ),
      style: ChatTheme01.latestChatDateStyle,
    );
  }

  Widget customStatusBuilder(types.Status status) {
    if (status == Status.delivered) {
      return SvgPicture.asset('assets/images/deliveredIcon.svg');
    } else if (status == Status.seen) {
      return SvgPicture.asset('assets/images/seenIcon.svg');
    } else if (status == Status.sending) {
      return const Center(
        child: SizedBox(
          height: 10,
          width: 10,
          child: CircularProgressIndicator(
            backgroundColor: Colors.transparent,
            strokeWidth: 1.5,
          ),
        ),
      );
    } else {
      return SvgPicture.asset(
        'assets/images/sentIcon.svg',
        width: 12,
        height: 12,
      );
    }
  }

  String getUserPlural(List<types.User> authors) {
    if (authors.isEmpty) {
      return '';
    } else if (authors.length == 1) {
      return '${authors[0].firstName} is typing...';
    } else if (authors.length == 2) {
      return '${authors[0].firstName} and ${authors[1].firstName} is typing...';
    } else {
      return '${authors[0].firstName} and ${authors.length - 1} others typing...';
    }
  }

  Future<void> getActiveMembers() async {
    activeMembers = (await widget.room.activeMembers()).toList();
  }
}
