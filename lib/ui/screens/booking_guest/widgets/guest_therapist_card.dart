import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o7therapy/api/models/guest_therapist_list/List.dart';

import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/card_widgets.dart';
import 'package:o7therapy/ui/screens/booking/widgets/therapist_photo.dart';
import 'package:o7therapy/ui/screens/booking_guest/widgets/guest_play_video_button.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/therapist_profile_screen/guest_therapist_profile_screen.dart';

// the therapist Card
class GuestTherapistCard extends StatelessWidget {
  final TherapistData therapistModel;

  const GuestTherapistCard({required this.therapistModel, super.key});

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
            Navigator.of(context).pushNamed(
                GuestTherapistProfileScreen.routeName,
                arguments: {"therapistModel": therapistModel});
            // log("Go to therapist profile");
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
                      vertical: 0.015 * height,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            TherapistName(therapistName: therapistModel.name),
                          ],
                        ),
                        TherapistJobTitle(
                          canPrescribe: therapistModel.canPrescribe,
                        ),
                        Expanded(
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(
                                  height: 0.06 * size.width,
                                  child: TherapistYearsOfExperience(
                                    yearsOfExperience: therapistModel
                                        .yearsOfExperience!
                                        .toInt(),
                                  ),
                                ),
                                Expanded(
                                  child: SizedBox(
                                    height: 0.06 * size.width,
                                    child: TherapistSpokenLanguages(
                                      spokenLanguages: therapistModel.languages,
                                    ),
                                  ),
                                )
                              ]),
                        ),
                        SizedBox(
                          height: 0.05 * size.width,
                          child: TherapistTags(
                            tags: therapistModel.tags,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        GuestPlayVideoButton(videoUrl: therapistModel.biographyVideo?.url ?? "")
      ]),
    );
  }
}
