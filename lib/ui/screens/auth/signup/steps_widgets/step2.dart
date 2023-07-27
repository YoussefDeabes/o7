import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/auth/sign_up_models/sign_up_models.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';

import 'package:o7therapy/ui/screens/auth/widgets/one_colored_header.dart';
import 'package:o7therapy/ui/screens/auth/widgets/two_colored_header_text.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// step 2 :: choose the gender step
// ignore: must_be_immutable
class StepTwo extends BaseStatefulWidget {
  const StepTwo({Key? key})
      : super(
          key: key,
          backGroundColor: Colors.transparent,
        );

  @override
  BaseState<BaseStatefulWidget> baseCreateState() => _StepTwoState();
}

class _StepTwoState extends BaseState<StepTwo> {
  Gender? _genderState;
  @override
  Widget baseBuild(BuildContext context) {
    _genderState = _getGenderDependingOnSignUpBloc(context);
    return Container(
      color: Colors.transparent,
      child: Column(
        children: [
          TwoColoredHeaderText(
            firstColoredText: translate(LangKeys.select),
            secondColoredText: translate(LangKeys.yourGender),
          ),
          SizedBox(height: height / 8),
          Column(
            children: [
              genderSelectorButton(
                gender: Gender.male,
                buttonText: translate(LangKeys.male),
              ),
              const SizedBox(height: 20),
              genderSelectorButton(
                gender: Gender.female,
                buttonText: translate(LangKeys.female),
              ),
              const SizedBox(height: 20),
              genderSelectorButton(
                gender: Gender.other,
                buttonText: translate(LangKeys.other),
              ),
              const SizedBox(height: 20),
              genderSelectorButton(
                gender: Gender.preferNotToSay,
                buttonText: translate(LangKeys.preferNotToSay),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ],
      ),
    );
  }

  Widget genderSelectorButton({
    required Gender gender,
    required String buttonText,
  }) {
    return SizedBox(
      width: width / 2.5,
      height: 60,
      child: TextButton(
        onPressed: () {
          context.read<AuthBloc>().add(GenderChangedEvent(gender));
          setState(() => _genderState = gender);
        },
        style: TextButton.styleFrom(
          backgroundColor: _genderState == gender
              ? ConstColors.app.withOpacity(0.10)
              : Colors.white,
        ),
        child: Text(
          buttonText,
          style: TextStyle(
              color: _genderState == gender
                  ? ConstColors.app
                  : ConstColors.appGrey,
              fontSize: 14),
        ),
      ),
    );
  }

  ///////////////////////////////////////////////////////////
  //////////////////// Helper methods ///////////////////////
  ///////////////////////////////////////////////////////////
  Gender? _getGenderDependingOnSignUpBloc(BuildContext context) {
    return context.read<AuthBloc>().getUserGender;
  }
}
