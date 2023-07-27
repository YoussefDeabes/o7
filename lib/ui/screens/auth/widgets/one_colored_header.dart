import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';

/// Get One colored Header
/// ignore: must_be_immutable
class OneColoredHeader extends BaseStatelessWidget {
  final String text;

  /// Get One colored header text
  OneColoredHeader({required this.text, Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
          fontWeight: FontWeight.w500, color: ConstColors.app, fontSize: 24),
    );
  }
}
