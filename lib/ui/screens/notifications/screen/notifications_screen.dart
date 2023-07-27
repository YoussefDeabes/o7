import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/notifications/bloc/notifications_bloc.dart';
import 'package:o7therapy/ui/screens/notifications/widgets/no_notifications_available_page.dart';
import 'package:o7therapy/ui/screens/notifications/widgets/notifications_list_page.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/custom_error_widget.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class NotificationsScreen extends BaseScreenWidget {
  static const routeName = '/notifications-screen';

  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> screenCreateState() {
    return _NotificationsScreenState();
  }
}

class _NotificationsScreenState extends BaseScreenState<NotificationsScreen> {
  @override
  void initState() {
    NotificationsBloc.bloc(context).add(const GetNotifications());
    super.initState();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBarForMoreScreens(title: translate(LangKeys.notifications)),
      body: SafeArea(
        child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: BlocConsumer<NotificationsBloc, NotificationsState>(
              listener: (context, state) {
                if (state is LoadingFileState ||
                    state is LoadingNotificationsState) {
                  showLoading();
                } else {
                  hideLoading();
                }
              },
              builder: (context, state) {
                if (state is LoadedNotificationsState) {
                  return NotificationsListPage(
                    allNotifications: state.allNotifications,
                  );
                } else if (state is ExceptionNotificationsState) {
                  if (state.msg == "Session expired") {
                    clearData();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.routeName, (Route<dynamic> route) => false);
                  }
                  showToast(state.msg);
                  return CustomErrorWidget(state.msg);
                } else if (state is EmptyNotificationsState) {
                  return NoNotificationsAvailablePage();
                }else if (state is LoadingFileState){
                  return NotificationsListPage(
                    allNotifications: state.allNotifications,
                  );
                }else if (state is LoadedFileState){
                  return NotificationsListPage(
                    allNotifications: state.allNotifications,
                  );
                }
                return Container();
              },
            )),
      ),
    );
  }
}
