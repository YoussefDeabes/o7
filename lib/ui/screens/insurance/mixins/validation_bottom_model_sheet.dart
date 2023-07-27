import 'package:flutter/material.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/verify_membership_bottom_sheet.dart';

mixin validationBottomModelSheet {
  showValidationBottomSheet({
    required BuildContext context,
    required int membershipNumber,
    required String providerName,
  }) {
    showModalBottomSheet(
      isScrollControlled: true,
      enableDrag: true,
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(16),
          topStart: Radius.circular(16),
        ),
      ),
      builder: (context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Padding(
          padding: EdgeInsetsDirectional.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: Container(
            color: Colors.transparent,
            height: MediaQuery.of(context).size.height * 0.6,
            child: VerifyMembershipBottomSheet(
              membershipNumber: membershipNumber,
              providerName: providerName,
            ),
          ),
        ),
      ),
    );
  }
}
