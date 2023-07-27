import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class ContactTherapistName extends StatelessWidget {
  final String name;

  const ContactTherapistName({
    Key? key,
    required this.name,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      name,
      softWrap: false,
      maxLines: 1,
      overflow: TextOverflow.fade,
      style: const TextStyle(
        color: ConstColors.app,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
    );
  }
}
