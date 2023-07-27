import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';

class CustomLoadingWidget extends StatelessWidget {
  const CustomLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Opacity(
          opacity: 0.1,
          child: ModalBarrier(dismissible: false, color: ConstColors.app),
        ),
        Center(
            child: Platform.isAndroid
                ? const CircularProgressIndicator(color: ConstColors.appGrey)
                : const CupertinoActivityIndicator(radius: 13)),
      ],
    );
  }
}
