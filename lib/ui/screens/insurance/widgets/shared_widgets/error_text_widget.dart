import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class ErrorTextWidget extends StatelessWidget {
  final String errorString;
  const ErrorTextWidget({required this.errorString, super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        errorString,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: ConstColors.error,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
