import 'package:flutter/material.dart';
import 'package:o7therapy/ui/screens/checkout/widgets/cancelation-policy-text-widget.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class CancellationPolicyAllUsersTypeWidget extends StatefulWidget {
  final bool isFlatRate;
  final double percentageUserDiscount;
  const CancellationPolicyAllUsersTypeWidget({Key? key,required this.percentageUserDiscount,required this.isFlatRate}) : super(key: key);

  @override
  State<CancellationPolicyAllUsersTypeWidget> createState() => _CancellationPolicyAllUsersTypeWidgetState();
}

class _CancellationPolicyAllUsersTypeWidgetState extends State<CancellationPolicyAllUsersTypeWidget> {
  @override
  Widget build(BuildContext context) {

    if(widget.isFlatRate){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CancelationPolicyTextWidget(
          text0: context.translate(LangKeys.applyFees) ,
          bold1: context.translate(LangKeys.a100PercentOfFeesApply),
          text1:context.translate(LangKeys.feesCancellationOrRescheduling),
          bold2:context.translate(LangKeys.sixHoursLess),
          text2: context.translate(LangKeys.sessionRefundToPlanLimit),),
        CancelationPolicyTextWidget(
          text0: context.translate(LangKeys.applyFees) ,
          bold1: context.translate(LangKeys.a50PercentApply),
          text1:context.translate(LangKeys.fromValueApplyCancelOrReschedule),
          bold2: context.translate(LangKeys.beforeSixTo24Hours),
          text2: context.translate(LangKeys.sessionRefundToPlanLimit),),
        CancelationPolicyTextWidget(
          bold1: context.translate(LangKeys.noFees),
          text1:context.translate(LangKeys.applyCancelOrRescheduleBeforeSession),
          bold2:context.translate(LangKeys.moreThanTwentyFourHours),
          text2: context.translate(LangKeys.sessionRefundToPlanLimit),),
      ]);
    }
    else if (!widget.isFlatRate&& widget.percentageUserDiscount==100){
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        CancelationPolicyTextWidget(
          text1: context.translate(LangKeys.sessionWillBe),
          bold2:context.translate(LangKeys.deducted) ,
          text2: context.translate(LangKeys.fromPlanLimitIfCancelation),
          bold3: context.translate(LangKeys.lessThanTwentyFourHours),
          text3:  context.translate(LangKeys.beforeSession),),

        CancelationPolicyTextWidget(
          text1: context.translate(LangKeys.sessionWillBeDeducted),
          bold2:context.translate(LangKeys.refunded) ,
          text2: context.translate(LangKeys.fromPlanLimitIfCancelation),
          bold3: context.translate(LangKeys.moreThanTwentyFourHours),
          text3:  context.translate(LangKeys.beforeSession),),
      ]);
    }
    else{
      return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CancelationPolicyTextWidget(
            bold1: context.translate(LangKeys.a100Percent),
            bold2: context.translate(LangKeys.a24Hours),
            text1: context.translate(LangKeys.a100PercentRefund1),
            text2: context.translate(LangKeys.a100PercentRefund2)),
        CancelationPolicyTextWidget(
            bold1: context.translate(LangKeys.a50Percent),
            bold2: context.translate(LangKeys.sixTo24Hours),
            text1: context.translate(LangKeys.a50PercentRefund1),
            text2: context.translate(LangKeys.a50PercentRefund2)),
        CancelationPolicyTextWidget(
            bold2: context.translate(LangKeys.lessThan6Hours),
            text1: context.translate(LangKeys.noRefund1),
            text2: context.translate(LangKeys.noRefund2)),
      ]);   }  }
}
