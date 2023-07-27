import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/api/notifications_api_manager.dart';
import 'package:o7therapy/bloc/get_matched_pressed_bloc/get_matched_button_bloc.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/activity/activity_logged_in/activity_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/filter_min_max_values.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/ui/screens/booking/booking_screen/booking_screen.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/rassel_card_bloc/rassel_card_bloc.dart';
import 'package:o7therapy/ui/screens/home_logged_in/home_logged_in/home_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_bloc/send_bird_bloc.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/more_logged_in_screen/more_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_screen.dart';
import 'package:o7therapy/ui/screens/splash/cubit/refresh_token_cubit.dart';
import 'package:o7therapy/ui/widgets/logged_in_user_app_bar.dart';
import 'package:o7therapy/util/check_force_update_util.dart';
import 'package:o7therapy/util/firebase/analytics/analytics_helper.dart';
import 'package:o7therapy/util/firebase/analytics/auth_analytics.dart';

import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../home_logged_in/home_screen_therapists_bloc/home_screen_therapists_bloc.dart';
import '../home_main_logged_in_notification_bloc/home_main_logged_in_notification_bloc.dart';

enum HomeMainLoggedInPages {
  homeLoggedInScreen,
  activityLoggedInScreen,
  bookingScreen,
  rasselScreen,
  moreLoggedInUserScreen,
}

const HomeMainLoggedInPages initHomePage =
    HomeMainLoggedInPages.homeLoggedInScreen;

class HomeMainLoggedInScreen extends BaseScreenWidget {
  static const routeName = '/home-main-logged-in-screen';
  final bool? fromLogin;
  const HomeMainLoggedInScreen({Key? key, this.fromLogin}) : super(key: key);

  @override
  BaseState<HomeMainLoggedInScreen> screenCreateState() =>
      _HomeMainLoggedInScreenState();
}

