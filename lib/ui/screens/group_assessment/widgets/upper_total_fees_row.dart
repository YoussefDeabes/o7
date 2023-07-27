import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class UpperTotalFessRow extends StatelessWidget {
  final String currency;
  final double sessionFees;
  const UpperTotalFessRow({
    super.key,
    required this.currency,
    required this.sessionFees,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          AppLocalizations.of(context).translate(LangKeys.total),
          style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: ConstColors.app),
        ),
        Text(
          '${sessionFees.toInt()} ${getCurrencyNameByContext(context, currency)}',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: ConstColors.text,
          ),
        ),
      ],
    );
  }
}
