import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o7therapy/bloc/get_matched_pressed_bloc/get_matched_button_bloc.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/get_match_method_helper.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Get Matched of booking screen when the user is logged in
class ServicesScreenGetMatchedCard extends StatefulWidget {
  const ServicesScreenGetMatchedCard({Key? key}) : super(key: key);

  @override
  State<ServicesScreenGetMatchedCard> createState() =>
      _ServicesScreenGetMatchedCardState();
}

class _ServicesScreenGetMatchedCardState
    extends State<ServicesScreenGetMatchedCard> with WidgetsBindingObserver {
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
    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsetsDirectional.only(top: 16),
        alignment: Alignment.topCenter,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          border: Border.all(color: ConstColors.disabled),
          color: Colors.white,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _getMatchedTitle(),
            const SizedBox(height: 8),
            _getMatchedDetails(),
            const SizedBox(height: 16),
            _getBookACallButton(),
          ],
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// get Matched Title
  Widget _getMatchedTitle() {
    // Get matched with the most suitable therapist for you.
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: Text(
        context
            .translate(LangKeys.getMatchedWithTheMostSuitableTherapistForYou),
        textAlign: TextAlign.start,
        style: const TextStyle(
          fontWeight: FontWeight.w700,
          fontSize: 18.0,
          color: ConstColors.app,
        ),
      ),
    );
  }

  /// get matched details
  Widget _getMatchedDetails() {
    return SizedBox(
      width: context.width * 0.68,
      child: Text(
        context.translate(LangKeys.cannotDecideYourFirstStep),
        textAlign: TextAlign.start,
        style: const TextStyle(
          color: ConstColors.text,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }

  /// get Matched Button
  Widget _getBookACallButton() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: SizedBox(
        width: context.width,
        height: 45,
        child: ElevatedButton(
          onPressed: () async {
            _isTryToLaunch = await launchGetMatchedUrl();
            setState(() {});
          },
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(50.0),
            ),
            elevation: 0,
          ),
          child: Text(
            context.translate(LangKeys.bookACall),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
