import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';

class ExceptionBookingScreenWidget extends BaseStatelessWidget {
  final String exception;
  ExceptionBookingScreenWidget(this.exception, {super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: height / 15),
              child: CircleAvatar(
                foregroundImage: const AssetImage(AssPath.fail),
                backgroundColor: ConstColors.scaffoldBackground,
                maxRadius: width * 0.35,
              ),
            ),
            Text(
              "Oops.. Something Went Wrong! \n $exception",
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
