import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/bloc/get_matched_pressed_bloc/get_matched_button_bloc.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/get_match_method_helper.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class HomeScreenMatchingCallCard extends StatefulWidget {
  const HomeScreenMatchingCallCard({super.key});

  @override
  State<HomeScreenMatchingCallCard> createState() =>
      _HomeScreenMatchingCallCardState();
}

class _HomeScreenMatchingCallCardState extends State<HomeScreenMatchingCallCard>
    with WidgetsBindingObserver {
  bool _isTryToLaunch = false;

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.paused:
        if (_isTryToLaunch) {
          GetMatchedButtonBloc.bloc(context).add(
            const PressedGetMatchedButtonEvent(),
          );
          log("User Try To Launch Get Matched Url - $state");
        }
        break;
      default:
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TherapistsBookedBeforeBloc, TherapistsBookedBeforeState>(
      builder: (context, state) {
        GetMatchedButtonState getMatchedButtonState =
            context.watch<GetMatchedButtonBloc>().state;
        if (getMatchedButtonState is HideGetMatchedCard) {
          return const SizedBox.shrink();
        }
        if (state is LoadedTherapistsBookedBeforeState &&
            state.therapists.isEmpty) {
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 16),
            padding: const EdgeInsets.only(
              top: 16,
              left: 25,
              right: 25,
              bottom: 23,
            ),
            alignment: Alignment.topCenter,
            decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16)),
                color: ConstColors.appWhite,
                border: Border.all(
                  color: ConstColors.disabled,
                  width: 1,
                ),
                image: DecorationImage(
                  scale: 2,
                  isAntiAlias: true,
                  fit: BoxFit.fitHeight,
                  alignment: Directionality.of(context) == TextDirection.ltr
                      ? const AlignmentDirectional(2.4, 0)
                      : const AlignmentDirectional(2.4, 0.0),
                  matchTextDirection: true,
                  image: const AssetImage(AssPath.getMatchedBackground),
                )),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                FittedBox(
                  child: Text(
                    context.translate(LangKeys.investInYourMentalHealth),
                    textAlign: TextAlign.start,
                    maxLines: 1,
                    style: const TextStyle(
                      color: ConstColors.app,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  context.translate(
                    LangKeys.homeScreenMatchingCallCardDescription,
                  ),
                  textAlign: TextAlign.start,
                  style: const TextStyle(
                    color: ConstColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                const SizedBox(height: 22),
                Align(
                  alignment: Alignment.center,
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () async {
                        _isTryToLaunch = await launchGetMatchedUrl();
                        setState(() {});
                      },
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32),
                        ),
                      ),
                      child: Text(
                        context.translate(LangKeys.getMatched),
                        style: const TextStyle(
                          color: ConstColors.appWhite,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        return const SizedBox.shrink();
      },
    );
  }
}
