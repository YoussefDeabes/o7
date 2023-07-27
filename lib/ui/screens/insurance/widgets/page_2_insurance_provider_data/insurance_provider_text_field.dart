import 'package:flutter/material.dart';

/// the text field for page 2 insurance provider
class InsuranceProviderTextField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final TextInputType? keyboardType;
  final bool readOnly;
  final bool autoFocus;
  final void Function()? onTap;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;

  const InsuranceProviderTextField({
    required this.labelText,
    required this.hintText,
    this.keyboardType,
    this.readOnly = false,
    this.autoFocus = false,
    this.onTap,
    this.controller,
    this.onSubmitted,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      autofocus: autoFocus,
      style: const TextStyle(fontSize: 14.0),
      onTap: onTap,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.transparent,
        labelText: labelText,
        alignLabelWithHint: true,
        hintText: hintText,
      ),
    );
  }
}
