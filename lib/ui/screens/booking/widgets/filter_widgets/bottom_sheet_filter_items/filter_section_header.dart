import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

///  get filter section header
class FilterSectionHeader extends StatelessWidget {
  final String headerText;
  const FilterSectionHeader({Key? key, required this.headerText})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      headerText,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: ConstColors.app,
      ),
    );
  }
}
