import 'dart:convert';

class SendBirdMessageModel {
  SendBirdMessageModel({required this.sendBird});

  final SendBirdModel sendBird;
  static bool isSendBirdMessageModel(Map<String, dynamic>? json) {
    if (json == null) {
      return false;
    } else {
      return true;
    }
  }

  factory SendBirdMessageModel.fromMap(Map<String, dynamic> json) =>
      SendBirdMessageModel(
        sendBird: SendBirdModel.fromJson(json["sendbird"]),
      );

  Map<String, dynamic> toMap() => {"sendbird": sendBird.toMap()};
}

class SendBirdModel {
  SendBirdModel({
    required this.sqsTs,
    required this.customType,
    required this.channel,
    required this.createdAt,
    required this.messageId,
    required this.message,
    required this.type,
    required this.unreadMessageCount,
    required this.pushTitle,
    required this.audienceType,
    required this.sender,
    required this.pushSound,
    required this.translations,
    required this.recipient,
    required this.files,
    required this.notificationAction,
    required this.category,
    required this.channelType,
    required this.mentionedUsers,
    required this.appId,
  });

  final int sqsTs;
  final String customType;
  final Channel channel;
  final int createdAt;
  final int messageId;
  final String message;
  final String type;
  final int unreadMessageCount;
  final dynamic pushTitle;
  final String audienceType;
  final Sender sender;
  final String pushSound;
  final Translations translations;
  final Recipient recipient;
  final List<dynamic> files;
  final String notificationAction;
  final String category;
  final String channelType;
  final List<dynamic> mentionedUsers;
  final String appId;

  factory SendBirdModel.fromJson(String str) =>
      SendBirdModel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SendBirdModel.fromMap(Map<String, dynamic> json) => SendBirdModel(
        sqsTs: json["sqs_ts"],
        customType: json["custom_type"],
        channel: Channel.fromMap(json["channel"]),
        createdAt: json["created_at"],
        messageId: json["message_id"],
        message: json["message"],
        type: json["type"],
        unreadMessageCount: json["unread_message_count"],
        pushTitle: json["push_title"],
        audienceType: json["audience_type"],
        sender: Sender.fromMap(json["sender"]),
        pushSound: json["push_sound"],
        translations: Translations.fromMap(json["translations"]),
        recipient: Recipient.fromMap(json["recipient"]),
        files: List<dynamic>.from(json["files"].map((x) => x)),
        notificationAction: json["notification_action"],
        category: json["category"],
        channelType: json["channel_type"],
        mentionedUsers:
            List<dynamic>.from(json["mentioned_users"].map((x) => x)),
        appId: json["app_id"],
      );

  Map<String, dynamic> toMap() => {
        "sqs_ts": sqsTs,
        "custom_type": customType,
        "channel": channel.toMap(),
        "created_at": createdAt,
        "message_id": messageId,
        "message": message,
        "type": type,
        "unread_message_count": unreadMessageCount,
        "push_title": pushTitle,
        "audience_type": audienceType,
        "sender": sender.toMap(),
        "push_sound": pushSound,
        "translations": translations.toMap(),
        "recipient": recipient.toMap(),
        "files": List<dynamic>.from(files.map((x) => x)),
        "notification_action": notificationAction,
        "category": category,
        "channel_type": channelType,
        "mentioned_users": List<dynamic>.from(mentionedUsers.map((x) => x)),
        "app_id": appId,
      };
}

class Channel {
  Channel({
    required this.channelUnreadMessageCount,
    required this.customType,
    required this.name,
    required this.channelUrl,
  });

  final int channelUnreadMessageCount;
  final String customType;
  final String name;
  final String channelUrl;

  factory Channel.fromJson(String str) => Channel.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Channel.fromMap(Map<String, dynamic> json) => Channel(
        channelUnreadMessageCount: json["channel_unread_message_count"],
        customType: json["custom_type"],
        name: json["name"],
        channelUrl: json["channel_url"],
      );

  Map<String, dynamic> toMap() => {
        "channel_unread_message_count": channelUnreadMessageCount,
        "custom_type": customType,
        "name": name,
        "channel_url": channelUrl,
      };
}

class Recipient {
  Recipient({
    required this.name,
    required this.pushTemplate,
    required this.id,
  });

  final String name;
  final String pushTemplate;
  final String id;

  factory Recipient.fromJson(String str) => Recipient.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Recipient.fromMap(Map<String, dynamic> json) => Recipient(
        name: json["name"],
        pushTemplate: json["push_template"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "push_template": pushTemplate,
        "id": id,
      };
}

class Sender {
  Sender({
    required this.requireAuthForProfileImage,
    required this.profileUrl,
    required this.name,
    required this.id,
  });

  final bool requireAuthForProfileImage;
  final String profileUrl;
  final String name;
  final String id;

  factory Sender.fromJson(String str) => Sender.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Sender.fromMap(Map<String, dynamic> json) => Sender(
        requireAuthForProfileImage: json["require_auth_for_profile_image"],
        profileUrl: json["profile_url"],
        name: json["name"],
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "require_auth_for_profile_image": requireAuthForProfileImage,
        "profile_url": profileUrl,
        "name": name,
        "id": id,
      };
}

class Translations {
  Translations();

  factory Translations.fromJson(String str) =>
      Translations.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Translations.fromMap(Map<String, dynamic> json) => Translations();

  Map<String, dynamic> toMap() => {};
}


// {
//   "sendbird": {
//     "sqs_ts": 1669127195189,
//     "custom_type": "",
//     "channel": {
//       "channel_unread_message_count": 5,
//       "custom_type": "",
//       "name": "",
//       "channel_url": "ef35f-feb03-1335734258"
//     },
//     "created_at": 1669127194985,
//     "message_id": 4633387838,
//     "message": "world",
//     "type": "MESG",
//     "unread_message_count": 5,
//     "push_title": null,
//     "audience_type": "only",
//     "sender": {
//       "require_auth_for_profile_image": false,
//       "profile_url": "",
//       "name": "O7 shireen",
//       "id": "ef35f7c2-bdb3-4ecd-894b-f8be797967fa"
//     },
//     "push_sound": "default",
//     "translations": {},
//     "recipient": {
//       "name": "O7 shireen",
//       "push_template": "default",
//       "id": "feb03a6e-f0d9-481b-b9c0-b43b26b809ff"
//     },
//     "files": [],
//     "notification_action": "create",
//     "category": "messaging:offline_notification",
//     "channel_type": "group_messaging",
//     "mentioned_users": [],
//     "app_id": "C8F82B6F-79AA-43B1-8B87-E752361ABB9E"
//   }
// }

