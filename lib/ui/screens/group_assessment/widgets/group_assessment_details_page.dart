import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/translator.dart';

import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/group_assessment/bloc/group_assessment_promo_code_bloc/group_assessment_promo_code_bloc.dart';
import 'package:o7therapy/ui/screens/group_assessment/bloc/group_assessment_promo_code_bloc/group_assessment_promo_code_repo.dart';
import 'package:o7therapy/ui/screens/group_assessment/screen/group_assessment_screen.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/colored_text.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/ui/widgets/cancellation_policy.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class GroupAssessmentDetailsPage extends StatefulWidget {
  const GroupAssessmentDetailsPage({Key? key}) : super(key: key);

  @override
  State<GroupAssessmentDetailsPage> createState() =>
      _GroupAssessmentDetailsPageState();
}

class _GroupAssessmentDetailsPageState extends State<GroupAssessmentDetailsPage>
    with Translator, ScreenSizer {
  final groupTherapyModel = GroupTherapyModel(
    currency: "USD",
    price: 5000,
    title: "Ice Cream",
    imageLink:
        "https://www.rmit.edu.au/content/dam/rmit/au/en/study-with-us/interest-areas/mastheads/art-study-area-julian-clavijo-1920x600.jpg",
    byWhom: "Ashraf Adel",
    startDate: DateTime(2022, 12, 31),
    endDate: DateTime(2023, 1, 2),

    startTime: TimeOfDay(hour: 18, minute: 15),
    sessionDate: "20221122063000",
    // DateTime(2022, 5, 22),

    endTime: TimeOfDay(hour: 21, minute: 30),
    availableSpots: 0,
  );

  bool isPromoAdded = false;
  String promoCode = "";

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    return BlocProvider<GroupAssessmentPromoCodeBloc>(
      create: (_) {
        return GroupAssessmentPromoCodeBloc(
            const GroupAssessmentPromoCodeRepo());
      },
      child: Builder(builder: (context) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              _bookingHeader(),
              _getDetailsCard(),
              _getFess(),
              CancellationPolicy(),
              const FooterWidget(),
              _proceedToPayment(),
            ],
          ),
        );
      }),
    );
  }

  ///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

//Header for what you will book for
  Widget _bookingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        translate(LangKeys.youAreGoingToBook),
        style: const TextStyle(
          color: ConstColors.app,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

//Details card
  Widget _getDetailsCard() {
    return SizedBox(
      width: width,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: ConstColors.disabled),
          borderRadius: BorderRadius.circular(16),
        ),
        margin: EdgeInsets.zero,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            children: [
              _sessionDetailsRow(),
              _getLineDivider(),
              _sessionFees(),
              _promoCode(),
            ],
          ),
        ),
      ),
    );
  }

  _getFess() {
    return BlocBuilder<GroupAssessmentPromoCodeBloc,
        GroupAssessmentPromoCodeState>(
      builder: (context, state) {
        if (state is VerifiedGroupAssessmentPromoCode) {
          return _promoCodeDiscountSection(state);
        }
        return _totalFees();
      },
    );
  }

//Session & therapist info
  Widget _sessionDetailsRow() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ColoredText(
              translate(LangKeys.groupAssessment),
              FontWeight.w600,
              14,
              ConstColors.app,
            ),
            ColoredText(
              "${translate(LangKeys.by)} Carrol Hammal",
              FontWeight.w400,
              12,
              ConstColors.textSecondary,
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ColoredText(
              groupTherapyModel.sessionDate == ""
                  ? ""
                  : DateFormat('EEEE dd/MM')
                      .format(_getDate(groupTherapyModel.sessionDate!)),
              FontWeight.w400,
              14,
              ConstColors.text,
            ),
            ColoredText(
              groupTherapyModel.sessionDate == ""
                  ? ""
                  : DateFormat()
                      .add_jm()
                      .format(_getDate(groupTherapyModel.sessionDate!)),
              FontWeight.w700,
              14,
              ConstColors.accentColor,
            ),
          ],
        ),
        ColoredText(
          "${translate(LangKeys.fifty)} ${translate(LangKeys.min)} \"${translate(LangKeys.groupAssessment)}\" ",
          FontWeight.w400,
          12,
          ConstColors.textSecondary,
        ),
      ],
    );
  }

