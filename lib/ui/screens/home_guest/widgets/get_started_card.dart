import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class GetStartedCard extends StatelessWidget {
  const GetStartedCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        margin: EdgeInsets.zero,
        child: Stack(
          children: [
            Container(
              height: 208,
              alignment: AppLocalizations.of(context)
                          .locale
                          .languageCode
                          .toLowerCase() ==
                      "en"
                  ? Alignment.centerRight
                  : Alignment.centerLeft,
              child: Image.asset(
                AssPath.getStartedCardBg,
                matchTextDirection: true,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 22, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _TwoColoredTextTitle(),
                  SizedBox(height: 8),
                  _WellBeingStartDescText(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget _getStartedButton(BuildContext context) {
  //   return Container(
  //     alignment: Alignment.center,
  //     padding: EdgeInsets.only(
  //       top: height / 50,
  //     ),
  //     child: SizedBox(
  //       width: width,
  //       height: 45,
  //       child: ElevatedButton(
  //         onPressed: () {
  //           // Navigator.of(context).pushNamed(SignupScreen.routeName);
  //           showModalBottomSheet<void>(
  //             backgroundColor: Colors.white,
  //             context: context,
  //             isScrollControlled: true,
  //             clipBehavior: Clip.antiAlias,
  //             shape: const RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.only(
  //               topLeft: Radius.circular(16.0),
  //               topRight: Radius.circular(16.0),
  //             )),
  //             builder: (BuildContext context) => GetStartedWidget(),
  //           );
  //         },
  //         style: ButtonStyle(
  //             shape: MaterialStateProperty.all<RoundedRectangleBorder>(
  //                 RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(30.0),
  //         ))),
  //         child: Text(translate(LangKeys.startNow)),
  //       ),
  //     ),
  //   );
  // }
}

class _WellBeingStartDescText extends StatelessWidget {
  const _WellBeingStartDescText({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 188,
      child: Text(
        context.translate(LangKeys.wellBeingStartDesc),
        style: const TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: ConstColors.text,
        ),
      ),
    );
  }
}

class _TwoColoredTextTitle extends StatelessWidget {
  const _TwoColoredTextTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: Text.rich(
        TextSpan(
          children: [
            TextSpan(
                text: '${context.translate(LangKeys.wellnessBeginsWithYour)} '),
            TextSpan(
              text: context.translate(LangKeys.mentalHealth),
              style: const TextStyle(color: ConstColors.secondary),
            ),
            const TextSpan(
                text: '.', style: TextStyle(color: ConstColors.accentColor)),
          ],
        ),
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: ConstColors.app,
        ),
      ),
    );
  }
}
