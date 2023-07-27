import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item_mixin.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

/// used to build ContactItem from SendBird
class ContactItemBuilderFromSendBird with ContactItemMixin {
  final GroupChannel groupChannel;
  const ContactItemBuilderFromSendBird({required this.groupChannel});

  ContactItem getContactItem() {
    return ContactItem(
      canChatTill: null,
      therapistId: null,
      channelUrl: groupChannel.channelUrl,
      lastMessage: groupChannel.lastMessage?.message,
      lastMessageTime:
          getLastMessageCreatedAt(groupChannel.lastMessage?.createdAt),
      noOfUnreadMessage: groupChannel.unreadMessageCount,
      groupChannel: groupChannel,
    );
  }
}
