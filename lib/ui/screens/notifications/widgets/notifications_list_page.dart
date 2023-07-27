import 'package:flutter/material.dart';

import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/notifications/notification_model.dart';
import 'package:o7therapy/api/notifications_api_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/notifications/bloc/notifications_bloc.dart';
import 'package:o7therapy/ui/screens/notifications/widgets/notification_card.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class NotificationsListPage extends BaseStatefulWidget {
  const NotificationsListPage({super.key, required this.allNotifications});

  final List<NotificationModel> allNotifications;

  @override
  _NotificationsListPageState baseCreateState() =>
      _NotificationsListPageState();
}

class _NotificationsListPageState extends BaseState<NotificationsListPage> {
  List<NotificationModel> unReadNotifications = [];
  List<NotificationModel> readNotifications = [];

  @override
  void initState() {
    /// get first index where the user read notification {if status == 3 >> then the user read this notification}
    int firstIndexOfReadNotifications = widget.allNotifications
        .indexWhere((notification) => notification.status == 3);

    // form flutter documentation if returned -1 then no Notifications read yet
    // if == 0 then the user viewed all the notifications
    // else then there are Notifications user see
    if (firstIndexOfReadNotifications == -1) {
      unReadNotifications = widget.allNotifications;
    } else if (firstIndexOfReadNotifications == 0) {
      readNotifications = widget.allNotifications;
    } else {
      unReadNotifications = widget.allNotifications
          .getRange(0, firstIndexOfReadNotifications)
          .toList();

      readNotifications = widget.allNotifications
          .getRange(
          firstIndexOfReadNotifications, widget.allNotifications.length)
          .toList();
    }
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView(
            children: [
              unReadNotifications.isNotEmpty
                  ? _getUnReadNotifications()
                  : const SizedBox.shrink(),
              readNotifications.isNotEmpty
                  ? _getReadNotifications()
                  : const SizedBox.shrink(),
            ],
          ),
        )
      ],
    );
  }

  /// all widgets needed

  Widget _getUnReadNotifications() {
    return Column(
      children: [
        _getTextOfNewEarlier(translate(LangKeys.newWord)),
        Column(
          children: unReadNotifications
              .map((e) => NotificationCard(
            notification: e,
            allNotifications: unReadNotifications,
            context: context,
          ))
              .toList(),
        )
      ],
    );
  }

  Widget _getReadNotifications() {
    return Column(
      children: [
        _getTextOfNewEarlier(translate(LangKeys.earlier)),
        Column(
          children: readNotifications
              .map((e) => NotificationCard(
            notification: e,
            allNotifications: readNotifications,
            context: context,
          ))
              .toList(),
        )
      ],
    );
  }

  /// get Word of the new or earlier
  Widget _getTextOfNewEarlier(String text) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        text,
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: ConstColors.app,
        ),
      ),
    );
  }
}
