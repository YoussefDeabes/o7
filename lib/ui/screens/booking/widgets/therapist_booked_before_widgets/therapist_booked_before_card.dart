import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart' show DateFormat;

import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';

import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/therapist_availability.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/therapist_name.dart';
import 'package:o7therapy/ui/screens/booking/widgets/play_video_button.dart';
import 'package:o7therapy/ui/screens/booking/widgets/therapist_photo.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/therapist_profile_screen.dart';

import 'package:o7therapy/util/lang/app_localization_keys.dart';

// ignore: must_be_immutable
// the therapist Card
class TherapistBookedBeforeCard extends BaseStatelessWidget {
  final TherapistData therapistModel;

  TherapistBookedBeforeCard({required this.therapistModel, super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      height: 0.18 * height,
      width: width * 0.8,
      margin: const EdgeInsetsDirectional.only(end: 4),
      child: Stack(children: [
        Material(
          child: InkWell(
            onTap: () {
              MixpanelBookingBloc.bloc(context).add(TherapistCardClickedEvent(
                therapistModel.id,
                therapistModel.name,
              ));
              // move to the therapist profile
              Navigator.of(context).pushNamed(TherapistProfileScreen.routeName,
                  arguments: {"therapistModel": therapistModel});
              log("Go to therapist profile");
            },
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            child: Container(
              height: 0.14 * height,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(16.0)),
                border: Border.all(color: ConstColors.disabled),
                color: Colors.white,
              ),
              child: Row(
                children: [
                  // the Therapist Photo Avatar
                  TherapistPhoto(
                      key: UniqueKey(),
                      imageUrl: therapistModel.image!.url!,
                      width: width),
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 0.04 * width,
                        vertical: 0.012 * height,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TherapistName(therapistName: therapistModel.name),
                          TherapistAvailability(
                            acceptNewClient: therapistModel.acceptNewClient,
                            firstAvailableSlotDate:
                                therapistModel.firstAvailableSlotDate,
                          ),
                          _getBookASessionButton(context),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        PlayVideoButton(
          videoUrl: therapistModel.biographyVideo?.url ?? "",
        )
      ]),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

//Get confirm booking button
  Widget _getBookASessionButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        MixpanelBookingBloc.bloc(context).add(TherapistCardClickedEvent(
          therapistModel.id,
          therapistModel.name,
        ));
        Navigator.of(context).pushNamed(TherapistProfileScreen.routeName,
            arguments: {"therapistModel": therapistModel});
      },
      style: ElevatedButton.styleFrom(
        visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity),
        padding: const EdgeInsets.symmetric(vertical: 6),
        fixedSize: Size(0.7 * width, 0.04 * height),
        onPrimary: ConstColors.app,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
      ),
      child: Text(
        translate(LangKeys.bookASession),
        style: const TextStyle(
          color: ConstColors.appWhite,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
