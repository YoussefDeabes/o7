import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class NoPaymentHistoryPage extends BaseStatelessWidget {
  NoPaymentHistoryPage({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
              foregroundImage: const AssetImage(AssPath.activityBanner),
              backgroundColor: Colors.transparent,
              radius: width / 3,
            ),
            SizedBox(height: 0.03 * height),
            SizedBox(
              width: width * 0.6,
              child: Text(
                translate(LangKeys.noPaymentHistory),
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                  color: ConstColors.text,
                ),
              ),
            ),
            SizedBox(height: 0.08 * height),
            _getBookASessionButton(),
          ],
        ),
      ),
    );
  }

  /// Get Book A Session button
  Widget _getBookASessionButton() {
    return SizedBox(
        width: width * 0.7,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            //TODO Navigate the user to Book A Session pressed
            log("Book A Session pressed in the payment history");
          },
          style: ElevatedButton.styleFrom(
              onPrimary: ConstColors.app,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
          child: Text(
            translate(LangKeys.bookASession),
            style: const TextStyle(
              fontSize: 14.0,
              fontWeight: FontWeight.w500,
              color: ConstColors.appWhite,
            ),
          ),
        ));
  }
}
