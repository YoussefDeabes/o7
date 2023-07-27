import 'package:sendbird_sdk/core/channel/group/group_channel.dart';

mixin ContactItemMixin {
  DateTime? getLastMessageCreatedAt(int? createdAt) {
    if (createdAt == null) {
      return null;
    } else {
      return DateTime.fromMillisecondsSinceEpoch(
        createdAt,
        isUtc: true,
      ).toLocal();
    }
  }
}
