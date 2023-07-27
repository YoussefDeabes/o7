import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

mixin RasselServiceInfoBottomSheet {
  rasselServiceInfoBottomSheet(
    BuildContext context,
    String Function(String key) translate,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext context) {
        return SafeArea(
          child: Container(
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
              color: ConstColors.appWhite,
            ),
            margin: const EdgeInsets.only(top: 48),
            padding: const EdgeInsets.only(
              left: 24.0,
              right: 24.0,
              bottom: 16.0,
              top: 16.0,
            ),
            child: Column(
              children: [
                Text(translate(LangKeys.aboutO7Rassel),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: ConstColors.app,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    )),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text.rich(
                        TextSpan(
                          style: const TextStyle(
                              fontSize: 12, color: ConstColors.text),
                          children: <TextSpan>[
                            TextSpan(
                                text: translate(LangKeys.whatIsRasselDetails1),
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ConstColors.app)),
                            TextSpan(
                                text:
                                    "\n${translate(LangKeys.whatIsRasselDetails1Exp)}",
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                                text:
                                    '\n\n${translate(LangKeys.whatIsRasselDetails2)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ConstColors.app)),
                            TextSpan(
                                text:
                                    '\n${translate(LangKeys.whatIsRasselDetails2Exp)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                                text:
                                    '\n\n${translate(LangKeys.whatIsRasselDetails3)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ConstColors.app)),
                            TextSpan(
                                text:
                                    '\n${translate(LangKeys.whatIsRasselDetails3Exp)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                                text:
                                    '\n\n${translate(LangKeys.whatIsRasselDetails4)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ConstColors.app)),
                            TextSpan(
                                text:
                                    '\n${translate(LangKeys.whatIsRasselDetails4Exp)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                              text: "\n\n${translate(LangKeys.one)}.",
                              style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: ConstColors.text),
                            ),
                            TextSpan(
                              text:
                                  " ${translate(LangKeys.subscribeNowSmall)} ",
                              style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: ConstColors.secondary),
                            ),
                            TextSpan(
                                text: translate(
                                    LangKeys.whatIsRasselDetails4Exp1),
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                              text: "\n${translate(LangKeys.two)}.",
                              style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: ConstColors.text),
                            ),
                            TextSpan(
                                text: ' ${translate(LangKeys.startAChat)} ',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.secondary)),
                            TextSpan(
                                text: translate(
                                    LangKeys.whatIsRasselDetails4Exp2),
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                              text: "\n${translate(LangKeys.three)}.",
                              style: const TextStyle(
                                  height: 1.5,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: ConstColors.text),
                            ),
                            TextSpan(
                                text: ' ${translate(LangKeys.enjoy)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                                text: ' ${translate(LangKeys.unlimited)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.secondary)),
                            TextSpan(
                                text:
                                    ' ${translate(LangKeys.whatIsRasselDetails4Exp3)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                                text:
                                    '\n\n${translate(LangKeys.whatIsRasselDetails5)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                    color: ConstColors.app)),
                            TextSpan(
                                text:
                                    '\n${translate(LangKeys.whatIsRasselDetails5Exp1)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                            TextSpan(
                                text:
                                    '\n${translate(LangKeys.whatIsRasselDetails5Exp2)}',
                                style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
