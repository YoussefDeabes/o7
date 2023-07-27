import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/bloc/get_matched_pressed_bloc/get_matched_button_bloc.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/ui/screens/booking/widgets/custom_sliver.dart';
import 'package:o7therapy/ui/widgets/slivers/shrink_sliver_widget.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/get_match_method_helper.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class AllTherapistsStringRow extends StatelessWidget {
  const AllTherapistsStringRow({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TherapistsBloc, TherapistsState>(
        builder: (context, state) {
      if (state is LoadedTherapistsState) {
        return SliverPadding(
          padding: const EdgeInsets.only(top: 8.0),
          sliver: SliverPersistentHeader(
            pinned: true,
            floating: false,
            delegate: CustomSliver(
              maxHeight: 0.04 * context.height,
              minHeight: 0.04 * context.height,
              child: Material(
                color: ConstColors.scaffoldBackground,
                child: Container(
                    color: ConstColors.scaffoldBackground,
                    height: context.height,
                    width: context.width,
                    padding:
                        EdgeInsets.symmetric(vertical: 0.003 * context.height),
                    alignment: AlignmentDirectional.centerStart,
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _AllTherapistsStringWidget(),
                        _GetMatchedAgainBuilder()
                      ],
                    )),
              ),
            ),
          ),
        );
      }
      return const ShrinkSliverWidget();
    });
  }
}

class _AllTherapistsStringWidget extends StatelessWidget {
  const _AllTherapistsStringWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      context.translate(LangKeys.allTherapists),
      style: const TextStyle(
        color: ConstColors.app,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _GetMatchedAgainBuilder extends StatelessWidget {
  const _GetMatchedAgainBuilder({super.key});

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (context) {
        TherapistsBookedBeforeState therapistsBookedBeforeState =
            context.watch<TherapistsBookedBeforeBloc>().state;
        GetMatchedButtonState getMatchedButtonState =
            context.watch<GetMatchedButtonBloc>().state;

        if (therapistsBookedBeforeState is LoadedTherapistsBookedBeforeState &&
            therapistsBookedBeforeState.therapists.isNotEmpty) {
          return const GetMatchedAgainButton();
        } else {
          /// if the user hide get matched card
          /// then show get match Again
          if (getMatchedButtonState is HideGetMatchedCard) {
            return const GetMatchedAgainButton();
          }
          return const SizedBox.shrink();
        }
      },
    );
  }
}

class GetMatchedAgainButton extends StatelessWidget {
  const GetMatchedAgainButton({super.key});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => launchGetMatchedUrl(),
      style: TextButton.styleFrom(padding: EdgeInsets.zero),
      child: Text(
        context.translate(LangKeys.getMatchedAgain),
        style: const TextStyle(
          fontSize: 13,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w500,
          color: Color(0xFF429F91),
        ),
      ),
    );
  }
}
