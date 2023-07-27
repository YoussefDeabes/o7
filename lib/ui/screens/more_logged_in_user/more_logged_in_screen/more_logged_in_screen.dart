import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/notifications_api_manager.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/filter_min_max_values.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/ui/screens/change_password/screens/change_password_screen.dart';
import 'package:o7therapy/ui/screens/ewp/bloc/ewp_bloc.dart';
import 'package:o7therapy/ui/screens/ewp/ewp_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in_notification_bloc/home_main_logged_in_notification_bloc.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/ui/screens/home_logged_in/home_screen_therapists_bloc/home_screen_therapists_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/screen/insurance_screen.dart';
import 'package:o7therapy/ui/screens/more_guest/widgets/choose_language_widget.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/about_o7_therapy_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/faqs_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/logout_widget.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/privacy_policy_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/terms_and_conditions_more_screen_section_tile.dart';
import 'package:o7therapy/ui/screens/my-subscriptions/screens/my_subscriptions_screen.dart';
import 'package:o7therapy/ui/screens/payment_methods/payment_methods/payment_methods_screen.dart';
import 'package:o7therapy/ui/screens/sessions_credit/sessions_wallet_screen/sessions_wallet_screen.dart';
import 'package:o7therapy/ui/screens/payment_history/screen/payment_history_screen.dart';
import 'package:o7therapy/ui/screens/web_view/web_view_screen.dart';
import 'package:o7therapy/ui/widgets/contact_us/contact_us_mixin.dart';
import 'package:o7therapy/ui/screens/more_logged_in_user/widgets/more_screen_section_widget.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:share_plus/share_plus.dart';

import '../../profile/screens/profile_screen.dart';

class MoreLoggedInUserScreen extends BaseStatefulWidget {
  static const routeName = '/More-logged-in-screen';

  const MoreLoggedInUserScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> baseCreateState() =>
      _MoreLoggedInUserScreenState();
}

