import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/activity/activity_guest/activity_guest_screen.dart';
import 'package:o7therapy/ui/screens/booking_guest/booking_guest_screen/booking_guest_screen.dart';
import 'package:o7therapy/ui/screens/home_guest/home_guest/home_guest_screen.dart';
import 'package:o7therapy/ui/screens/more_guest/more_guest_screen/more_guest_screen.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_guest_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';

class HomeMainScreen extends BaseScreenWidget {
  static const routeName = '/home-main-screen';

  const HomeMainScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _HomeMainScreenState();
}

class _HomeMainScreenState extends BaseScreenState<HomeMainScreen>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;
  int servicesScreenIndex = 0;
  DateTime? currentBackPressTime;
  bool fromLogin = false;

  @override
  void initState() {
    _tabController = TabController(length: 5, vsync: this);
    Future.delayed(Duration.zero, () {
      setState(() {
        int? index = ModalRoute.of(context)?.settings.arguments as int? ??
            _tabController?.index;
        _tabController!.animateTo(index ?? 0);
      });
    });
    exitFullScreen();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController!.dispose();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
        bottomNavigationBar: _getBottomNavigation(),
        body: _getBody(servicesScreenIndex),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// Bottom navigation items
  BottomNavigationBar _getBottomNavigation() {
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
  }

  // Getting screen based on selected bottom navigation item
  Widget _getBody(servicesScreenIndex) {
    return TabBarView(
      physics: const NeverScrollableScrollPhysics(),
      controller: _tabController,
      children: const [
        HomeGuestScreen(),
        ActivityGuestScreen(),
        BookingGuestScreen(),
        RasselGuestScreen(),
        MoreGuestScreen(),
      ],
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////
  /// Change current index to index of selected item
  void onBottomItemSelected(int index) {
    setState(() {
      _tabController!.animateTo(index);
    });
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

  /// onWillPop
  Future<bool> _onWillPop() async {
    /// if the current index not home screen == 0
    /// then navigate to home screen >> and not leave
    /// else user at home screen >> show the msg to press again to out
    if (_tabController!.index != 0) {
      setState(() => _tabController!.animateTo(0));
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
