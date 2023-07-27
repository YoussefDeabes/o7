import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class EmptyChattingPage extends StatelessWidget {
  const EmptyChattingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox.shrink(),
          Align(
            alignment: Alignment.center,
            child: Text(
              AppLocalizations.of(context)
                  .translate(LangKeys.noMessagesHereYet),
              style: const TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
                color: ConstColors.text,
              ),
            ),
          ),
          const Center(child: FooterWidget()),
        ],
      ),
    );
  }
}
