import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking_guest/cubit/selected_tab_cubit.dart';
import 'package:o7therapy/ui/screens/booking_guest/widgets/selected_tab_widget_widget.dart';
import 'package:o7therapy/ui/screens/booking_guest/widgets/presentation_card.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/ui/widgets/get_started_widget.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/ui/widgets/contact_us/contact_us_mixin.dart';

const EdgeInsetsDirectional _indicatorAndLabelPadding =
    EdgeInsetsDirectional.only(end: 8);

enum SelectedTab {
  oneOnOne(
    tabLabel: LangKeys.oneOnOneSessions,
    cardTitle: LangKeys.oneOnOneSessions,
    cardAssetPath: AssPath.oneOnOneGuest,
    cardDescription: LangKeys.onOnOneSessionsGuestDesc,
  ),
  groupTherapy(
    tabLabel: LangKeys.groupTherapy,
    cardTitle: LangKeys.groupTherapySessions,
    cardAssetPath: AssPath.groupTherapyGuest,
    cardDescription: LangKeys.groupTherapySessionsGuestDesc,
  ),
  workshops(
    tabLabel: LangKeys.workshopsAndWebinars,
    cardTitle: LangKeys.workshopsAndWebinars,
    cardAssetPath: AssPath.groupTherapyGuest,
    cardDescription: LangKeys.workshopsSessionsGuestDesc,
  ),
  assessmentAndTesting(
    tabLabel: LangKeys.assessmentsAndTesting,
    cardTitle: LangKeys.assessmentsAndTesting,
    cardAssetPath: AssPath.programsGuest,
    cardDescription: LangKeys.assessmentAndTestingGuestDesc,
  ),
  programs(
    tabLabel: LangKeys.programs,
    cardTitle: LangKeys.programs,
    cardAssetPath: AssPath.assessmentAndTesting,
    cardDescription: LangKeys.programsGuestDesc,
  ),
  couplesTherapy(
    tabLabel: LangKeys.couplesTherapy,
    cardTitle: LangKeys.couplesTherapy,
    cardAssetPath: AssPath.couplesGuest,
    cardDescription: LangKeys.couplesTherapyGuestDesc,
  );

  const SelectedTab({
    required this.tabLabel,
    required this.cardAssetPath,
    required this.cardTitle,
    required this.cardDescription,
  });
  final String tabLabel;
  final String cardAssetPath;
  final String cardTitle;
  final String cardDescription;
}

class BookingGuestScreen extends BaseScreenWidget {
  static const routeName = '/booking-guest-screen';
  const BookingGuestScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() {
    return _BookingScreenState();
  }
}

class _BookingScreenState extends BaseScreenState<BookingGuestScreen>
    with ContactUsMixin, SingleTickerProviderStateMixin {
  late final TabController _selectedTabController;

  @override
  void initState() {
    super.initState();
    _selectedTabController = TabController(
      length: SelectedTab.values.length,
      vsync: this,
    );
    _selectedTabController.addListener(_handleTabSelection);
  }

  _handleTabSelection() {
    SelectedTabCubit.bloc(context).changeTab(
      SelectedTab.values[_selectedTabController.index],
    );
  }

  @override
  void dispose() {
    _selectedTabController.removeListener(_handleTabSelection);
    _selectedTabController.dispose();
    super.dispose();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return DefaultTabController(
      length: SelectedTab.values.length,
      child: Scaffold(
        body: BlocConsumer<SelectedTabCubit, SelectedTab>(
          listener: (context, state) {
            _selectedTabController.animateTo(state.index);
          },
          builder: (context, state) {
            _selectedTabController.animateTo(state.index);
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              child: SafeArea(
                child: Column(
                  children: [
                    _getServicesText(),
                    TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicatorWeight: 0.0,
                      isScrollable: true,
                      indicator: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: ConstColors.app,
                      ),
                      labelColor: ConstColors.appWhite,
                      unselectedLabelColor: ConstColors.text,
                      labelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ConstColors.appWhite,
                      ),
                      unselectedLabelStyle: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ConstColors.text,
                      ),
                      controller: _selectedTabController,
                      padding: EdgeInsets.zero,
                      indicatorPadding: _indicatorAndLabelPadding,
                      labelPadding: _indicatorAndLabelPadding,
                      tabs: SelectedTab.values
                          .map((tab) => SelectedTabWidget(selectedTab: tab))
                          .toList(),
                    ),
                    Expanded(
                      child: TabBarView(
                        // physics: const NeverScrollableScrollPhysics(),
                        controller: _selectedTabController,
                        children: SelectedTab.values.map((tab) {
                          return Column(
                            children: [
                              PresentationCard(
                                image: tab.cardAssetPath,
                                title: translate(tab.cardTitle),
                                description: translate(tab.cardDescription),
                              ),
                              if (state != SelectedTab.oneOnOne)
                                _getButton(state, () {
                                  getContactUsOnPressed(context);
                                }),
                              if (state == SelectedTab.oneOnOne)
                                _getButton(
                                    state,
                                    () => showModalBottomSheet<void>(
                                          backgroundColor: Colors.white,
                                          context: context,
                                          isScrollControlled: true,
                                          clipBehavior: Clip.antiAlias,
                                          shape: const RoundedRectangleBorder(
                                              borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(16.0),
                                            topRight: Radius.circular(16.0),
                                          )),
                                          builder: (BuildContext context) =>
                                              GetStartedWidget(),
                                        )),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const Align(
                      alignment: Alignment.bottomCenter,
                      child: FooterWidget(),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  //Start now button
  Widget _getButton(SelectedTab selectedTab, Function() onPressed) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(left: width / 10, right: width / 10),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          child: selectedTab == SelectedTab.oneOnOne
              ? Text(translate(LangKeys.getStarted))
              : Text(translate(LangKeys.contactUs)),
        ),
      ),
    );
  }

  // Get Text for the service and the booking
  Widget _getText(String text, {double? topMargin}) {
    return Padding(
      padding: EdgeInsets.only(top: topMargin ?? 0.05 * height),
      child: Align(
        alignment: AlignmentDirectional.topStart,
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.w700,
              color: ConstColors.app),
        ),
      ),
    );
  }

  Widget _getServicesText() {
    return _getText(translate(LangKeys.services), topMargin: 0.02 * height);
  }
}
