import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/widgets/auth_text_form_field_widget.dart';

/// the text form field for the Age And NickName of the signUp screen only
// ignore: must_be_immutable
class AgeAndNickNameTextFormField extends BaseStatelessWidget {
  final void Function(String?) onSaved;
  final String? Function(String?)? validator;
  final String labelText;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final void Function(String) onChanged;
  final String? initialValue;

  AgeAndNickNameTextFormField({
    required this.onSaved,
    this.validator,
    required this.labelText,
    required this.onChanged,
    this.initialValue,
    this.focusNode,
    this.keyboardType,
    Key? key,
  }) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height * 0.2, left:24, right:24),
      child: AuthTextFieldWidget(
        initialValue: initialValue,
        autoCorrect: false,
        keyboardType: keyboardType,
        textInputAction: TextInputAction.done,
        focusNode: focusNode,
        decoration: InputDecoration(
          alignLabelWithHint: true,
          label: Center(
            child: Text(
              labelText,
              style: const TextStyle(
                color: ConstColors.textGrey,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          errorStyle: const TextStyle(color: ConstColors.error),
        ),
        onSaved: onSaved,
        validator: validator,
        // the hint and onChanged are required in the authTextFormFieldWidget
        // but not used in the age and nick name
        hintText: '',
        onChange: onChanged,
      ),
    );
  }
}
