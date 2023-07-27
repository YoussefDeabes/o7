import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';

import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/verify_membership_bottom_sheet.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/back_button_for_insurance_screens.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/insurance_page_button.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

part 'cancel_insurance_bottom_sheet_widget.dart';

mixin CancelInsuranceBottomModelSheet {
  showCancelInsuranceBottomSheet({
    required BuildContext context,
    required int cardId,
  }) {
    showModalBottomSheet(
      enableDrag: true,
      isDismissible: true,
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadiusDirectional.only(
          topEnd: Radius.circular(16),
          topStart: Radius.circular(16),
        ),
      ),
      builder: (context) => Container(
        color: Colors.transparent,
        padding: EdgeInsetsDirectional.only(
          start: 24,
          end: 24,
          bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        ),
        child: _CancelInsuranceBottomSheetWidget(cardId: cardId),
      ),
    );
  }
}