class _HomeMainLoggedInScreenState
    extends BaseScreenState<HomeMainLoggedInScreen>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  TabController? _tabController;
  // final ValueNotifier<HomeMainLoggedInPages> _currentHomePage =
  //     ValueNotifier<HomeMainLoggedInPages>(
  //
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
          FlutterLocalNotificationsPlugin();
      FlutterAppBadger.removeBadge();
      await _flutterLocalNotificationsPlugin.cancelAll();
    }
  }

  late final AuthState authState;
  DateTime? currentBackPressTime;
  bool fromLogin = false;
  late final Mixpanel _mixpanel;

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _tabController?.removeListener(_tabChangedListenerForAnalytics);
    _tabController!.dispose();
    // _currentHomePage.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    RefreshTokenState state = RefreshTokenCubit.cubit(context).state;
    if (state is FalseRefreshToken) {
      clearData();
      RefreshTokenCubit.cubit(context).reset();
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (Route<dynamic> route) => false,
      );
    }
  }

  @override
  void initState() {
    _initMixpanel();
    _tabController = TabController(
      length: HomeMainLoggedInPages.values.length,
      vsync: this,
    );
    _tabController?.addListener(_tabChangedListenerForAnalytics);
    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      final HomeMainLoggedInPages newHomePage = ModalRoute.of(context)
              ?.settings
              .arguments as HomeMainLoggedInPages? ??
          initHomePage;

      setState(() => _tabController!.animateTo(newHomePage.index));
      // _currentHomePage.value = newHomePage;

      CheckForceUpdateUtil.checkForceUpdate(context);
    });
    fromLogin = widget.fromLogin ?? false;

    CheckUserDiscountCubit.bloc(context).checkUserDiscountEvent();

    context.read<RasselBloc>().add(RasselInitialEvt());
    RasselCardBloc.bloc(context).add(const CheckRasselCardIsDismissedEvent());
    GetMatchedButtonBloc.bloc(context).add(const CheckGetMatchedCardEvent());

    HomeScreenTherapistsBloc.bloc(context).add(const GetThreeTherapistsEvent());
    FilterMinMaxValues().getFilterPriceData();
    NotificationsApiManager.registerForNotificationApi();

    TherapistsBookedBeforeBloc.bloc(context)
        .add(const GetTherapistsBookedBeforeEvent());

    HomeMainLoggedInNotificationBloc.bloc(context)
        .add(const GetUnreadNotificationsCountEvent());

    /// connect user send bird while the main home screen opens
    SendBirdBloc.bloc(context).add(const ConnectSendBirdEvent());

    HomeMainLoggedInNotificationBloc.bloc(context)
        .add(const GetUnreadNotificationsCountEvent());

    authState = context.read<AuthBloc>().state;
    exitFullScreen();
    super.initState();
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }

  void _tabChangedListenerForAnalytics() {
    AnalyticsHelper.i.changeTab(
      screenName: HomeMainLoggedInPages.values[_tabController!.index].name,
    );
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: getBottomNavigation(),
        appBar: LoggedInUserAppBar(_tabController!),
        body: BlocConsumer<CheckUserDiscountCubit, CheckUserDiscountState>(
            builder: (context, state) {
          return _getBody();
        }, listener: (context, state) async {
          if (state is LoadedUserDiscountState) {
            String? corporateName = await PrefManager.getCorporateName();
            String? userRefNumber = await PrefManager.getUserRefNumber();
            bool isCorporate = await PrefManager.isCorporate();
            AuthAnalytics.i.setUserId(id: userRefNumber);
            _mixpanel.registerSuperProperties(
                {"User Reference Number": userRefNumber});
            if (fromLogin) {
              AuthAnalytics.i.successLogin(
                corporateName: corporateName,
                isCorporate: isCorporate,
              );
              _mixpanel.track("Successful Login", properties: {
                "Corporate Name": corporateName,
                "Client type": isCorporate ? "Corporate" : "Individual"
              });
              setState(() {
                fromLogin = false;
              });
            }
          }
        }),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// Bottom navigation items
  Widget getBottomNavigation() {
    return AnimatedBuilder(
      animation: _tabController as ChangeNotifier,
      builder: (context, child) {
        return BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          unselectedItemColor: ConstColors.bottomNavNotSelected,
          backgroundColor: ConstColors.bottomNavBackground,
          currentIndex: _tabController!.index,
          onTap: onBottomItemSelected,
          showSelectedLabels: true,
          selectedLabelStyle:
              const TextStyle(fontWeight: FontWeight.bold, fontSize: 10),
          unselectedFontSize: 10,
          items: [
            getCustomBottomNavigationBarItem(
              unSelectedImagePath: AssPath.unSelectedHomeIcon,
              imagePath: AssPath.homeIcon,
              label: translate(LangKeys.home),
            ),
            getCustomBottomNavigationBarItem(
              unSelectedImagePath: AssPath.unSelectedActivityIcon,
              imagePath: AssPath.activityIcon,
              label: translate(LangKeys.activity),
            ),
            getCustomBottomNavigationBarItem(
              unSelectedImagePath: AssPath.unSelectedBookingIcon,
              imagePath: AssPath.bookingIcon,
              label: translate(LangKeys.services),
            ),
            getCustomBottomNavigationBarItem(
              unSelectedImagePath: AssPath.unSelectedRasselIconSvg,
              imagePath: AssPath.rasselIconSvg,
              label: translate(LangKeys.rassel),
            ),
            getCustomBottomNavigationBarItem(
              unSelectedImagePath: AssPath.unSelectedMoreIcon,
              imagePath: AssPath.moreIcon,
              label: translate(LangKeys.more),
            ),
          ],
        );
      },
    );
  }

  // Getting screen based on selected bottom navigation item
  Widget _getBody() {
    switch (HomeMainLoggedInPages.values[_tabController!.index]) {
      case HomeMainLoggedInPages.homeLoggedInScreen:
        return const HomeLoggedInScreen();
      case HomeMainLoggedInPages.activityLoggedInScreen:
        return const ActivityLoggedInScreen();
      case HomeMainLoggedInPages.bookingScreen:
        return const BookingScreen();
      case HomeMainLoggedInPages.rasselScreen:
        return const RasselScreen();
      case HomeMainLoggedInPages.moreLoggedInUserScreen:
        return const MoreLoggedInUserScreen();
    }
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////
  /// Change current index to index of selected item
  void onBottomItemSelected(int index) {
    setState(() => _tabController!.animateTo(index));
    // _currentHomePage.value = HomeMainLoggedInPages.values[index];
  }

  BottomNavigationBarItem getCustomBottomNavigationBarItem({
    required String unSelectedImagePath,
    required String imagePath,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: SvgPicture.asset(
        unSelectedImagePath,
        // scale: scale ?? 2.5,
        height: 29,
      ),
      label: label,
      activeIcon: SvgPicture.asset(
        imagePath,
        height: 29,
        // scale: scale ?? 2.5,
      ),
    );
  }

  void _launchUrl(String url, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      final snackBar = SnackBar(
        content: Text(translate(LangKeys.errorOccurred)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  ///
  /// Helper Methods
  ///

  /// onWillPop
  Future<bool> _onWillPop() async {
    /// if the current index not home screen
    /// then navigate to home screen >> and not leave
    /// else user at home screen >> show the msg to press again to out
    if (_tabController!.index != initHomePage.index) {
      setState(() => _tabController!.animateTo(initHomePage.index));
      // _currentHomePage.value = initHomePage;

      return Future.value(false);
    } else {
      DateTime now = DateTime.now();
      if (currentBackPressTime == null ||
          now.difference(currentBackPressTime ?? now) >
              const Duration(seconds: 3)) {
        currentBackPressTime = now;
        showToast(translate(LangKeys.pressAgainToExitTheApp));
        return Future.value(false);
      } else {
        return Future.value(true);
      }
    }
  }
}
