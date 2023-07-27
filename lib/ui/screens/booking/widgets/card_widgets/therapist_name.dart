import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class TherapistName extends StatelessWidget {
  final String? therapistName;
  const TherapistName({super.key, required this.therapistName});

  @override
  Widget build(BuildContext context) {
    return Text(
      therapistName ?? "",
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: ConstColors.text,
      ),
    );
  }
}
