import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';

class ResetPasswordHeaderImage extends StatelessWidget {
  const ResetPasswordHeaderImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: ConstColors.appWhite,
      radius: MediaQuery.of(context).size.width / 4,
      child: SvgPicture.asset(
        AssPath.forgetPasswordImage,
        fit: BoxFit.cover,
      ),
    );
  }
}
