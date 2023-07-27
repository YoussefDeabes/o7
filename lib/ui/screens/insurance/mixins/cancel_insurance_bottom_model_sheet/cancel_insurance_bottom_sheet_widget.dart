part of 'cancel_insurance_bottom_model_sheet.dart';

class _CancelInsuranceBottomSheetWidget extends BaseStatelessWidget {
  final int cardId;
  _CancelInsuranceBottomSheetWidget({required this.cardId, Key? key})
      : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return FractionallySizedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(height: 0.05 * height),
          Text(
            translate(LangKeys.areYouSureYouWantToCancelYourInsurancePlan),
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: ConstColors.text,
            ),
          ),
          SizedBox(height: 0.05 * height),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              BackButtonForInsuranceScreen(),
              _getCancelPlanButton(context),
            ],
          ),
          SizedBox(height: 0.02 * height),
        ],
      ),
    );
  }

  /// get Verify button
  Widget _getCancelPlanButton(BuildContext context) {
    return InsurancePageButton(
      buttonLabel: translate(LangKeys.yesCancelPlan),
      onPressed: () {
        Navigator.pop(context);
        InsuranceStatusBloc.bloc(context)
            .add(DeleteInsuranceEvent(cardId: cardId));
      },
      width: width * 0.5,
    );
  }
}
