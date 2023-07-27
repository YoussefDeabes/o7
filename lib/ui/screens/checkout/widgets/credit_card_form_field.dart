import 'package:flutter/material.dart';

class CreditCardFormField extends StatelessWidget {
  const CreditCardFormField({
    this.key,
    this.controller,
    this.decoration,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
  }) : super(key: key);

  final Key? key;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
      decoration: decoration,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
    );
  }
}

class CVVFormField extends StatelessWidget {
  const CVVFormField({
    this.key,
    this.controller,
    this.decoration,
    this.validator,
    this.obscureText = false,
    this.enabled = true,
  }) : super(key: key);

  final Key? key;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: const TextInputType.numberWithOptions(
        signed: false,
        decimal: false,
      ),
      decoration: decoration,
      controller: controller,
      validator: validator,
      obscureText: obscureText,
    );
  }
}

class ExpirationFormField extends StatefulWidget {
  const ExpirationFormField({
    this.key,
    required this.controller,
    this.decoration,
    this.obscureText = false,
    this.enabled = true,
  }) : super(key: key);

  final Key? key;
  final TextEditingController? controller;
  final InputDecoration? decoration;
  final bool obscureText;
  final bool enabled;

  @override
  _ExpirationFormFieldState createState() => _ExpirationFormFieldState();
}

class _ExpirationFormFieldState extends State<ExpirationFormField> {
  @override
  Widget build(BuildContext context) {
    return TextField(
      keyboardType:
          const TextInputType.numberWithOptions(signed: false, decimal: false),
      controller: widget.controller,
      decoration: widget.decoration,
      onChanged: (value) {
        setState(() {
          value = value.replaceAll(RegExp(r"\D"), "");
          switch (value.length) {
            case 0:
              widget.controller!.text = "MM/YY";
              widget.controller!.selection =
                  const TextSelection.collapsed(offset: 0);
              break;
            case 1:
              widget.controller!.text = "${value}M/YY";
              widget.controller!.selection =
                  const TextSelection.collapsed(offset: 1);
              break;
            case 2:
              widget.controller!.text = "$value/YY";
              widget.controller!.selection =
                  const TextSelection.collapsed(offset: 2);
              break;
            case 3:
              widget.controller!.text =
                  "${value.substring(0, 2)}/${value.substring(2)}Y";
              widget.controller!.selection =
                  const TextSelection.collapsed(offset: 4);
              break;
            case 4:
              widget.controller!.text =
                  "${value.substring(0, 2)}/${value.substring(2, 4)}";
              widget.controller!.selection =
                  const TextSelection.collapsed(offset: 5);
              break;
          }
          if (value.length > 4) {
            widget.controller!.text =
                "${value.substring(0, 2)}/${value.substring(2, 4)}";
            widget.controller!.selection =
                const TextSelection.collapsed(offset: 5);
          }
        });
      },
      cursorWidth: 0.0,
      obscureText: widget.obscureText,
      enabled: widget.enabled,
    );
  }
}
