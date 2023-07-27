import 'package:o7therapy/api/models/notifications/notifications.dart';

/// status
/// Pending = 0,
/// Sent = 1,
/// Delivered = 2,
/// Read = 3,
/// Failed = 4
class NotificationModel {
  NotificationModel({
    required this.messageTypeCode,
    required this.status,
    required this.sentDate,
    required this.deliveredDate,
    required this.extraParams,
    required this.id,
    required this.code,
    required this.title,
    required this.body,
  });

  final MessageTypeCode? messageTypeCode;
  final int status;
  final String sentDate;
  final String? deliveredDate;
  final ExtraParams extraParams;
  final int id;
  final String code;
  final String title;
  final String body;

  NotificationModel copyWith({
    MessageTypeCode? messageTypeCode,
    int? status,
    String? sentDate,
    String? deliveredDate,
    ExtraParams? extraParams,
    int? id,
    String? code,
    String? title,
    String? body,
  }) =>
      NotificationModel(
        messageTypeCode: messageTypeCode ?? this.messageTypeCode,
        status: status ?? this.status,
        sentDate: sentDate ?? this.sentDate,
        deliveredDate: deliveredDate ?? this.deliveredDate,
        extraParams: extraParams ?? this.extraParams,
        id: id ?? this.id,
        code: code ?? this.code,
        title: title ?? this.title,
        body: body ?? this.body,
      );

  factory NotificationModel.fromJson(json) => NotificationModel(
        messageTypeCode:
            messageTypeCodeValues.map[json["message_type_code"] ?? ""],
        status: json["status"],
        sentDate: json["sent_date"],
        deliveredDate: json["delivered_date"],
        extraParams: ExtraParams.fromJson(json["extra_params"]),
        id: json["id"],
        code: json["code"],
        title: json["title"],
        body: json["body"],
      );

  Map<String, dynamic> toJson() => {
        "message_type_code": messageTypeCodeValues.reverse[messageTypeCode],
        "status": status,
        "sent_date": sentDate,
        "delivered_date": deliveredDate,
        "extra_params": extraParams.toJson(),
        "id": id,
        "code": code,
        "title": title, // titleValues.reverse[title],
        "body": body,
      };
}
