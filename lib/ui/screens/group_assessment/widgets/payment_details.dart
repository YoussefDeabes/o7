import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Header for what you will book for
class PaymentDetails extends BaseStatelessWidget {
  PaymentDetails({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        translate(LangKeys.paymentDetails),
        style: const TextStyle(
          color: ConstColors.app,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
