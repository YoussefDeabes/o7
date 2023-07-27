import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/therapist_profile_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:shimmer/shimmer.dart';

class TherapistCardHorizontal extends BaseStatelessWidget {
  final TherapistModel therapistModel;

  TherapistCardHorizontal({Key? key, required this.therapistModel})
      : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Stack(children: [
      InkWell(
        onTap: () {
          // TODO : move to the therapist profile
          Navigator.of(context).pushNamed(TherapistProfileScreen.routeName);
          log("Go to therapist profile");
        },
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Ink(
          height: 0.17 * height,
          color: ConstColors.scaffoldBackground,
          padding: const EdgeInsets.all(0),
          // decoration: BoxDecoration(
          //   borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          //   border: Border.all(color: ConstColors.disabled),
          //   color: ConstColors.scaffoldBackground,
          // ),
          child: Card(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0)),
              side: BorderSide(color: ConstColors.disabled),
            ),
            child: Row(
              children: [
                // the Therapist Photo Avatar
                _getTherapistPhoto(context),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.04 * width,
                      vertical: 0.015 * height,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _getTherapistNameAndRank(),
                        _getTherapistJobTitle(),
                        _getTherapistYearsOfExperienceAndLanguagesTalk(),
                        _getTherapistSkills(),
                        _getTherapistAvailability(),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
      _getPlayIconImage()
    ]);
  }

  ///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  /// get the therapist personal photo and cached it in the network
  Widget _getTherapistPhoto(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: Directionality.of(context) == TextDirection.ltr
            ? const Radius.circular(16.0)
            : const Radius.circular(34.0),
        bottomRight: Directionality.of(context) == TextDirection.rtl
            ? const Radius.circular(16.0)
            : const Radius.circular(34.0),
        topLeft: const Radius.circular(16.0),
        topRight: const Radius.circular(16.0),
      ),
      child: CachedNetworkImage(
        width: 0.27 * width,
        height: double.infinity,
        imageUrl: therapistModel.avatarLink,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white,
          child: Container(
            height: double.infinity,
            width: 0.27 * width,
            decoration: const BoxDecoration(color: Colors.black26),
          ),
        ),
        errorWidget: (context, url, error) => const SizedBox(
            width: 30, height: 30, child: Center(child: Icon(Icons.error))),

        //errorWidget: (context, url, error) => Image.asset('assets/images/notAvailable.jpg', fit: BoxFit.fill),
        fadeOutDuration: const Duration(milliseconds: 1500),
        fadeInDuration: const Duration(milliseconds: 1000),
      ),
    );
  }

  /// get the play icon image that will play the intro video of the therapist
  Widget _getPlayIconImage() {
    return Align(
      alignment: AlignmentDirectional.bottomStart,
      child: ClipOval(
        child: Material(
          shadowColor: Colors.black54,
          child: InkWell(
            onTap: () {
              // TODO Play the video of the therapist
              log("Play the video of the therapist");
            },
            child: Ink(
              width: height > width ? 0.155 * width : 0.155 * height,
              height: height > width ? 0.155 * width : 0.155 * height,
              // decoration: const ShapeDecoration(
              //   color: Colors.transparent,
              //   shape: CircleBorder(),
              //   // image: DecorationImage(
              //   //   fit: BoxFit.cover,
              //   //   // image:   Svg // SvgPicture.asset(AssPath.playCircle),
              //   // ),
              // ),
              child: SvgPicture.asset(AssPath.playCircle, fit: BoxFit.cover),
            ),
          ),
        ),
      ),
    );
  }

  /// getting row that contains the name and the rank of the therapist
  Widget _getTherapistNameAndRank() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [_getTherapistName(), _getTherapistRank()],
    );
  }

  /// get the therapist job title
  Widget _getTherapistJobTitle() {
    return Row(
      children: [
        _getSvgIcon(AssPath.therapistCard),
        // Image.asset(AssPath.jobTitleCardIcon, scale: 0.13 * width), // 50
        SizedBox(width: 0.016 * width),
        Text(
          therapistModel.jobTitle,
          style: const TextStyle(
              color: ConstColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  /// get the row that contains
  /// 1. the years of experience
  /// 2. and the language that the therapist can speak
  Widget _getTherapistYearsOfExperienceAndLanguagesTalk() {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
      // Years Of Experience
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _getSvgIcon(AssPath.caseIcon),
          // SvgPicture.asset(AssPath.caseIcon),
          // Image.asset(AssPath.caseIcon, width: 0.04 * width),
          SizedBox(width: 0.016 * width),
          RichText(
              text: TextSpan(
            style: const TextStyle(
                fontSize: 12.0,
                color: ConstColors.textSecondary,
                fontWeight: FontWeight.w400),
            children: [
              TextSpan(
                  text: '${therapistModel.yearsOfExperience} ',
                  style: const TextStyle(fontWeight: FontWeight.w500)),
              TextSpan(
                  text: translate(LangKeys.yr),
                  style: const TextStyle(fontWeight: FontWeight.w400)),
              const TextSpan(text: '.'),
            ],
          )),
        ],
      ),
      // Therapist Spoken Languages
      SizedBox(
        width: 0.2 * width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            _getSvgIcon(AssPath.speakIcon),
            // Image.asset(AssPath.languageTherapistCanSpeakIcon,
            //     width: 0.04 * width),
            SizedBox(width: 0.016 * width),
            SizedBox(
              width: 0.14 * width,
              child: Text(
                _getTherapistSpokenLanguagesString(),
                overflow: TextOverflow.ellipsis,
                softWrap: false,
                style: const TextStyle(
                    fontSize: 12.0,
                    color: ConstColors.textSecondary,
                    fontWeight: FontWeight.w400),
              ),
            ),
          ],
        ),
      ),
    ]);
  }

  /// get the therapist skills Icon and skills String
  Widget _getTherapistSkills() {
    return Row(
      children: [
        _getSvgIcon(AssPath.tagIcon),
        SizedBox(width: 0.016 * width),
        SizedBox(
          width: 0.4 * width,
          child: Text(
            _getTherapistSkillsString(),
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
                fontSize: 11.0,
                color: ConstColors.textSecondary,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  /// get the therapist availability Icon his status
  Widget _getTherapistAvailability() {
    return Row(
      children: [
        _getSvgIcon(AssPath.calendarIcon),
        // Image.asset(AssPath.activityIcon, scale: 0.013 * width),
        SizedBox(width: 0.016 * width),
        Expanded(
          child: Text(
            therapistModel.availability,
            overflow: TextOverflow.ellipsis,
            softWrap: true,
            maxLines: 1,
            style: const TextStyle(
                fontSize: 10.0,
                color: ConstColors.textSecondary,
                fontWeight: FontWeight.w400),
          ),
        ),
      ],
    );
  }

  /// get the therapist TextWidget
  Widget _getTherapistName() {
    return Expanded(
      child: Text(
        therapistModel.name,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: ConstColors.app),
      ),
    );
  }

  /// get the therapist rank icon and his rank
  Widget _getTherapistRank() {
    return Row(
      children: [
        _getSvgIcon(AssPath.starIcon),
        // SvgPicture.asset(AssPath.starIcon, width: 0.04 * width),
        // Image.asset(AssPath.starIcon, width: 0.04 * width),
        SizedBox(width: 0.01 * width),
        Text(
          therapistModel.rank.toStringAsFixed(1),
          style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
        ),
      ],
    );
  }

  /// get Svg Icon
  Widget _getSvgIcon(String assetPath) {
    return SvgPicture.asset(
      assetPath,
      width: height > width ? 0.04 * width : 0.04 * height,
      // allowDrawingOutsideViewBox: true,
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  /// get the Therapist Spoken Languages String from list
  String _getTherapistSpokenLanguagesString() {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < therapistModel.languages.length; i++) {
      if (i != therapistModel.languages.length - 1) {
        buffer.write("${therapistModel.languages[i]}, ");
      } else {
        buffer.write(therapistModel.languages[i]);
      }
    }
    return buffer.toString();
  }

  /// get the Therapist Skills String from list
  String _getTherapistSkillsString() {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < therapistModel.skills.length; i++) {
      if (i != therapistModel.skills.length - 1) {
        buffer.write("${therapistModel.skills[i]}, ");
      } else {
        buffer.write(therapistModel.skills[i]);
      }
    }
    return buffer.toString();
  }
}
