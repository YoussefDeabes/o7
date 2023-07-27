import 'package:flutter/material.dart';
import 'package:o7therapy/ui/screens/booking_guest/widgets/intro_section.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/faqs_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/get_started_card.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/intro_mental_health_video.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/our_services_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/reviews_card.dart';
import 'package:o7therapy/ui/widgets/shared_guest_widgets/start_now_button.dart';

import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class HomeGuestScreen extends StatefulWidget {
  static const routeName = '/home-guest-screen';

  const HomeGuestScreen({Key? key}) : super(key: key);

  @override
  State<HomeGuestScreen> createState() => _HomeGuestScreenState();
}

class _HomeGuestScreenState extends State<HomeGuestScreen>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SafeArea(
      child: Scaffold(
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HeaderWidget(
                  text: context.translate(LangKeys.welcomeToO7),
                  fontWeight: FontWeight.w700,
                  fontSize: 18.0,
                ),
                // FilterWidget(
                //     filterList: [
                //       translate(LangKeys.sleeping),
                //       translate(LangKeys.anxiety),
                //       translate(LangKeys.stress),
                //       translate(LangKeys.depression),
                //       translate(LangKeys.angerManagement),
                //       translate(LangKeys.relationships),
                //       translate(LangKeys.grief)
                //     ],
                //     onPressed: () => Navigator.of(context)
                //         .pushNamed(FilteredGuestScreen.routeName)),
                const SizedBox(height: 16),
                const GetStartedCard(),
                // HeaderWidget(text: translate(LangKeys.testimonials)),
                // ReviewsCardWidget(reviews: reviews),
                // // HeaderWidget(text: translate(LangKeys.introToMentalHealthTitle)),
                // // MentalHealthVideo(
                // //     videoUrl: 'https://www.youtube.com/watch?v=nKrpV2RI7-Y'),
                // // _getTextButton(translate(LangKeys.learnMore), () {}),
                // HeaderWidget(text: translate(LangKeys.howItWorks)),
                // const HowItWorks(),

                // _getStartNowButton(() {
                //   showModalBottomSheet<void>(
                //     backgroundColor: Colors.white,
                //     context: context,
                //     isScrollControlled: true,
                //     clipBehavior: Clip.antiAlias,
                //     shape: const RoundedRectangleBorder(
                //         borderRadius: BorderRadius.only(
                //           topLeft: Radius.circular(16.0),
                //           topRight: Radius.circular(16.0),
                //         )),
                //     builder: (BuildContext context) =>GetStartedWidget(),
                //   );
                // }),
                //
                const SizedBox(height: 32),
                const IntroMentalHealthVideo(),
                const SizedBox(height: 32),
                const IntroSection(),
                const SizedBox(height: 32),
                HeaderWidget(text: context.translate(LangKeys.ourServices)),
                const OurServicesWidget(),
                const SizedBox(height: 32),
                const ReviewsCardWidget(),
                const SizedBox(height: 32),
                const StartNowButton(),
                const SizedBox(height: 32),
                const FaqsWidget(fromGuestScreen: true),
                const FooterWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
