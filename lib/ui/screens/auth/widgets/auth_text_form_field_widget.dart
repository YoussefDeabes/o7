import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class AuthTextFieldWidget extends StatefulWidget {
  final String hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final bool obscureText, enabled, showBorder;
  final TextInputAction? textInputAction;
  final void Function(String) onChange;
  final void Function(String?) onSaved;
  final FocusNode? focusNode;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final InputDecoration? decoration;
  final bool autoCorrect;
  final String? initialValue;

  const AuthTextFieldWidget({
    Key? key,
    required this.hintText,
    this.obscureText = false,
    this.keyboardType,
    required this.onChange,
    required this.onSaved,
    this.controller,
    this.focusNode,
    this.errorText,
    this.textInputAction,
    this.enabled = true,
    this.showBorder = false,
    this.validator,
    this.autoCorrect = true,
    this.decoration,
    this.initialValue,
  }) : super(key: key);

  @override
  _AuthTextFieldWidgetState createState() => _AuthTextFieldWidgetState();
}

class _AuthTextFieldWidgetState extends State<AuthTextFieldWidget> {
  late bool _shouldShowAsPasswordText;
  IconData _passwordIcon = Icons.visibility_outlined;

  @override
  void initState() {
    super.initState();
    // Initially password is obscure
    _shouldShowAsPasswordText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialValue,
      controller: widget.controller,
      textInputAction: widget.textInputAction,
      focusNode: widget.focusNode,
      enabled: widget.enabled,
      keyboardType: widget.keyboardType,
      obscureText: _shouldShowAsPasswordText,
      autocorrect: widget.autoCorrect,

      //check if input is enabled because if not we can't ues auto fill
      autofillHints:
          widget.keyboardType == TextInputType.emailAddress && widget.enabled
              ? [AutofillHints.email]
              : null,
      decoration: widget.decoration ??
          InputDecoration(
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _passwordIcon,
                      color: ConstColors.secondary,
                    ),
                    onPressed: _toggleVisibilityIcon,
                  )
                : null,
            label: Text(
              widget.hintText,
              style: const TextStyle(color: ConstColors.text),
            ),
            errorText: widget.errorText,
            errorStyle: const TextStyle(color: ConstColors.error),
          ),
      onChanged: widget.onChange,
      onSaved: widget.onSaved,
      validator: widget.validator,
    );
  }

  void _toggleVisibilityIcon() {
    setState(() {
      _shouldShowAsPasswordText = !_shouldShowAsPasswordText;
      if (_shouldShowAsPasswordText) {
        _passwordIcon = Icons.visibility_outlined;
      } else {
        _passwordIcon = Icons.visibility_off_outlined;
      }
    });
  }
}
