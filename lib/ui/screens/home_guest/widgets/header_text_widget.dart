import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class HeaderWidget extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;

  const HeaderWidget({
    Key? key,
    required this.text,
    this.fontSize,
    this.fontWeight,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 17.0, bottom: 5),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 18,
          color: ConstColors.app,
          fontWeight: fontWeight ?? FontWeight.w700,
        ),
      ),
    );
  }
}
