import 'package:cached_network_image/cached_network_image.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';

import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_bloc.dart';
import 'package:o7therapy/ui/screens/checkout/success_payment_screen/success_payment_screen.dart';
import 'package:o7therapy/ui/screens/checkout/widgets/cancelation-policy-all-users-type-widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class ConfirmBookingScreen extends BaseScreenWidget {
  static const routeName = '/confirm-booking-screen';

  const ConfirmBookingScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _ConfirmBookingScreenState();
}

class _ConfirmBookingScreenState extends BaseScreenState<ConfirmBookingScreen> {
  String therapistName = "";
  String therapistProfession = "";
  String sessionDate = "";
  double sessionFees = 0;
  String currency = "";
  String imageUrl = "";
  String promoCode = "";
  String slotId = "";
  bool isWallet = true;

  bool isFlatRate = false;
  bool isCorporate = false;
  bool isInsurance = false;
  double percentageUserDiscount = 0.0;

  @override
  void initState() {
    super.initState();
    context.read<CheckoutBloc>().add(CheckoutLoadingEvent());
    isFlatRate = CheckUserDiscountCubit.userDiscountData!.isFlatRate!;
    isCorporate = CheckUserDiscountCubit.userDiscountData!.isCorporate!;
    isInsurance = CheckUserDiscountCubit.userDiscountData!.isInsurance!;
    percentageUserDiscount = CheckUserDiscountCubit.userDiscountData!.discount!;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero).then((_) {
      context.read<CheckoutBloc>().add(CheckoutLoadingEvent());
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      therapistName = args['therapistName'] as String;
      therapistProfession = args['therapistProfession'] as String;
      sessionDate = args['sessionDate'] as String;
      sessionFees = args['sessionFees'] as double;
      currency = args['currency'] as String;
      imageUrl = args['image'] as String;
      slotId = args['slotId'] as String;
      context.read<CheckoutBloc>().add(CheckoutSuccessEvent());
    });
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBarForMoreScreens(
          title: translate(LangKeys.checkout),
        ),
        body: _getBody(),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is NetworkError) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
        }
        if (state is ErrorState) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
        }
        if (state is ConfirmSessionSuccess) {
          MixpanelBookingBloc.bloc(context).add(
            SuccessfulBookingEvent(
              sessionId: state.bookSession.data?.sessionId?.toString() ?? "",
            ),
          );
          Navigator.of(context)
              .pushReplacementNamed(SuccessPaymentScreen.routeName, arguments: {
            'therapistName': therapistName,
            'sessionDate': sessionDate
          });
        }
      },
      builder: (context, state) {
        if (state is CheckoutSuccessState ||
            state is NetworkError ||
            state is ErrorState) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _stepsSlide(),
                  _bookingHeader(),
                  _getDetailsCard(),
                  _totalFees(),
                  _cancellationPolicy(),
                  const FooterWidget(),
                  _proceedToPayment(),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox();
        }
      },
    );
  }

  Widget _stepsSlide() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                  color: ConstColors.accentColor,
                  width: width * 0.60,
                  height: 3.5),
            ),
          ),
        ],
      ),
    );
  }

//Header for what you will book for
  Widget _bookingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        translate(LangKeys.youAreGoingToBook),
        style: const TextStyle(
            color: ConstColors.app, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

//Details card
  Widget _getDetailsCard() {
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _sessionDetailsRow(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: lineDivider(),
              ),
              _sessionFees(),
            ],
          ),
        ),
      ),
    );
  }

//Colored Text
  Widget _text(
      String text, FontWeight fontWeight, double fontSize, Color color) {
    return Text(
      text,
      style:
          TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
    );
  }

//Session & therapist info
  Widget _sessionDetailsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _text(therapistName, FontWeight.w600, 14, ConstColors.app),
            SizedBox(
              width: width / 3,
              child: RichText(
                text: TextSpan(
                  text: therapistProfession,
                  style: const TextStyle(
                      color: ConstColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w400),
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            _text(
                sessionDate == ""
                    ? ""
                    : DateFormat('EEEE dd/MM').format(_getDate(sessionDate)),
                FontWeight.w400,
                14,
                ConstColors.text),
            _text(translate(LangKeys.fiftyMinOneOnOne), FontWeight.w400, 12,
                ConstColors.textSecondary),
          ],
        ),
        Column(
          children: [
            imageUrl == ""
                ? SvgPicture.asset(AssPath.infoIcon)
                : ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                    child: CachedNetworkImage(
                      imageUrl: ApiKeys.baseUrl + imageUrl,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Shimmer.fromColors(
                        baseColor: Colors.black12,
                        highlightColor: Colors.white,
                        child: Container(
                          height: 0.13 * width,
                          width: 0.13 * width,
                          decoration:
                              const BoxDecoration(color: Colors.black26),
                        ),
                      ),
                      errorWidget: (context, url, error) => const SizedBox(
                          width: 30,
                          height: 30,
                          child: Center(child: Icon(Icons.error))),
                      cacheKey: ApiKeys.baseUrl + imageUrl,
                      height: 0.13 * width,
                      width: 0.13 * width,
                      maxHeightDiskCache: 1000,
                      maxWidthDiskCache: 500,
                    )),
            _text(
                sessionDate == ""
                    ? ""
                    : DateFormat().add_jm().format(_getDate(sessionDate)),
                FontWeight.w700,
                14,
                ConstColors.accentColor),
          ],
        ),
      ],
    );
  }

