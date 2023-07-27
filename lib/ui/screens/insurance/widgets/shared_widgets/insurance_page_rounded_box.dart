import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

/// the Rounded Box used in the Insurance pages
class InsurancePageRoundedBox extends StatelessWidget {
  final Widget child;
  const InsurancePageRoundedBox({required this.child, super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        border: Border.all(color: ConstColors.disabled),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
