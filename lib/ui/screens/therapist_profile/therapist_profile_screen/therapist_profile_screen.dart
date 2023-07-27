import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/checkout/checkout_screen/checkout_screen.dart';
import 'package:o7therapy/ui/screens/checkout/checkout_screen/confirm_booking_screen.dart';
import 'package:o7therapy/ui/screens/checkout/payment_details/payment_indebt.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/bloc/therapist_bio_bloc/therapist_bio_bloc.dart';
import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_bloc.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_available_slots_cubit/therapist_available_slots_cubit.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/profile_category.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/therapist_profile_body.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class TherapistProfileScreen extends BaseScreenWidget {
  static const routeName = '/therapist-profile-screen';

  const TherapistProfileScreen({Key? key}) : super(key: key);

  @override
  BaseState<TherapistProfileScreen> screenCreateState() =>
      _TherapistProfileScreenState();
}

class _TherapistProfileScreenState
    extends BaseScreenState<TherapistProfileScreen>
    with SingleTickerProviderStateMixin {
  FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  TherapistData therapistData = TherapistData();
  late final TabController _tabController;
  String slotDate = "";
  String slotId = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: ProfileCategories.values.length,
      vsync: this,
      initialIndex: 0,
    );
    analytics.logEvent(
        name: 'therapist_profile_clicked',
        parameters: {"therapist_profile": 1});
  }

  @override
  void didChangeDependencies() async {
    final args = ModalRoute.of(context)!.settings.arguments
        as Map<String, TherapistData>;
    therapistData = args['therapistModel'] as TherapistData;

    TherapistAvailableSlotsCubit.bloc(context)
        .getTherapistAvailableSlots(therapistData.id ?? "");

    TherapistBioBloc.bloc(context)
        .add(GetTherapistBioEvent(therapistData.id ?? ""));

    super.didChangeDependencies();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar:
            AppBarForMoreScreens(title: translate(LangKeys.therapistProfile)),
        body: TherapistProfileBody(
          tabController: _tabController,
          therapistData: therapistData,
          translate: translate,
        ),
        bottomNavigationBar: _getBookASessionButton(),
      ),
    );
  }

  //Get confirm booking button
  Widget _getBookASessionButton() {
    return BlocListener<TherapistProfileBloc, TherapistProfileState>(
      listener: (context, state) {
        if (state is NetworkError) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }

          TherapistAvailableSlotsCubit.bloc(context)
              .getTherapistAvailableSlots(therapistData.id ?? "");
          showToast(state.message);
        }
        if (state is ErrorState) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }

          TherapistAvailableSlotsCubit.bloc(context)
              .getTherapistAvailableSlots(therapistData.id ?? "");
          showToast(state.message);
        }
        if (state is LoadingTherapistProfile) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is AccumulativeSessionFeesState) {
          double fees = 0;
          if (state.accumulativeSessionFees.data?.currency == 'USD') {
            fees = state.accumulativeSessionFees.data!.usdAmount!;
          } else if (state.accumulativeSessionFees.data?.currency == 'EGP') {
            fees = state.accumulativeSessionFees.data!.egpAmount!;
          }

          /// code added here
          showDialogAlert(
              navigation: () {
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed(
                    PaymentInDebtScreen.routeName,
                    arguments: {
                      "promoCode": "",
                      "slotId": slotId,
                      "sessionFees": fees,
                      "therapistName": therapistData.name,
                      "sessionDate": slotDate,
                      "currency":
                          state.accumulativeSessionFees.data?.currency ?? "",
                      "therapistProfession": therapistData.canPrescribe == null
                          ? ""
                          : therapistData.canPrescribe!
                              ? translate(LangKeys.psychiatrist)
                              : translate(LangKeys.psychologist),
                      "image": therapistData.image!.url!
                    });
              },
              title: translate(LangKeys.youHaveAccumulativeFees),
              message:
                  '${translate(LangKeys.yourAccumulativeFeesIs)} ${fees.toString()} ${translateCurrency(state.accumulativeSessionFees.data?.currency)}');
        }
        if (state is CorporateState) {
          _handleSuccessNextButtonInScheduleClickedEvent();
          if (state.corporateDeal.data!.newFeesAmount! == 0) {
            Navigator.of(context).pushReplacementNamed(
                ConfirmBookingScreen.routeName,
                arguments: {
                  "therapistName": therapistData.name,
                  "therapistProfession": therapistData.canPrescribe == null
                      ? ""
                      : therapistData.canPrescribe!
                          ? translate(LangKeys.psychiatrist)
                          : translate(LangKeys.psychologist),
                  "sessionDate": state.slotDate,
                  "sessionFees": state.corporateDeal.data!.newFeesAmount!,
                  "currency": state.corporateDeal.data!.currency!,
                  "image": therapistData.image?.url,
                  "slotId": state.slotId,
                });
          } else {
            Navigator.of(context)
                .pushReplacementNamed(CheckoutScreen.routeName, arguments: {
              "therapistData": therapistData,
              "therapistName": therapistData.name,
              "therapistProfession": therapistData.canPrescribe == null
                  ? ""
                  : therapistData.canPrescribe!
                      ? translate(LangKeys.psychiatrist)
                      : translate(LangKeys.psychologist),
              "sessionDate": state.slotDate,
              "sessionFees": state.corporateDeal.data!.newFeesAmount!,
              "currency": state.corporateDeal.data!.currency!,
              "image": therapistData.image?.url,
              "slotId": state.slotId,
            });
          }
        } else if (state is InsuranceState) {
          _handleSuccessNextButtonInScheduleClickedEvent();
          if (state.insuranceDeal.data!.newFeesAmount! == 0) {
            Navigator.of(context).pushReplacementNamed(
                ConfirmBookingScreen.routeName,
                arguments: {
                  "therapistName": therapistData.name,
                  "therapistProfession": therapistData.canPrescribe == null
                      ? ""
                      : therapistData.canPrescribe!
                          ? translate(LangKeys.psychiatrist)
                          : translate(LangKeys.psychologist),
                  "sessionDate": state.slotDate,
                  "sessionFees": state.insuranceDeal.data!.newFeesAmount!,
                  "currency": state.insuranceDeal.data!.currency!,
                  "image": therapistData.image?.url,
                  "slotId": state.slotId,
                });
          } else {
            Navigator.of(context)
                .pushReplacementNamed(CheckoutScreen.routeName, arguments: {
              "therapistData": therapistData,
              "therapistName": therapistData.name,
              "therapistProfession": therapistData.canPrescribe == null
                  ? ""
                  : therapistData.canPrescribe!
                      ? translate(LangKeys.psychiatrist)
                      : translate(LangKeys.psychologist),
              "sessionDate": state.slotDate,
              "sessionFees": state.insuranceDeal.data!.newFeesAmount!,
              "currency": state.insuranceDeal.data!.currency!,
              "image": therapistData.image?.url,
              "slotId": state.slotId,
            });
          }
        }
        else if (state is RequestASessionState) {
          showDialogRequestSessionAlert(context,
              title: translate(LangKeys.thankYouForRequestingASession),
              message: translate(LangKeys.theTherapistHasBeenInformed));
        }
        else if (state is JoinWaitListState) {
          showDialogRequestSessionAlert(context,
              title: translate(LangKeys.youHaveJoinedWaitList),
              message: translate(LangKeys.therapistInformedJoinWaitList));
          TherapistAvailableSlotsCubit.bloc(context)
              .getTherapistAvailableSlots(therapistData.id ?? "");
        }
        else if (state is ClientDiscountsState) {
          if (state.user.data!.inDebt == true) {
            slotDate = state.slotDate;
            slotId = state.slotId;
            context
                .read<TherapistProfileBloc>()
                .add(AccumulativeSessionFeesEvent());
          }
          else if (state.user.data!.hasSessionsOnWallet == true) {
            _handleSuccessNextButtonInScheduleClickedEvent();
            Navigator.of(context).pushReplacementNamed(
                ConfirmBookingScreen.routeName,
                arguments: {
                  "therapistName": therapistData.name,
                  "therapistProfession": therapistData.canPrescribe == null
                      ? ""
                      : therapistData.canPrescribe!
                          ? translate(LangKeys.psychiatrist)
                          : translate(LangKeys.psychologist),
                  "sessionDate": state.slotDate,
                  "sessionFees": 0.0,
                  "currency": therapistData.currency,
                  "image": therapistData.image?.url,
                  "slotId": state.slotId,
                });
          }
          else if (state.user.data!.isFlatRate == true) {
            _handleSuccessNextButtonInScheduleClickedEvent();
            Navigator.of(context).pushReplacementNamed(
                ConfirmBookingScreen.routeName,
                arguments: {
                  "therapistName": therapistData.name,
                  "therapistProfession": therapistData.canPrescribe == null
                      ? ""
                      : therapistData.canPrescribe!
                          ? translate(LangKeys.psychiatrist)
                          : translate(LangKeys.psychologist),
                  "sessionDate": state.slotDate,
                  "sessionFees": 0.0,
                  "currency": therapistData.currency,
                  "image": therapistData.image?.url,
                  "slotId": state.slotId,
                });
          }
          else if (state.user.data!.isCorporate == true) {
            context
                .read<TherapistProfileBloc>()
                .add(CheckIsCorporate(state.slotId, state.slotDate));
          }
          else if (state.user.data!.isInsurance == true) {
            context
                .read<TherapistProfileBloc>()
                .add(CheckIsInsurance(state.slotId, state.slotDate));
          }
          else {
            _handleSuccessNextButtonInScheduleClickedEvent();
            Navigator.of(context)
                .pushReplacementNamed(CheckoutScreen.routeName, arguments: {
              "therapistData": therapistData,
              "therapistName": therapistData.name,
              "therapistProfession": therapistData.canPrescribe == null
                  ? ""
                  : therapistData.canPrescribe!
                      ? translate(LangKeys.psychiatrist)
                      : translate(LangKeys.psychologist),
              "sessionDate": state.slotDate,
              "sessionFees": therapistData.feesPerSession,
              "currency": therapistData.currency,
              "image": therapistData.image?.url,
              "slotId": state.slotId,
            });
          }
        }
      },
      child: const SizedBox.shrink(),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  showDialogAlert(
      {required Function() navigation,
      required String title,
      required String message}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => SimpleDialog(
              title: Padding(
                padding: EdgeInsets.symmetric(horizontal: width / 10),
                child: Center(
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: ConstColors.app))),
              ),
              children: [
                SimpleDialogOption(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ConstColors.text),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            backgroundColor: MaterialStateProperty.all<Color>(
                                ConstColors.appWhite),
                            foregroundColor: MaterialStateProperty.all<Color>(
                                ConstColors.app),
                            shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                    side: const BorderSide(
                                        color: ConstColors.app)))),
                        onPressed: () {
                          TherapistAvailableSlotsCubit.bloc(context)
                              .getTherapistAvailableSlots(
                                  therapistData.id ?? "");
                          Navigator.of(context).pop();
                        },
                        child: Text(translate(LangKeys.payLater))),
                    const SizedBox(width: 20),
                    ElevatedButton(
                        onPressed: navigation,
                        style: ButtonStyle(
                            elevation: MaterialStateProperty.all(0),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30.0),
                            ))),
                        child: Text(translate(LangKeys.yesSure))),
                  ],
                )
              ],
            ));
  }

  showDialogRequestSessionAlert(BuildContext context,
      {required String title, required String message}) {
    TherapistAvailableSlotsCubit.bloc(context)
        .getTherapistAvailableSlots(therapistData.id ?? "");
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                Center(
                    child: Text(title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: ConstColors.textSecondary))),
                Center(
                    child: Text(therapistData.name!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: ConstColors.app))),
                const SizedBox(height: 24.0),
                Container(
                    color: ConstColors.accentColor,
                    width: width / 1.8,
                    height: 1),
                const SizedBox(height: 24.0),
                Center(
                  child: Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: ConstColors.textSecondary),
                  ),
                )
              ]));
        });
  }

  /// will trigger when navigate to CheckoutScreen -or- ConfirmBookingScreen
  /// to pay for the session
  void _handleSuccessNextButtonInScheduleClickedEvent() {
    MixpanelBookingBloc.bloc(context)
        .add(const SuccessNextButtonInScheduleClickedEvent());
  }
}
