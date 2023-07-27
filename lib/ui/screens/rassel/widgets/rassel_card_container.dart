import 'package:flutter/material.dart';

class RasselCardContainer extends StatelessWidget {
  final Widget child;
  const RasselCardContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(top: 8.0),
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xffeaeaea),
          width: 1,
        ),
        color: Colors.white,
      ),
      child: child,
    );
  }
}
