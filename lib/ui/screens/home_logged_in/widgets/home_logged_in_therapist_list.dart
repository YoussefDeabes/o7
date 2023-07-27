import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/widgets/one_on_one_sessions_page/therapist_card.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/screens/home_logged_in/home_screen_therapists_bloc/home_screen_therapists_bloc.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class HomeLoggedInTherapistList extends StatelessWidget {
  static const ValueKey _key = ValueKey("HomeLoggedInTherapistList");
  const HomeLoggedInTherapistList({
    super.key = _key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeScreenTherapistsBloc, HomeScreenTherapistsState>(
      builder: (context, state) {
        if (state is LoadedHomeScreenTherapistsState) {
          return Column(
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: HeaderWidget(
                  text: context.translate(LangKeys.therapistsReadyToSupportYou),
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 16),
              ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  addAutomaticKeepAlives: true,
                  addRepaintBoundaries: false,
                  // itemCount: state.therapists.length,
                  // itemBuilder: (context, index) =>
                  children: state.therapists.map(
                    (therapist) {
                      return TherapistCard(therapistModel: therapist);
                    },
                  ).toList()),
            ],
          );
        } else {
          return const SizedBox.shrink();
        }
      },
    );
  }
}
