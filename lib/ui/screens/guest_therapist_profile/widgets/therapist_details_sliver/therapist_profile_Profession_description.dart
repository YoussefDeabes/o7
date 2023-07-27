import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

// therapist_profile_description
class TherapistProfileProfessionDescription extends StatelessWidget {
  final String profession;
  const TherapistProfileProfessionDescription(
      {super.key, required this.profession});

  @override
  Widget build(BuildContext context) {
    return Text(
      profession,
      style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w400,
          color: ConstColors.textSecondary),
      textAlign: TextAlign.center,
      maxLines: 2,
    );
  }
}
