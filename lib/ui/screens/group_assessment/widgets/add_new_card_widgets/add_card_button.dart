import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class AddCardButton extends StatelessWidget {
  final void Function()? onAddCard;

  const AddCardButton({required this.onAddCard, super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onAddCard,
      child: Chip(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: ConstColors.app,
        label: Text(
          AppLocalizations.of(context).translate(LangKeys.add),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.appWhite,
          ),
        ),
      ),
    );
  }
}
