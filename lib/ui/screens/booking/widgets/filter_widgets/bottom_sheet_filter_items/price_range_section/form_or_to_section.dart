import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/general.dart';

class FromOrToSection extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final TextInputFormatter rangeFormatter;
  final FocusNode focusNode;
  final void Function()? onEditingComplete;
  final String currency;

  const FromOrToSection({
    super.key,
    required this.title,
    required this.controller,
    required this.rangeFormatter,
    required this.focusNode,
    required this.onEditingComplete,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 14,
            color: ConstColors.text,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          height: 35,
          width: MediaQuery.of(context).size.width * 0.3,
          child: TextField(
            focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            maxLines: 1,
            style: const TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: ConstColors.text,
            ),
            decoration: InputDecoration(
              suffix: Text(
                getCurrencyNameByContext(
                  context,
                  currency,
                ),
                style: const TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: ConstColors.text,
                ),
              ),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                borderSide: BorderSide(width: 1, color: ConstColors.disabled),
              ),
              disabledBorder: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7.0)),
                borderSide: BorderSide(width: 1, color: ConstColors.disabled),
              ),
              filled: true,
              fillColor: Colors.white,
              // isDense: true,
              contentPadding: const EdgeInsets.symmetric(horizontal: 5),
            ),
            textInputAction: TextInputAction.go,
            controller: controller,
            keyboardType: const TextInputType.numberWithOptions(
                signed: true, decimal: true),
            inputFormatters: [
              /// only allow digit numbers
              /// not allowed decimal
              FilteringTextInputFormatter.digitsOnly,

              /// length of char can user enter = 5
              LengthLimitingTextInputFormatter(5),
              rangeFormatter,
            ],
          ),
        ),
      ],
    );
  }
}
