import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

//Cancellation policy expand collapse section
class CancellationPolicy extends BaseStatelessWidget {
  CancellationPolicy({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: height / 20),
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
                    translate(LangKeys.cancellationPolicy),
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
                  _cancellationPolicyText(
                      bold1: translate(LangKeys.a100Percent),
                      bold2: translate(LangKeys.a24Hours),
                      text1: translate(LangKeys.a100PercentRefund1),
                      text2: translate(LangKeys.a100PercentRefund2)),
                  _cancellationPolicyText(
                      bold1: translate(LangKeys.a50Percent),
                      bold2: translate(LangKeys.sixTo24Hours),
                      text1: translate(LangKeys.a50PercentRefund1),
                      text2: translate(LangKeys.a50PercentRefund2)),
                  _cancellationPolicyText(
                      bold2: translate(LangKeys.lessThan6Hours),
                      text1: translate(LangKeys.noRefund1),
                      text2: translate(LangKeys.noRefund2)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

//Cancellation policy
  Widget _cancellationPolicyText(
      {String? bold1,
      required String bold2,
      required String text1,
      required String text2}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 9.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          const Text("• ", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(
            width: width * 0.8,
            child: Text.rich(TextSpan(
              style: const TextStyle(fontSize: 12, color: ConstColors.text),
              children: <TextSpan>[
                TextSpan(
                    text: bold1 ?? "",
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: text1),
                TextSpan(
                    text: bold2,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                TextSpan(text: text2),
              ],
            )),
          ),
        ],
      ),
    );
  }
}
