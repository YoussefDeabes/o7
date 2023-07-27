import 'package:flutter/services.dart';

/// formatter >> used to detect the number user enter before type it on textfield
/// each time user enter a char of number
/// it check if (the whole number > max) don't add new char number and return old one
/// example
/// - user entered 6 then entered 0 become 60 -check--> 60 < 100 true return (60)
/// - user entered 6 then entered 00 become 600 -check--> 600 < 100 false return (60)
class MaxNumericalRangeFormatter extends TextInputFormatter {
  final int valueForInvalidParse;
  final int max;

  MaxNumericalRangeFormatter({
    required this.max,
    required this.valueForInvalidParse,
  });

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue;
    }
    if (double.tryParse(newValue.text) == null) {
      return TextEditingValue(text: valueForInvalidParse.toString());
    }
    if (double.parse(newValue.text) > max) {
      return oldValue;
    } else {
      return newValue;
    }
  }
}
