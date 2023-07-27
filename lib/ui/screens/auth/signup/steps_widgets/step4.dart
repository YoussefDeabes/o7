import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/auth/sign_up_models/sign_up_models.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/bloc/auth_bloc/auth_bloc.dart';

import 'package:o7therapy/ui/screens/auth/widgets/two_colored_header_text.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// step 4 get the user goals why using the app
// ignore: must_be_immutable
class StepFour extends BaseStatefulWidget {
  const StepFour({Key? key})
      : super(
          key: key,
          backGroundColor: Colors.transparent,
        );

  @override
  BaseState<StepFour> baseCreateState() {
    return _StepFourState();
  }
}

class _StepFourState extends BaseState<StepFour> {
  final List<Goals> _goalsState = [];

  @override
  void initState() {
    _updateUserGoalsDependingOnBloc();
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      children: [
        TwoColoredHeaderText(
            firstColoredText: translate(LangKeys.i),
            secondColoredText: translate(LangKeys.wantTo)),
        Text(
          translate(LangKeys.selectYourGoalsOrSkip),
          style: const TextStyle(color: ConstColors.text, fontSize: 16),
        ),
        SizedBox(
          height: height / 8,
        ),
        _getGridViewChoices(),
      ],
    );
  }

  //Get Gridview choices
  Widget _getGridViewChoices() {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, right: 24.0),
      child: StaggeredGridView.countBuilder(
        staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 18,
        itemCount: Goals.values.length,
        primary: false,
        shrinkWrap: true,
        itemBuilder: (ctx, index) => SizedBox(
          width: width / 2.5,
          height: 60,
          child: TextButton(
            onPressed: () {
              setState(() {
                if (_goalsState.length <= Goals.values.length) {
                  if (_goalsState.contains(Goals.values[index])) {
                    _goalsState.removeWhere(
                        (element) => element == Goals.values[index]);
                  } else {
                    _goalsState.add(Goals.values[index]);
                  }

                  // every time user choose goal or remove one
                  // the list is updated and converted to list of strings
                  context.read<AuthBloc>().add(GoalsChangedEvent(_goalsState));
                }
              });
            },
            style: TextButton.styleFrom(
              backgroundColor: _chooseButtonColor(index),
              side:const BorderSide(color: ConstColors.disabled),
            ),
            child: Text(
              translate(Goals.values[index].translatedName),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: _chooseTextColor(index),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color? _chooseButtonColor(int index) {
    if (_goalsState.contains(Goals.values[index])) {
      return ConstColors.app.withOpacity(0.10);
    } else {
      return Colors.transparent;
    }
  }

  // Color _chooseBorderColor(int index) {
  //   if (_goalsState.contains(Goals.values[index])) {
  //     return ConstColors.app;
  //   } else {
  //     return ConstColors.disabled;
  //   }
  // }

  Color? _chooseTextColor(int index) {
    if (_goalsState.contains(Goals.values[index])) {
      return ConstColors.app;
    } else {
      return ConstColors.appGrey;
    }
  }

  //////////////////////////////////////////////////////
  ///////////////////helper methods/////////////////////
  /////////////////////////////////////////////////////
  void _updateUserGoalsDependingOnBloc() {
    List<Goals> userGoals = context.read<AuthBloc>().getUserGoals;
    if (userGoals.isNotEmpty) {
      for (var goal in userGoals) {
        _goalsState.add(goal);
      }
    }
  }
}
