import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/checkout/checkout_screen/checkout_screen.dart';
import 'package:o7therapy/ui/screens/checkout/checkout_screen/confirm_booking_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/screen/insurance_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class AddInsuranceTextWidget extends BaseStatelessWidget {
  final String availableSlotId;
  final String slotDate;
  final TherapistData therapistData;

  AddInsuranceTextWidget({
    required this.therapistData,
    required this.availableSlotId,
    required this.slotDate,
    super.key,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return BlocConsumer<InsuranceStatusBloc, InsuranceStatusState>(
      listener: (context, state) {
        /// check if the insurance is succeeded and become verified
        /// then add event of GetInsuranceDealEvent to check the fees of the insurance
        if (state is SuccessVerifiedInsuranceStatus) {
          InsuranceStatusBloc.bloc(context).add(GetInsuranceDealEvent(
            availableSlotId: availableSlotId,
            slotDate: slotDate,
          ));

          /// after get the Insurance Deal State then depend on the newFeesAmount
          /// navigate client to which screen to complete the booking process
        } else if (state is InsuranceDealState) {
          if (state.insuranceDeal.data!.newFeesAmount! == 0) {
            _pushToConfirmBookingScreen(context, state);
          } else {
            _pushToCheckoutScreen(context, state);
          }
        }
      },
      builder: (context, state) {
        if (state is NoInsuranceStatus ||
            state is UnVerifiedInsuranceStatus ||
            state is ExceptionInsuranceStatus) {
          return Container(
            alignment: AlignmentDirectional.centerStart,
            margin: const EdgeInsets.only(top: 16),
            child: RichText(
              textAlign: TextAlign.start,
              text: TextSpan(
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  color: ConstColors.text,
                  fontSize: 14,
                ),
                children: [
                  TextSpan(text: "${translate(LangKeys.youHaveInsurance)} "),
                  TextSpan(
                    text: translate(LangKeys.addInsurance),
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: ConstColors.secondary,
                      decoration: TextDecoration.underline,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () => Navigator.pushNamed(
                          context, InsuranceScreen.routeName),
                  ),
                ],
              ),
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }

  _pushToConfirmBookingScreen(
    BuildContext context,
    InsuranceDealState therapistProfileState,
  ) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      ConfirmBookingScreen.routeName,
      (route) => route.settings.name == HomeMainLoggedInScreen.routeName,
      arguments: {
        "therapistName": therapistData.name,
        "therapistProfession": therapistData.canPrescribe == null
            ? ""
            : therapistData.canPrescribe!
                ? translate(LangKeys.psychiatrist)
                : translate(LangKeys.psychologist),
        "sessionDate": therapistProfileState.slotDate,
        "sessionFees": therapistProfileState.insuranceDeal.data!.newFeesAmount!,
        "currency": therapistProfileState.insuranceDeal.data!.currency!,
        "image": therapistData.image?.url,
        "slotId": therapistProfileState.slotId,
      },
    );
  }

  _pushToCheckoutScreen(
    BuildContext context,
    InsuranceDealState therapistProfileState,
  ) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      CheckoutScreen.routeName,
      (route) => route.settings.name == HomeMainLoggedInScreen.routeName,
      arguments: {
        "therapistData": therapistData,
        "therapistName": therapistData.name,
        "therapistProfession": therapistData.canPrescribe == null
            ? ""
            : therapistData.canPrescribe!
                ? translate(LangKeys.psychiatrist)
                : translate(LangKeys.psychologist),
        "sessionDate": therapistProfileState.slotDate,
        "sessionFees": therapistProfileState.insuranceDeal.data!.newFeesAmount!,
        "currency": therapistProfileState.insuranceDeal.data!.currency!,
        "image": therapistData.image?.url,
        "slotId": therapistProfileState.slotId,
      },
    );
  }
}
