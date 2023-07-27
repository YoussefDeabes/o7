import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_payment_card_bottom_sheet.dart';

import 'package:o7therapy/util/lang/app_localization_keys.dart';

class AddNewPaymentCardButton extends BaseStatelessWidget {
  AddNewPaymentCardButton({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: SizedBox(
        width: width * 0.30,
        height: 32,
        child: ElevatedButton(
          onPressed: () {
            _getAddNewCardModalBottomSheet(context);
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ),
          ),
          child: FittedBox(child: Text(translate(LangKeys.addNew))),
        ),
      ),
    );
  }

  _getAddNewCardModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topRight: Radius.circular(16),
          topLeft: Radius.circular(16),
        ),
      ),
      builder: (BuildContext context) {
        return const AddNewPaymentCardBottomSheetWidget();
      },
    );
  }
}
