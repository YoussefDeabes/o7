import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

/// the button used in the Insurance pages
class InsurancePageButton extends StatelessWidget {
  final void Function()? onPressed;
  final Color fontColor;
  final Color buttonColor;
  final String buttonLabel;
  final double width;
  final Color borderSideColor;
  const InsurancePageButton({
    this.fontColor = ConstColors.appWhite,
    this.buttonColor = ConstColors.app,
    this.borderSideColor = ConstColors.app,
    required this.buttonLabel,
    required this.width,
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 45,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            side: BorderSide(width: 1.0, color: borderSideColor),
            minimumSize: Size(width * 0.3, 50),
            elevation: 0,
            shadowColor: Colors.black,
            primary: buttonColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            )),
        child: Text(
          buttonLabel,
          style: TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: fontColor,
          ),
        ),
      ),
    );
  }
}
