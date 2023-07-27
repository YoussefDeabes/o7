import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';

// ignore: must_be_immutable
class TwoColoredHeaderText extends BaseStatelessWidget {
  /// firstColoredText for the header and it's color is ConstColors.secondary
  final String firstColoredText;

  /// secondColoredText for the header and it's color is ConstColors.appTitle
  final String secondColoredText;

  /// Get two colored header text
  TwoColoredHeaderText({
    required this.firstColoredText,
    required this.secondColoredText,
    Key? key,
  }) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          firstColoredText,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: ConstColors.secondary,
              fontSize: 24),
        ),
        Text(
          secondColoredText,
          style: const TextStyle(
              fontWeight: FontWeight.w500,
              color: ConstColors.appTitle,
              fontSize: 24),
        ),
      ],
    );
  }
}
