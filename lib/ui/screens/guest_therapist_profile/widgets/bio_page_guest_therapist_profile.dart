import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/api/models/therapist_bio/TherapistBio.dart';
import 'package:o7therapy/api/models/therapist_bio/TherapistTags.dart';

import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/bloc/therapist_bio_bloc/therapist_bio_bloc.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/mental_health_video.dart';
import 'package:o7therapy/ui/widgets/custom_error_widget.dart';
import 'package:o7therapy/ui/widgets/video_player/video_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';

class BioPageGuestTherapistProfile extends StatefulWidget {
  const BioPageGuestTherapistProfile({Key? key}) : super(key: key);

  @override
  State<BioPageGuestTherapistProfile> createState() =>
      _BioPageGuestTherapistProfileState();
}

class _BioPageGuestTherapistProfileState
    extends State<BioPageGuestTherapistProfile> with Translator {
  List<TherapistTags> selectedExperienceWorking = [];
  List<TherapistTags> selectedTherapyApproaches = [];
  List<TherapistTags> selectedIWorkWith = [];

  @override
  Widget build(BuildContext context) {
    initTranslator(context);

    return BlocBuilder<TherapistBioBloc, TherapistBioState>(
      builder: (context, TherapistBioState state) {
        if (state is TherapistBioLoadingState) {
          return const Center(
            child: SizedBox(
              height: 40,
              width: 40,
              child: CircularProgressIndicator(strokeWidth: 2.0),
            ),
          );
        } else if (state is TherapistBioErrorState) {
          return const CustomErrorWidget("");
        } else if (state is TherapistBioDataState) {
          TherapistBio bio = state.bio;
          return Container(
            color: ConstColors.appWhite,
            padding: const EdgeInsets.only(right: 17.0,left: 17.0,top: 14),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed(VideoScreen.routeName,
                          arguments: {
                            "videoUrl": bio.data!.biographyVideo!.url!
                          }).whenComplete(() {
                        exitFullScreen();
                        WidgetsFlutterBinding.ensureInitialized();
                        SystemChrome.setPreferredOrientations(
                            [DeviceOrientation.portraitUp]);
                      });
                    },
                    child: AbsorbPointer(
                        child: MentalHealthVideo(
                            videoUrl: bio.data!.biographyVideo!.url!)),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 24.0, bottom: 13,left: 2),
                    child: _headerWithIconWidget(
                        AssPath.lang, translate(LangKeys.speakingLang)),
                  ),
                  ListView.builder(
                      itemCount: bio.data!.languagesIds!.length,
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: _getLanguage(bio.data!.languagesIds![index]),
                          )),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0,bottom: 2.0,left: 2),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _headerWithIconWidget(
                            AssPath.workWith, translate(LangKeys.iWorkWith)),
                        // IconButton(
                        //   icon: SvgPicture.asset(
                        //     AssPath.infoIcon,
                        //     // scale: 2,
                        //   ),
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                  ),
                  ListView.builder(
                      itemCount: _getIWorkWith(bio).length,
                      padding: const EdgeInsets.only(bottom: 13),
                      primary: false,
                      shrinkWrap: true,
                      itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text(
                              _getIWorkWith(bio)[index].titleEn!,
                              style: const TextStyle(
                                  color: ConstColors.text,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400),
                            ),
                          )),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 13,left: 2),
                    child: _headerWithIconWidget(AssPath.experience,
                        translate(LangKeys.experienceWorking)),
                  ),
                  _workingExperienceChips(bio),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 13,left: 2),
                    child: _headerWithIconWidget(AssPath.categoriesIcon,
                        translate(LangKeys.therapyApproaches)),
                  ),
                  _therapyApproachesChips(bio),
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Text(
                      translate(LangKeys.moreAboutMe),
                      style: const TextStyle(
                          color: ConstColors.app,
                          fontWeight: FontWeight.w500,
                          fontSize: 16),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
                    child: Text.rich(
                      TextSpan(text: bio.data!.biographyText!),
                      style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: ConstColors.text),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  ///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _headerWithIconWidget(String iconPath, String text) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        children: [
          Transform.scale(
            scale: 1.1,
            child: SvgPicture.asset(
              iconPath,
              // scale: 2,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            text,
            style: const TextStyle(
                color: ConstColors.app,
                fontWeight: FontWeight.w500,
                fontSize: 16),
          ),
        ],
      ),
    );
  }

  Widget _getLanguage(int languageId) {
    switch (languageId) {
      case 1:
        return Text(
          translate(LangKeys.arabic),
          style: const TextStyle(
              color: ConstColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        );
      case 2:
        return Text(
          translate(LangKeys.english),
          style: const TextStyle(
              color: ConstColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        );
      case 3:
        return Text(
          translate(LangKeys.french),
          style: const TextStyle(
              color: ConstColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        );
      case 4:
        return Text(
          translate(LangKeys.german),
          style: const TextStyle(
              color: ConstColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w400),
        );
      default:
        return Container();
    }
  }

  Widget _workingExperienceChips(TherapistBio bio) {
    return Wrap(
      children: _getExperienceWorking(bio)
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    // if (selectedExperienceWorkingButtons.contains(item)) {
                    //   setState(() {
                    //     selectedExperienceWorkingButtons
                    //         .removeWhere((element) => element == item);
                    //   });
                    // } else {
                    //   setState(() {
                    //     selectedExperienceWorkingButtons.add(item);
                    //   });
                    // }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side:
                              const BorderSide(color: ConstColors.accentColor)),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(ConstColors.filterButton),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  child: Text(
                    item.titleEn!,
                    style: const TextStyle(
                        color: ConstColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ))
          .toList(),
    );
  }

  Widget _therapyApproachesChips(TherapistBio bio) {
    return Wrap(
      children: _getTherapyApproaches(bio)
          .map((item) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                child: ElevatedButton(
                  onPressed: () {
                    // if (selectedTherapyApproachesButtons.contains(item)) {
                    //   setState(() {
                    //     selectedTherapyApproachesButtons
                    //         .removeWhere((element) => element == item);
                    //   });
                    // } else {
                    //   setState(() {
                    //     selectedTherapyApproachesButtons.add(item);
                    //   });
                    // }
                  },
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          side:
                              const BorderSide(color: ConstColors.accentColor)),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all(ConstColors.filterButton),
                    elevation: MaterialStateProperty.all(0),
                  ),
                  child: Text(
                    item.titleEn!,
                    style: const TextStyle(
                        color: ConstColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                  ),
                ),
              ))
          .toList(),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Helper methods ///////////////////////
///////////////////////////////////////////////////////////

  List<TherapistTags> _getIWorkWith(TherapistBio bio) {
    selectedIWorkWith = [];
    for (var element in bio.data!.therapistTags!) {
      if (element.groupNameEn == 'Age Group') {
        selectedIWorkWith.add(element);
      }
    }
    return selectedIWorkWith;
  }

  List<TherapistTags> _getExperienceWorking(TherapistBio bio) {
    selectedExperienceWorking = [];
    for (var element in bio.data!.therapistTags!) {
      if (element.groupNameEn == 'Challenges/Difficulties') {
        selectedExperienceWorking.add(element);
      }
    }
    return selectedExperienceWorking;
  }

  List<TherapistTags> _getTherapyApproaches(TherapistBio bio) {
    selectedTherapyApproaches = [];
    for (var element in bio.data!.therapistTags!) {
      if (element.groupNameEn == 'Type Of Therapy') {
        selectedTherapyApproaches.add(element);
      }
    }
    return selectedTherapyApproaches;
  }
}
