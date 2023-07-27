import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/validator.dart';

class PasswordDescriptionWidget extends StatefulWidget {
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;

  const PasswordDescriptionWidget({
    required this.passwordController,
    required this.confirmPasswordController,
    super.key,
  });

  @override
  _PasswordDescriptionWidgetState createState() =>
      _PasswordDescriptionWidgetState();
}

class _PasswordDescriptionWidgetState extends State<PasswordDescriptionWidget> {
  bool _isEightCharOrMore = false;
  bool _isContainNumeric = false;
  bool _isContainSpecialChar = false;
  bool _isContainUpperCase = false;
  bool _isContainLowerCase = false;
  bool _confirmMatch = false;

  @override
  void initState() {
    widget.passwordController.addListener(_passwordFieldChanged);
    widget.confirmPasswordController.addListener(_confirmPasswordFieldChanged);
    super.initState();
  }

  String _translate(String key) {
    return AppLocalizations.of(context).translate(key);
  }

  @override
  Widget build(BuildContext context) {
    //  "must be 8 character length, contains numeric, special character upper case & lower case, matching passwords"
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
              height: 1.5, fontSize: 12, fontWeight: FontWeight.w400),
          children: [
            TextSpan(
                // 'must be 8 character length, ',
                text: "${_translate(LangKeys.mustBe8charactersLength)}\t",
                style: _getColorTextStyle(_isEightCharOrMore)),
            TextSpan(
                // 'contains numeric, ',
                text: "${_translate(LangKeys.containsNumeric)}\t",
                style: _getColorTextStyle(_isContainNumeric)),
            TextSpan(
                // 'special character ',
                text: "${_translate(LangKeys.specialCharacter)}\t",
                style: _getColorTextStyle(_isContainSpecialChar)),
            TextSpan(
                //  'upper case & ',
                text: "${_translate(LangKeys.upperCase)}\t",
                style: _getColorTextStyle(_isContainUpperCase)),
            TextSpan(
                //  'lower case, ',
                text: "${_translate(LangKeys.lowerCase)}\t",
                style: _getColorTextStyle(_isContainLowerCase)),
            TextSpan(
                // 'matching passwords',
                text: _translate(LangKeys.matchingPasswords),
                style: _getColorTextStyle(_confirmMatch)),
          ],
        ),
        textAlign: TextAlign.start,
      ),
    );
  }

  void _passwordHintChanged(String currentValue) {
    setState(() {
      _isEightCharOrMore = !Validator.isLessThan8Characters(currentValue);
      _isContainNumeric = Validator.isContainNumber(currentValue);
      _isContainUpperCase = Validator.isContainUpperCase(currentValue);
      _isContainLowerCase = Validator.isContainLowerCase(currentValue);
      _isContainSpecialChar = Validator.isContainSpecialCharacter(currentValue);
    });
  }

  TextStyle _getColorTextStyle(bool value) {
    return TextStyle(
      color: value ? ConstColors.secondary : ConstColors.textGrey,
    );
  }

  void _passwordFieldChanged() {
    String passwordValue = widget.passwordController.text;
    String confirmPasswordValue = widget.confirmPasswordController.text;
    setState(() {
      _confirmMatch = passwordValue == confirmPasswordValue;
    });
    _passwordHintChanged(passwordValue);
  }

  void _confirmPasswordFieldChanged() {
    String passwordValue = widget.passwordController.text;
    String confirmPasswordValue = widget.confirmPasswordController.text;
    setState(() => _confirmMatch = (passwordValue == confirmPasswordValue));
  }
}
