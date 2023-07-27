import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';

class CustomRoundedButton extends BaseStatelessWidget {
  final Function onPressed;
  final String text;
  final double widthValue;
  final bool? isLight;
  final double? fontsize;

  CustomRoundedButton({
    Key? key,
    required this.onPressed,
    required this.text,
    required this.widthValue,
    this.isLight = false,
    this.fontsize = 16,
  }) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.only(
        top: 10,
      ),
      child: SizedBox(
        width: widthValue,
        height: 40,
        child: ElevatedButton(
          onPressed: () {
            onPressed();
          },
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
              side: MaterialStateProperty.all<BorderSide>(BorderSide(
                  color: isLight! ? ConstColors.app : Colors.transparent,
                  width: 1)),
              backgroundColor: MaterialStateColor.resolveWith((states) =>
                  isLight! ? ConstColors.appWhite : ConstColors.app)),
          child: Text(
            text,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: fontsize,
                color: isLight! ? ConstColors.app : ConstColors.appWhite),
          ),
        ),
      ),
    );
  }
}
