import 'dart:developer';

import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/widgets/contact_us/contact_us_mixin.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class HelpFloatingActionButton extends StatelessWidget
    with ContactUsMixin, Translator {
  HelpFloatingActionButton({Key? key}) : super(key: key);
  ValueNotifier<bool> isDialOpen = ValueNotifier(false);

  // Call Us and What's app textStyle widget
  TextStyle callUsAndWhatsAppTextStyle =
      const TextStyle(fontSize: 14, fontWeight: FontWeight.w500);

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return WillPopScope(
      onWillPop: () async {
        if (isDialOpen.value) {
          isDialOpen.value = false;
          return false;
        } else {
          return true;
        }
      },
      child: SpeedDial(
        childPadding: EdgeInsets.zero,
        renderOverlay: true,
        backgroundColor: ConstColors.app,
        foregroundColor: Colors.white,
        activeBackgroundColor: ConstColors.app,
        activeForegroundColor: Colors.white,
        visible: true,
        closeManually: false,
        curve: Curves.bounceIn,
        overlayColor: Colors.black,
        overlayOpacity: 0.2,
        label: FittedBox(
          child: Text(
            translate(LangKeys.help),
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14,
              color: ConstColors.appWhite,
            ),
          ),
        ),
        openCloseDial: isDialOpen,
        childMargin: EdgeInsets.zero,
        children: [
          // _getSpeedDialChild(
          //   title: translate(LangKeys.getMatched),
          //   onTap: () {
          //     // TODO getMatched on help fab pressed ;
          //     log("getMatched pressed");
          //   },
          // ),

          _getSpeedDialChild(
            title: translate(LangKeys.contactUs),
            onTap: () {
              getContactUsOnPressed(context);
              log("contactUs pressed");
            },
          ),
          _getSpeedDialChild(
            title: translate(LangKeys.howToBook),
            onTap: () {
              _howToBookPressed(context);
              log("howToBook pressed");
            },
          ),
        ],
      ),
    );
  }

  void _howToBookPressed(BuildContext context) {
    showDialog(
      useSafeArea: true,
      useRootNavigator: true,
      barrierDismissible: true,
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: Colors.transparent,
          contentPadding: EdgeInsets.zero,
          insetPadding: const EdgeInsets.symmetric(horizontal: 24),
          content: FutureBuilder(
              future: PrefManager.getLang(),
              builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
                return Image.asset(
                  snapshot.data == 'en'
                      ? AssPath.howItWorks
                      : AssPath.howItWorksAr,
                  scale: 0.8,
                );
              }),
        );
      },
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  SpeedDialChild _getSpeedDialChild(
      {required String title, void Function()? onTap}) {
    return SpeedDialChild(
      labelWidget: Chip(
        backgroundColor: Colors.white,
        labelPadding: const EdgeInsets.symmetric(vertical: 7, horizontal: 4.5),
        label: Text(
          title,
          textAlign: TextAlign.end,
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
            color: ConstColors.secondary,
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      onTap: onTap,
    );
  }
}