//Session fees row
  Widget _sessionFees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        ColoredText(
          translate(LangKeys.sessionFees),
          FontWeight.w400,
          12,
          ConstColors.text,
        ),
        ColoredText(
          "${groupTherapyModel.price.toInt()} ${translateCurrency(groupTherapyModel.currency)}",
          FontWeight.w400,
          16,
          ConstColors.text,
        ),
      ],
    );
  }

//Promo code section
  Widget _promoCode() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          SizedBox(
            width: width / 2,
            child: TextField(
              onChanged: (value) {
                setState(() {
                  isPromoAdded = value.isNotEmpty;
                  promoCode = value;
                });
              },
              style: const TextStyle(color: ConstColors.app),
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.zero,
                  labelText: translate(LangKeys.addPromoCode),
                  labelStyle: const TextStyle(
                    color: ConstColors.app,
                  ),
                  alignLabelWithHint: true,
                  disabledBorder: InputBorder.none),
            ),
          ),
          Container(
            alignment: Alignment.center,
            child: SizedBox(
              width: width / 5,
              height: width / 10,
              child: ElevatedButton(
                onPressed: !isPromoAdded
                    ? null
                    : () {
                        // await ApiManager.payfortTokenization();
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                ))),
                child: Text(
                  translate(LangKeys.apply),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //Promo Code discount details section
  Widget _promoCodeDiscountSection(VerifiedGroupAssessmentPromoCode state) {
    return Padding(
      padding: EdgeInsets.only(top: height / 70),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColoredText(
                translate(LangKeys.subtotal),
                FontWeight.w400,
                12,
                ConstColors.app,
              ),
              ColoredText(
                  "${state.promoCode.data!.originalFeesAmount!.toInt()} ${translateCurrency(state.promoCode.data!.currency)}",
                  FontWeight.w400,
                  14,
                  ConstColors.text),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColoredText(translate(LangKeys.discount), FontWeight.w400, 12,
                  ConstColors.app),
              ColoredText(
                  "${state.promoCode.data!.discountAmount!.toInt()} ${translateCurrency(state.promoCode.data?.currency)}",
                  FontWeight.w400,
                  14,
                  ConstColors.text),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ColoredText(translate(LangKeys.total), FontWeight.w500, 14,
                  ConstColors.app),
              ColoredText(
                  "${state.promoCode.data!.newFeesAmount!.toInt()} ${translateCurrency(state.promoCode.data?.currency)}",
                  FontWeight.w600,
                  16,
                  ConstColors.text),
            ],
          ),
        ],
      ),
    );
  }

//total fees section
  Widget _totalFees() {
    return Padding(
      padding: EdgeInsets.only(top: height / 70),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ColoredText(
            translate(LangKeys.total),
            FontWeight.w500,
            14,
            ConstColors.app,
          ),
          ColoredText(
              "${groupTherapyModel.price.toInt()} ${translateCurrency(groupTherapyModel.currency)}",
              FontWeight.w600,
              16,
              ConstColors.text),
        ],
      ),
    );
  }

  Widget _proceedToPayment() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: 20.0,
        left: width / 10,
        right: width / 10,
        bottom: 20,
      ),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushNamed(
              context,
              GroupAssessmentScreen.routeName,
              arguments: GroupAssessmentPages.groupAssessmentPaymentPage,
            );
          },
          style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(34.0),
          )),
          child: Text(translate(LangKeys.proceedToPayment)),
        ),
      ),
    );
  }

  Widget _getLineDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: lineDivider(),
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
