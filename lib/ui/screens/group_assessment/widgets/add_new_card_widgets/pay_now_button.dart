import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class PayNowButton extends BaseStatelessWidget {
  final void Function()? onPressed;
  PayNowButton({required this.onPressed, super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: 20.0, left: width / 10, right: width / 10, bottom: 20),
        child: SizedBox(
          width: width,
          height: 45,
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ),
            ),
            child: Text(translate(LangKeys.payNow)),
          ),
        ),
      ),
    );
  }
}
