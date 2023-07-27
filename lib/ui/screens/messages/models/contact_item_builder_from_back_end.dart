import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/api/models/sendBird/chat_contacts/chat_contacts_wrapper.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item_mixin.dart';
import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

/// used to build ContactItem from BackEnd
class ContactItemBuilderFromBackEnd with ContactItemMixin {
  final ListElement element;
  const ContactItemBuilderFromBackEnd({required this.element});

  ContactItem getContactItem() {
    GroupChannel groupChannel =
        GroupChannel(channelUrl: element.channelUrl ?? "");

    return ContactItem(
      channelUrl: element.channelUrl ?? "",
      canChatTill: _getCanChatUntil(),
      contactType: ContactType.values[element.type ?? 0],
      groupChannelName: element.name,
      lastMessage: groupChannel.lastMessage?.message,
      groupChannelImage: element.image?.url ?? "",
      noOfUnreadMessage: groupChannel.unreadMessageCount,
      groupChannel: groupChannel,
      therapistId: element.id ?? "",
    );
  }

  DateTime _getCanChatUntil() {
    String dateWithT =
        '${element.canChatTill!.substring(0, 8)}T${element.canChatTill!.substring(8)}Z';
    return DateTime.parse(dateWithT).toLocal();
  }
}
