import 'package:flutter/material.dart';
import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';

class FailHeaderImage extends StatelessWidget with ScreenSizer {
  FailHeaderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    initScreenSizer(context);
    return Padding(
      padding: EdgeInsets.only(top: height / 15),
      child: CircleAvatar(
        foregroundImage: const AssetImage(AssPath.fail),
        backgroundColor: ConstColors.scaffoldBackground,
        maxRadius: width * 0.35,
      ),
    );
  }
}