//Session fees row
  Widget _sessionFees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _text(translate(LangKeys.sessionFees), FontWeight.w400, 12,
            ConstColors.text),
        _text("${sessionFees.toInt()} $currency", FontWeight.w400, 16,
            ConstColors.text),
      ],
    );
  }

//Session fees row
/*
*  Widget _sessionFees() {
    return CheckUserDiscountCubit.userDiscountData?.discount != null &&
            CheckUserDiscountCubit.userDiscountData?.discount != 0.0
        ? Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Wrap(
                    children: [
                      _text(
                          "${translate(LangKeys.asteriskEwp)} ${CheckUserDiscountCubit.userDiscountData!.discount!.toString()} $currency ${translate(LangKeys.discountApplied)}",
                          FontWeight.w400,
                          12,
                          ConstColors.textSecondary),
                    ],
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _text(translate(LangKeys.sessionFees), FontWeight.w400, 12,
                      ConstColors.text),
                  Text(
                      "${(sessionFees.toInt() + CheckUserDiscountCubit.userDiscountData!.discount!.toInt())} $currency",
                      style: const TextStyle(
                        decoration: TextDecoration.lineThrough,
                        fontWeight: FontWeight.w500,
                        fontSize: 11,
                        color: ConstColors.textDisabled,
                      )),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  _text("${sessionFees.toInt()} $currency", FontWeight.w600, 16,
                      ConstColors.text),
                ],
              ),
            ],
          )
        : Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _text(translate(LangKeys.sessionFees), FontWeight.w400, 12,
                  ConstColors.text),
              _text("${sessionFees.toInt()} $currency", FontWeight.w400, 16,
                  ConstColors.text),
            ],
          );
  }
* */
//total fees section
  Widget _totalFees() {
    return Padding(
      padding: EdgeInsets.only(top: height / 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _text(
              translate(LangKeys.total), FontWeight.w500, 14, ConstColors.app),
          _text("${sessionFees.toInt()} ${translateCurrency(currency)}",
              FontWeight.w600, 16, ConstColors.text),
        ],
      ),
    );
  }

//Cancellation policy expand collapse section
  Widget _cancellationPolicy() {
    return Padding(
      padding: EdgeInsets.only(top: height / 20),
      child: ExpandableNotifier(
        initialExpanded: true,
        child: ScrollOnExpand(
          theme: const ExpandableThemeData(
              iconColor: ConstColors.app,
              tapBodyToCollapse: true,
              tapBodyToExpand: true),
          child: ExpandablePanel(
            header: Row(
              children: [
                SvgPicture.asset(
                  AssPath.cancellationIcon,
                  // scale: 2,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    translate(LangKeys.cancellationPolicy),
                    style: const TextStyle(
                      color: ConstColors.app,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            collapsed: const SizedBox(),
            expanded: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: CancellationPolicyAllUsersTypeWidget(
                percentageUserDiscount: percentageUserDiscount,
                isFlatRate: isFlatRate,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _proceedToPayment() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          top: 20.0, left: width / 10, right: width / 10, bottom: 20),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            context.read<CheckoutBloc>().add(
                ConfirmSessionEvent(promoCode, slotId, sessionFees, isWallet));
          },
          // onPressed: () => Navigator.of(context)
          //     .pushReplacementNamed(PaymentDetailsScreen.routeName, arguments: {
          //   "promoCode": promoCode,
          //   "slotId": slotId,
          //   "sessionFees": sessionFees,
          //   "therapistName": therapistName,
          //   "sessionDate": sessionDate
          // }
          // ),
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.confirm)),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////
  DateTime _getDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    String hour = date.substring(8, 10);
    String minute = date.substring(10, 12);
    String second = date.substring(12, 14);
    String formattedDate = "$year-$month-${day}T$hour:$minute:${second}Z";
    return DateTime.parse(formattedDate);
  }
}
