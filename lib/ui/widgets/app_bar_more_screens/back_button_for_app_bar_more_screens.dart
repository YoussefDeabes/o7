import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';

/// get Back Button to pop the screen
class BackButtonForAppBarMoreScreens extends StatelessWidget {
  const BackButtonForAppBarMoreScreens({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsetsDirectional.only(start: 24),
      child: Material(
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          height: 30,
          width: 30,
          padding: EdgeInsets.zero,
          decoration: ShapeDecoration(
            color: const Color.fromARGB(50, 45, 93, 99),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Center(
            child: IconButton(
              iconSize: 12,
              alignment: Alignment.center,
              icon: const Icon(Icons.arrow_back_ios_rounded),
              color: ConstColors.app,
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.canPop(context)
                  ? Navigator.maybePop(context)
                  : null,
            ),
          ),
        ),
      ),
    );
  }
}
