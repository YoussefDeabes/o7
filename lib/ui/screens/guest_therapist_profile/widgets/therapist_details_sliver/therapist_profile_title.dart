import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class TherapistProfileTitle extends StatelessWidget {
  final String title;
  const TherapistProfileTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: ConstColors.app,
      ),
    );
  }
}
