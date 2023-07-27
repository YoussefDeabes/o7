import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';

// ignore: must_be_immutable
class AuthButtonWidget extends BaseStatelessWidget {
  final String title;
  final void Function() onPressed;

  AuthButtonWidget(this.title, this.onPressed, {Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 90),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
          ),
          primary: themeData.primaryColor),
      child: Text(
        title,
        style: textTheme.button,
      ),
      onPressed: onPressed,
    );
  }
}
