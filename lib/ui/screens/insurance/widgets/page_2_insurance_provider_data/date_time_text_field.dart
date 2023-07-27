import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart'
    show DatePicker;
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/insurance_provider_text_field.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class DateTimeTextField extends BaseStatelessWidget {
  final TextEditingController dateTimeController;
  DateTimeTextField({required this.dateTimeController, super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return InsuranceProviderTextField(
      labelText: translate(LangKeys.expirationDate),
      hintText: translate(LangKeys.ddmmyyyy),
      keyboardType: TextInputType.datetime,
      readOnly: true,
      controller: dateTimeController,
      onTap: () async {
        DateTime? datePicked = await DatePicker.showSimpleDatePicker(
          context,
          firstDate: DateTime.now(),
          dateFormat: "dd/MMMM/yyyy",
          looping: false,
        );
        if (datePicked != null) {
          dateTimeController.text =
              DateFormat('dd/MMM/yyyy').format(datePicked);
        }
      },
    );
  }
}
