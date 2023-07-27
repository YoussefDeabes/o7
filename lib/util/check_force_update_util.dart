import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:url_launcher/url_launcher.dart';

class CheckForceUpdateUtil {
  static Future<void> checkForceUpdate(BuildContext context) async {
    final isForceUpdate = await PrefManager.isEnforceUpdate();
    final storeLink = await PrefManager.getStoreLink();

    if (isForceUpdate && storeLink != null) {
      showModalBottomSheet(
          isDismissible: false,
          enableDrag: false,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(16), topLeft: Radius.circular(16))),
          context: context,
          builder: (context) {
            return ForceUpdate(storeLink: storeLink);
          });
    }
  }
}

class ForceUpdate extends BaseStatelessWidget {
  final String storeLink;
  ForceUpdate({
    super.key,
    required this.storeLink,
  });

  @override
  Widget baseBuild(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false, // prevents pop
      child: Container(
          height: height * 0.35,
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.min,
            children: [
              Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    translate(LangKeys.forceUpdateTitle),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: ConstColors.app),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    translate(LangKeys.forceUpdateDesc),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: ConstColors.text),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(bottom: height * 0.05),
                child: ElevatedButton(
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(
                            const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(36))))),
                    onPressed: () {
                      _launchUrl(storeLink, context);
                    },
                    child: Text(translate(LangKeys.updateNow))),
              )
            ],
          )),
    );
  }

  void _launchUrl(String url, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      final snackBar = SnackBar(
        content: Text(translate(LangKeys.errorOccurred)),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
