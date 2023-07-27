class UnreadCountModel {
  const UnreadCountModel({required this.unreadCount});

  final int unreadCount;

  factory UnreadCountModel.fromJson(Map<String, dynamic> json) =>
      UnreadCountModel(unreadCount: json["unread_count"]);

  Map<String, dynamic> toJsOn() => {"unread_count": unreadCount};
}
