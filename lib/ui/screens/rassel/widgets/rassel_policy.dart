import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// policy expand collapse section
class RasselPolicy extends StatelessWidget {
  const RasselPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.height / 20),
      child: ExpandableNotifier(
        initialExpanded: true,
        child: ScrollOnExpand(
          theme: const ExpandableThemeData(
              iconColor: ConstColors.app,
              tapBodyToCollapse: true,
              tapBodyToExpand: true),
          child: ExpandablePanel(
            header: Row(
              children: [
                SvgPicture.asset(
                  AssPath.cancellationIcon,
                  // scale: 2,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  child: Text(
                    context.translate(LangKeys.policy),
                    style: const TextStyle(
                      color: ConstColors.app,
                      fontWeight: FontWeight.w500,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            collapsed: const SizedBox(),
            expanded: Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RasselPolicyText(
                    bold1: DateFormat('MMM d, y').format(
                        DateTime.now().toLocal().add(const Duration(days: 31))),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Rassel subscription policy
class RasselPolicyText extends StatelessWidget {
  final String? bold1;

  const RasselPolicyText({
    super.key,
    this.bold1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
            child: Text.rich(TextSpan(
              style: const TextStyle(fontSize: 14, color: ConstColors.text),
              children: <TextSpan>[
                TextSpan(text: context.translate(LangKeys.rasselPolicy1)),
                TextSpan(
                    text: bold1 ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: context.translate(LangKeys.rasselPolicy2)),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