class _MoreLoggedInUserScreenState extends BaseState<MoreLoggedInUserScreen>
    with ContactUsMixin {
  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      body: _getBody(),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// get the body of the screen
  Widget _getBody() {
    return Container(
      alignment: AlignmentDirectional.topStart,
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: _getMoreLoggedInUserScreenContent(),
    );
  }

  // the content of the More screen
  Widget _getMoreLoggedInUserScreenContent() {
    return SafeArea(
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: height * 0.03),
                  _getUserNameAndAddress(),
                  SizedBox(height: height * 0.03),
                  _getAccountSection(),
                  SizedBox(height: height * 0.03),
                  // _getMedicalProfileSection(),
                  // SizedBox(height: height * 0.03),
                  _getPaymentSection(),
                  SizedBox(height: height * 0.03),
                  _getAppSection(),
                  ChooseLanguageWidget(
                    onLanguageChanged: _onLanguageChanged,
                  ),
                  // const Divider(),
                  const LogoutWidget(),
                  SizedBox(height: height * 0.03),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// get user name/nickName and his main e-mail
  Widget _getUserNameAndAddress() {
    return Column(
      children: [
        // user name / nickname
        FutureBuilder<String?>(
          future: PrefManager.getName(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  snapshot.data ?? "",
                  style: const TextStyle(
                    color: ConstColors.app,
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),

        // user email
        FutureBuilder<String?>(
          future: PrefManager.getEmail(),
          builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
            if (snapshot.hasData) {
              return Container(
                alignment: Alignment.center,
                child: Text(
                  snapshot.data ?? "",
                  style: const TextStyle(
                    color: ConstColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ],
    );
  }

  // TODO :: All sections tiles need to implemented
  /// get account section and its data
  Widget _getAccountSection() {
    return MoreScreenSectionWidget(
        title: translate(LangKeys.yourAccount),
        children: [
          MoreScreenSectionTile(
            title: translate(LangKeys.profile),
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProfileScreen.routeName)
                  .then((value) => setState(() {}));
            },
          ),
          // MoreScreenSectionTile(
          //   title: translate(LangKeys.notifications),
          //   onTap: () {},
          // ),
          // MoreScreenSectionTile(
          //   title: translate(LangKeys.profile),
          //   onTap: () {},
          // ),
          // MoreScreenSectionTile(
          //   title: translate(LangKeys.notifications),
          //   onTap: () {},
          // ),

          MoreScreenSectionTile(
            title: translate(LangKeys.changePassword),
            onTap: () {
              Navigator.of(context).pushNamed(ChangePasswordScreen.routeName);
            },
          ),
          // MoreScreenSectionTile(
          //   title: translate(LangKeys.familyMembers),
          //   onTap: () {},
          // ),
          MoreScreenSectionTile(
            title: translate(LangKeys.mySubscriptions),
            onTap: () {
              Navigator.of(context).pushNamed(MySubscriptionScreen.routeName);
            },
          ),
        ]);
  }

  /// get Medical Profile section and its data
  Widget _getMedicalProfileSection() {
    return MoreScreenSectionWidget(
      title: translate(LangKeys.medicalProfile),
      children: [
        MoreScreenSectionTile(
          title: translate(LangKeys.therapeuticPlan),
          onTap: () {},
        ),
        MoreScreenSectionTile(
          title: translate(LangKeys.intakeForm),
          onTap: () {},
        ),
        MoreScreenSectionTile(
          title: translate(LangKeys.prescriptions),
          onTap: () {},
        ),
        MoreScreenSectionTile(
          title: translate(LangKeys.assessments),
          onTap: () {},
        ),
      ],
    );
  }

  /// get Payment section and its data
  Widget _getPaymentSection() {
    return MoreScreenSectionWidget(
      title: translate(LangKeys.payment),
      children: [
        MoreScreenSectionTile(
          title: translate(LangKeys.paymentMethod),
          onTap: () {
            Navigator.of(context).pushNamed(PaymentMethodsScreen.routeName);
          },
        ),
        MoreScreenSectionTile(
          title: translate(LangKeys.sessionsCredit),
          onTap: () {
            Navigator.of(context).pushNamed(SessionsWalletScreen.routeName);
          },
        ),
        MoreScreenSectionTile(
          title: translate(LangKeys.myEmployeesWellnessPlan),
          onTap: () {
            EwpBloc.getBloc(context).add(const GetEwpEvent());
            Navigator.of(context).pushNamed(EwpScreen.routeName);
          },
        ),
        // MoreScreenSectionTile(
        //   title: translate(LangKeys.paymentHistory),
        //   onTap: () =>
        //       Navigator.pushNamed(context, PaymentHistoryScreen.routeName),
        // ),
        MoreScreenSectionTile(
          title: translate(LangKeys.insurance),
          onTap: () {
            Navigator.pushNamed(context, InsuranceScreen.routeName);
          },
        ),
      ],
    );
  }

  /// get App section and its data
  Widget _getAppSection() {
    return MoreScreenSectionWidget(
      title: translate(LangKeys.app),
      children: [
        const AboutO7TherapyMoreScreenSectionTile(),
        const FaqsMoreScreenSectionTile(),
        MoreScreenSectionTile(
          title: translate(LangKeys.contactUs),
          trailingIcon: false,
          onTap: () {
            getContactUsOnPressed(context);
          },
        ),
        const PrivacyPolicyMoreScreenSectionTile(),
        const TermsAndConditionsMoreScreenSectionTile(),
        MoreScreenSectionTile(
          title: translate(LangKeys.invitePeople),
          trailingIcon: false,
          onTap: () {
            Share.share('http://onelink.to/7upcxb');
          },
        ),
        // MoreScreenSectionTile(
        //   title: translate(LangKeys.complainsOrFeedback),
        //   onTap: () {},
        //),
        // MoreScreenSectionTile(
        //   title: translate(LangKeys.changeLanguage),
        //   onTap: () {},
        // ),
      ],
    );
  }

  void _onLanguageChanged() {
    CheckUserDiscountCubit.bloc(context).checkUserDiscountEvent();
    FilterMinMaxValues().getFilterPriceData();
    NotificationsApiManager.registerForNotificationApi();

    TherapistsBookedBeforeBloc.bloc(context)
        .add(const GetTherapistsBookedBeforeEvent());

    HomeScreenTherapistsBloc.bloc(context).add(const GetThreeTherapistsEvent());
  }
}
