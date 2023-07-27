import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class SliderSection extends StatelessWidget {
  const SliderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: EdgeInsets.only(top: context.height * 0.05),
      height: context.height / 1.45,
      child: IntroductionScreen(
        rawPages: [
          _OnboardingPage(
            assetPath: AssPath.onboarding1,
            bodyTitle: context.translate(LangKeys.welcomeToO7),
            description: context.translate(LangKeys.welcomeToO7Desc),
          ),
          _OnboardingPage(
            assetPath: AssPath.onboarding2,
            bodyTitle: context.translate(LangKeys.onlineTherapySessions),
            description: context.translate(LangKeys.onlineTherapySessionsDesc),
          ),
          _OnboardingPage(
            assetPath: AssPath.onboarding3,
            bodyTitle: context.translate(LangKeys.haveYourOwnSpace),
            description: context.translate(LangKeys.haveYourOwnSpaceDesc),
          ),
        ],
        // pages: [
        //   _getPageViewModel(
        //     context: context,
        //     assetPath: AssPath.onboarding1,
        //     bodyTitle: context.translate(LangKeys.welcomeToO7),
        //     description: context.translate(LangKeys.welcomeToO7Desc),
        //   ),
        //   _getPageViewModel(
        //     context: context,
        //     assetPath: AssPath.onboarding2,
        //     bodyTitle: context.translate(LangKeys.onlineTherapySessions),
        //     description: context.translate(LangKeys.onlineTherapySessionsDesc),
        //   ),
        //   _getPageViewModel(
        //     context: context,
        //     assetPath: AssPath.onboarding3,
        //     bodyTitle: context.translate(LangKeys.haveYourOwnSpace),
        //     description: context.translate(LangKeys.haveYourOwnSpaceDesc),
        //   ),
        // ],
        skipOrBackFlex: 0,
        nextFlex: 0,
        dotsDecorator: DotsDecorator(
          size: const Size(5.0, 5.0),
          color: ConstColors.accent.withOpacity(0.30),
          activeColor: ConstColors.accent,
          activeSize: const Size(20, 4.0),
          activeShape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(25.0)),
          ),
        ),
        globalBackgroundColor: Colors.transparent,
        showNextButton: false,
        showDoneButton: false,
        controlsPadding: EdgeInsets.zero,
        isBottomSafeArea: false,
      ),
    );
  }

  // PageViewModel _getPageViewModel({
  //   required BuildContext context,
  //   required String assetPath,
  //   required String bodyTitle,
  //   required String description,
  // }) {
  //   return PageViewModel(
  //     useScrollView: false,
  //     titleWidget: SvgPicture.asset(
  //       assetPath,
  //       width: context.width * 0.7,
  //       height: context.width * 0.7,
  //     ),
  //     bodyWidget: Column(
  //       mainAxisAlignment: MainAxisAlignment.start,
  //       crossAxisAlignment: CrossAxisAlignment.center,
  //       children: [
  //         FittedBox(
  //           child: Text(
  //             bodyTitle,
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               fontSize: 24,
  //               fontWeight: FontWeight.w700,
  //               color: ConstColors.app,
  //             ),
  //           ),
  //         ),
  //         const SizedBox(height: 16),
  //         Align(
  //           alignment: Alignment.topCenter,
  //           child: Text(
  //             description,
  //             textAlign: TextAlign.center,
  //             style: const TextStyle(
  //               fontSize: 14,
  //               fontWeight: FontWeight.w400,
  //               color: ConstColors.text,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //     decoration: const PageDecoration(
  //       bodyAlignment: Alignment.bottomCenter,
  //       titlePadding: EdgeInsets.only(top: 24.0, bottom: 32.0),
  //       footerFlex: 0,
  //       bodyFlex: 1,
  //       safeArea: 0,
  //       contentMargin: EdgeInsets.all(0),
  //     ),
  //   );
  // }
}

class _OnboardingPage extends StatelessWidget {
  const _OnboardingPage({
    super.key,
    required this.assetPath,
    required this.bodyTitle,
    required this.description,
  });
  final String assetPath;
  final String bodyTitle;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 24, bottom: 16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            assetPath,
            width: context.width * 0.7,
            height: context.width * 0.7,
          ),
          const SizedBox(height: 28),
          FittedBox(
            child: Text(
              bodyTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: ConstColors.app,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            height: context.height * 0.1,
            alignment: Alignment.topCenter,
            child: Text(
              description,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: ConstColors.text,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
