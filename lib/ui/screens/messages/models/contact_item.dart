import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

enum ContactType { patient, therapist, admin }

class ContactItem {
  ContactType? contactType;
  String? groupChannelName;
  DateTime? canChatTill;
  String channelUrl;
  String? lastMessage;
  String? groupChannelImage;
  DateTime? lastMessageTime;
  int? noOfUnreadMessage;
  GroupChannel groupChannel;
  String? therapistId;

  ContactItem({
    required this.groupChannel,
    required this.canChatTill,
    required this.channelUrl,
    this.groupChannelName,
    this.lastMessage,
    this.contactType,
    this.groupChannelImage,
    this.lastMessageTime,
    this.noOfUnreadMessage,
    required this.therapistId,
  });

  @override
  String toString() {
    return 'ContactItem(contactType: $contactType, groupChannelName: $groupChannelName, canChatTill: $canChatTill, channelUrl: $channelUrl, lastMessage: $lastMessage, groupChannelImage: $groupChannelImage, lastMessageTime: ${lastMessageTime.toString()}, noOfUnreadMessage: $noOfUnreadMessage, groupChannel: $groupChannel, therapistId: $therapistId)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ContactItem &&
        other.contactType == contactType &&
        other.groupChannelName == groupChannelName &&
        other.canChatTill == canChatTill &&
        other.channelUrl == channelUrl &&
        other.lastMessage == lastMessage &&
        other.groupChannelImage == groupChannelImage &&
        other.lastMessageTime == lastMessageTime &&
        other.noOfUnreadMessage == noOfUnreadMessage &&
        other.groupChannel == groupChannel &&
        other.therapistId == therapistId;
  }

  @override
  int get hashCode {
    return contactType.hashCode ^
        groupChannelName.hashCode ^
        canChatTill.hashCode ^
        channelUrl.hashCode ^
        lastMessage.hashCode ^
        groupChannelImage.hashCode ^
        lastMessageTime.hashCode ^
        noOfUnreadMessage.hashCode ^
        groupChannel.hashCode ^
        therapistId.hashCode;
  }

  ContactItem copyWith({
    ContactType? contactType,
    String? groupChannelName,
    DateTime? canChatTill,
    String? channelUrl,
    String? lastMessage,
    String? groupChannelImage,
    DateTime? lastMessageTime,
    int? noOfUnreadMessage,
    GroupChannel? groupChannel,
    String? therapistId,
  }) {
    return ContactItem(
      contactType: contactType ?? this.contactType,
      groupChannelName: groupChannelName ?? this.groupChannelName,
      canChatTill: canChatTill ?? this.canChatTill,
      channelUrl: channelUrl ?? this.channelUrl,
      lastMessage: lastMessage ?? this.lastMessage,
      groupChannelImage: groupChannelImage ?? this.groupChannelImage,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime,
      noOfUnreadMessage: noOfUnreadMessage ?? this.noOfUnreadMessage,
      groupChannel: groupChannel ?? this.groupChannel,
      therapistId: therapistId ?? this.therapistId,
    );
  }
}
