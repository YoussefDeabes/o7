import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/ui/screens/activity/widgets/no_activity_widget.dart';

class ActivityGuestScreen extends BaseScreenWidget {
  static const routeName = '/activity-guest-screen';

  const ActivityGuestScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _ActivityGuestScreenState();
}

class _ActivityGuestScreenState extends BaseScreenState<ActivityGuestScreen> {
  @override
  Widget buildScreenWidget(BuildContext context) {
    return const Scaffold(
      body: NoActivityWidget(),
    );
  }
}
