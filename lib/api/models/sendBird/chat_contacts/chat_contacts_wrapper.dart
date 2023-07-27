class ChatContactsWrapper {
  const ChatContactsWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final Data? data;
  final int? errorCode;
  final String? errorMsg;
  final String? errorDetails;
  final Expiration? expiration;
  final Persistence? persistence;
  final int? totalSeconds;

  factory ChatContactsWrapper.fromJson(Map<String, dynamic> json) =>
      ChatContactsWrapper(
        data: Data.fromJson(json["data"]),
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        expiration: json['expiration'] != null
            ? Expiration.fromJson(json['expiration'])
            : null,
        persistence: json['persistence'] != null
            ? Persistence.fromJson(json['persistence'])
            : null,
        totalSeconds: json["total_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "expiration": expiration?.toJson(),
        "persistence": persistence?.toJson(),
        "total_seconds": totalSeconds,
      };
}

class Data {
  const Data({
    required this.list,
    required this.totalCount,
    required this.hasMore,
  });

  final List<ListElement>? list;
  final int? totalCount;
  final bool? hasMore;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        list: List<ListElement>.from(
            json["list"].map((x) => ListElement.fromJson(x))),
        totalCount: json["total_count"],
        hasMore: json["has_more"],
      );

  Map<String, dynamic> toJson() => {
        "list": list == null
            ? []
            : List<dynamic>.from(list!.map((x) => x.toJson())),
        "total_count": totalCount,
        "has_more": hasMore,
      };
}

class ListElement {
  const ListElement({
    required this.id,
    required this.name,
    required this.type,
    required this.image,
    required this.canChatTill,
    required this.channelUrl,
  });

  final String? id;
  final String? name;
  final int? type;
  final Image? image;
  final String? canChatTill;
  final String? channelUrl;

  factory ListElement.fromJson(Map<String, dynamic> json) => ListElement(
        id: json["id"],
        name: json["name"],
        type: json["type"],
        image: Image.fromJson(json["image"]),
        canChatTill: json["can_chat_till"],
        channelUrl: json["channel_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "type": type,
        "image": image?.toJson(),
        "can_chat_till": canChatTill,
        "channel_url": channelUrl,
      };
}

class Image {
  const Image({
    required this.imageCode,
    required this.url,
  });

  final String imageCode;
  final String url;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        imageCode: json["image_code"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "image_code": imageCode,
        "url": url,
      };
}

class Expiration {
  const Expiration({
    required this.isAllowed,
    required this.duration,
    required this.method,
    required this.mode,
    required this.isSessionExpiry,
  });

  final bool isAllowed;
  final int duration;
  final int method;
  final int mode;
  final bool isSessionExpiry;

  factory Expiration.fromJson(Map<String, dynamic> json) => Expiration(
        isAllowed: json["is_allowed"],
        duration: json["duration"],
        method: json["method"],
        mode: json["mode"],
        isSessionExpiry: json["is_session_expiry"],
      );

  Map<String, dynamic> toJson() => {
        "is_allowed": isAllowed,
        "duration": duration,
        "method": method,
        "mode": mode,
        "is_session_expiry": isSessionExpiry,
      };
}

class Persistence {
  const Persistence({
    required this.scope,
    required this.isEncrypted,
  });

  final int scope;
  final bool isEncrypted;

  factory Persistence.fromJson(Map<String, dynamic> json) => Persistence(
        scope: json["scope"],
        isEncrypted: json["is_encrypted"],
      );

  Map<String, dynamic> toJson() => {
        "scope": scope,
        "is_encrypted": isEncrypted,
      };
}
