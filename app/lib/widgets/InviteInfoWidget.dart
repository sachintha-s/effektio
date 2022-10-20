import 'package:effektio/common/store/themes/SeperatedThemes.dart';
import 'package:effektio/controllers/chat_list_controller.dart';
import 'package:effektio/screens/HomeScreens/chat/ChatScreen.dart';
import 'package:effektio/widgets/AppCommon.dart';
import 'package:effektio/widgets/CustomAvatar.dart';
import 'package:effektio_flutter_sdk/effektio_flutter_sdk_ffi.dart'
    show FfiBufferUint8, Invitation;
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';

class InviteInfoWidget extends StatefulWidget {
  final String userId;
  final Invitation invitation;
  final Color avatarColor;

  const InviteInfoWidget({
    Key? key,
    required this.userId,
    required this.invitation,
    required this.avatarColor,
  }) : super(key: key);

  @override
  State<InviteInfoWidget> createState() => _InviteInfoWidgetState();
}

class _InviteInfoWidgetState extends State<InviteInfoWidget> {
  Future<FfiBufferUint8>? avatar;
  String? displayName;

  @override
  void initState() {
    super.initState();

    widget.invitation.getSenderProfile().then((userProfile) {
      if (mounted) {
        setState(() {
          if (userProfile.hasAvatar()) {
            avatar = userProfile.getAvatar();
          }
          displayName = userProfile.getDisplayName();
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppCommonTheme.darkShade,
      margin: const EdgeInsets.symmetric(vertical: 1),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          ListTile(
            // leading: CircleAvatar(backgroundColor: avatarColor),
            leading: CustomAvatar(
              avatar: avatar,
              displayName: displayName,
              radius: 20,
              isGroup: true,
              stringName: parseUserId(widget.userId)!,
            ),
            title: _buildTitle(),
            subtitle: _buildSubtitle(context),
          ),
          const Divider(color: AppCommonTheme.dividerColor, indent: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildAcceptButton(context),
              _buildRejectButton(context),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      widget.invitation.sender(),
      style: AppCommonTheme.appBarTitleStyle.copyWith(
        fontSize: 14,
        fontWeight: FontWeight.w500,
      ),
    );
  }

  Widget _buildSubtitle(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: AppLocalizations.of(context)!.invitationText2,
        style: AppCommonTheme.appBarTitleStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: AppCommonTheme.dividerColor,
        ),
        children: <TextSpan>[
          TextSpan(
            text: widget.invitation.roomName(),
            style: AppCommonTheme.appBarTitleStyle.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAcceptButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.46,
      child: elevatedButton(
        AppLocalizations.of(context)!.accept,
        AppCommonTheme.greenButtonColor,
        () async {
          if (await widget.invitation.accept() == true) {
            final listController = Get.find<ChatListController>();
            for (var room in listController.joinedRooms) {
              if (room.conversation.getRoomId() == widget.invitation.roomId()) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ChatScreen(
                      userId: widget.userId,
                      room: room.conversation,
                    ),
                  ),
                );
              }
            }
          }
        },
        AppCommonTheme.appBarTitleStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildRejectButton(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.46,
      child: elevatedButton(
        AppLocalizations.of(context)!.decline,
        AppCommonTheme.primaryColor,
        () async => await widget.invitation.reject(),
        AppCommonTheme.appBarTitleStyle.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
