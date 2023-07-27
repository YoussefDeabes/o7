import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';

class CustomErrorWidget extends StatelessWidget {
  final String exception;
  const CustomErrorWidget(this.exception, {super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            foregroundImage: const AssetImage(AssPath.fail),
            backgroundColor: ConstColors.scaffoldBackground,
            maxRadius: MediaQuery.of(context).size.width * 0.35,
          ),
          Text(
            "Oops.. Something Went Wrong! \n $exception",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
