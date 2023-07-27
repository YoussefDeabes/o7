import 'package:flutter/material.dart';

// update_insurance_bottom_model_sheet.dart
mixin UpdateInsuranceBottomModelSheet {
  showUpdateInsuranceBottomSheet({
    required BuildContext context,
    required Widget child,
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
        child: Container(
          color: Colors.transparent,
          height: MediaQuery.of(context).size.height - 65,
          child: child,
        ),
      ),
    );
  }
}
