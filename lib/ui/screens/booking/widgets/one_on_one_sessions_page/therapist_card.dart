import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';

import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';

import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/card_widgets.dart';
import 'package:o7therapy/ui/screens/booking/widgets/play_video_button.dart';
import 'package:o7therapy/ui/screens/booking/widgets/therapist_photo.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/therapist_profile_screen.dart';

// the therapist Card
class TherapistCard extends StatelessWidget {
  final TherapistData therapistModel;

  const TherapistCard({required this.therapistModel, super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return Container(
      height: 0.22 * height,
      // height: height > width ? 0.2 * height : 0.2 * width, // /812
      margin: EdgeInsets.symmetric(vertical: 0.008 * height),
      child: Stack(children: [
        InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(TherapistProfileScreen.routeName,
                arguments: {"therapistModel": therapistModel});
            log("Go to therapist profile");
            MixpanelBookingBloc.bloc(context).add(TherapistCardClickedEvent(
              therapistModel.id,
              therapistModel.name,
            ));
          },
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Ink(
            height: 0.19 * height,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              border: Border.all(color: ConstColors.disabled),
              color: Colors.white,
            ),
            child: Row(
              children: [
                // the Therapist Photo Avatar
                TherapistPhoto(
                    key: ValueKey(therapistModel.image!.url!),
                    imageUrl: therapistModel.image!.url!,
                    width: width),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.04 * width,
                      vertical: 0.01 * height,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: TherapistName(
                                therapistName: therapistModel.name,
                              ),
                            ),
                            // _getTherapistRank(),
                          ],
                        ),
                        TherapistJobTitle(
                          canPrescribe: therapistModel.canPrescribe,
                        ),
                        TherapistSessionStatus(
                          clientStatus: therapistModel.clientStatus,
                          currency: therapistModel.currency,
                          feesPerSession: therapistModel.feesPerSession,
                          flatRate: therapistModel.flatRate,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TherapistYearsOfExperience(
                              yearsOfExperience:
                                  therapistModel.yearsOfExperience,
                            ),
                            TherapistSpokenLanguages(
                              spokenLanguages: therapistModel.languages,
                            )
                          ],
                        ),
                        TherapistTags(tags: therapistModel.tags),
                        TherapistAvailability(
                          acceptNewClient: therapistModel.acceptNewClient,
                          firstAvailableSlotDate:
                              therapistModel.firstAvailableSlotDate,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        PlayVideoButton(videoUrl: therapistModel.biographyVideo?.url ?? "")
      ]),
    );
  }
}
