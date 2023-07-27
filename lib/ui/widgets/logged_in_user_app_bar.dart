import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_bloc/send_bird_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/un_read_messages_count_bloc/un_read_messages_count_bloc.dart';
import 'package:o7therapy/ui/screens/messages/screens/contacts_screen.dart';
import 'package:o7therapy/ui/screens/booking/widgets/booking_screen_icon.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in_notification_bloc/home_main_logged_in_notification_bloc.dart';
import 'package:o7therapy/ui/screens/notifications/bloc/notifications_bloc.dart';
import 'package:o7therapy/ui/screens/notifications/screen/notifications_screen.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// get AppBar For the logged in user that contains the bell icon and message icon and the title Text
/// this app bar used in (Home -Booking -Activity -More) screens
class LoggedInUserAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final TabController tabController;
  const LoggedInUserAppBar(this.tabController, {Key? key}) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 16),
        alignment: Alignment.topCenter,
        color: ConstColors.scaffoldBackground,
        width: context.width,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _AppBarTitle(tabController),
            const _BellIconAndMessageIcon()
          ],
        ),
      ),
    );
  }
}

class _AppBarTitle extends StatelessWidget {
  const _AppBarTitle(this._tabController);

  final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: AnimatedBuilder(
        animation: _tabController,
        builder: (context, child) {
          return FutureBuilder<String?>(
            future: PrefManager.getName(),
            builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
              final String appBarTitleName =
                  context.translate(_getTitles[_tabController.index]);
              return Text(
                _getTitle(appBarTitleName, snapshot),
                style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w700,
                    color: ConstColors.app),
              );
            },
          );
        },
      ),
    );
  }

  _getTitle(String appBarTitleName, AsyncSnapshot<String?> snapshot) {
    return "$appBarTitleName${_getWelcomeClientTitle(HomeMainLoggedInPages.values[_tabController.index], snapshot.hasData ? snapshot.data! : "")}";
  }

  static const List<String> _getTitles = [
    LangKeys.welcomeTitle,
    LangKeys.activity,
    LangKeys.services,
    LangKeys.rassel,
    LangKeys.more,
  ];

  _getWelcomeClientTitle(HomeMainLoggedInPages page, String data) {
    if (page == HomeMainLoggedInPages.homeLoggedInScreen) {
      return ", ${data.split(' ').length > 1 ? data.split(' ')[0] : data.trim()}!";
    }
    return "";
  }
}

/// get the 2 icons of message and the bell
class _BellIconAndMessageIcon extends StatelessWidget {
  const _BellIconAndMessageIcon({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _getMessagesIconButtonWidget(),
        SizedBox(width: 0.02 * context.width),

        // SizedBox(width: 0.05 * width),
        BlocBuilder<HomeMainLoggedInNotificationBloc,
            HomeMainLoggedInNotificationState>(
          builder: (context, state) {
            if (state is LoadedHomeMainLoggedInNotificationState) {
              return BookingScreenIcon(
                assetPath: AssPath.notificationDot,
                onTap: () {
                  NotificationsBloc.bloc(context).add(const MarkAllAsRead());
                  if (NotificationsBloc.bloc(context).state
                      is ExceptionNotificationsState) {
                  } else {
                    Navigator.pushNamed(context, NotificationsScreen.routeName)
                        .then((value) =>
                            HomeMainLoggedInNotificationBloc.bloc(context)
                                .add(const GetUnreadNotificationsCountEvent()));
                  }
                },
              );
            } else {
              return BookingScreenIcon(
                assetPath: AssPath.bellIcon,
                onTap: () {
                  Navigator.pushNamed(context, NotificationsScreen.routeName);
                },
              );
            }
          },
        ),
      ],
    );
  }
}

Widget _getMessagesIconButtonWidget() {
  return BlocListener<SendBirdBloc, SendBirdState>(
    listenWhen: (previous, current) => current is SuccessConnectedSendBirdState,
    listener: (context, state) {
      /// when the SBChannelsBloc is connected to sendBird
      /// then enable the messages count event
      if (state is SuccessConnectedSendBirdState) {
        UnReadMessagesCountBloc.bloc(context)
            .add(const EnableUnReadMessagesCountListenerEvent());
      }
    },
    child: BlocBuilder<UnReadMessagesCountBloc, UnReadMessagesCountState>(
      builder: (context, state) {
        String iconAssetPath = AssPath.messageSquareIcon;

        /// if there is  New UnReadMessagesState
        /// then update the messages notification icon to icon with dot
        if (state is NewUnReadMessagesState) {
          iconAssetPath = AssPath.msgsNotification;
        }
        return BookingScreenIcon(
          assetPath: iconAssetPath,
          onTap: () {
            SBChannelsBloc.bloc(context)
                .add(const GetExistingSBChannelsEvent());
            Navigator.pushNamed(context, ContactsScreen.routeName);
          },
        );
      },
    ),
  );
}
