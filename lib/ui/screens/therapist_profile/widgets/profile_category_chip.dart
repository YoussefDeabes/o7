import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_bloc.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/profile_category.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ProfileCategoryChip extends StatefulWidget {
  final double width;
  final ProfileCategories profileCategory;
  final String therapistId;

  const ProfileCategoryChip(
      {Key? key,
      required this.width,
      required this.profileCategory,
      required this.therapistId})
      : super(key: key);

  @override
  State<ProfileCategoryChip> createState() => _ProfileCategoryChipState();
}

class _ProfileCategoryChipState extends State<ProfileCategoryChip>
    with Translator {
  Color chipColor = Colors.white;
  Color textColor = ConstColors.text;

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: widget.width * 0.01),
      child: GestureDetector(
        onTap: () {
          // context
          //     .read<TherapistProfileBloc>()
          //     .add(_getEvent(widget.profileCategory.translatedKey));
        },
        child: BlocBuilder<TherapistProfileBloc, TherapistProfileState>(
            builder: (context, state) {
          // if (state is ProfileCategoryState) {
          //   if (state.profileCategory == widget.profileCategory) {
          //     chipColor = ConstColors.app;
          //     textColor = Colors.white;
          //   } else {
          //     chipColor = Colors.white;
          //     textColor = ConstColors.text;
          //   }
          // }
          return Chip(
            backgroundColor: chipColor,
            side: const BorderSide(color: ConstColors.disabled),
            labelPadding:
                EdgeInsets.symmetric(horizontal: 0.026 * widget.width),
            label: Text(
              translate(widget.profileCategory.translatedKey),
              style: TextStyle(
                fontSize: 14.0,
                fontWeight: FontWeight.w400,
                color: textColor,
              ),
            ),
          );
        }),
      ),
    );
  }

  // TherapistProfileEvent _getEvent(String key) {
  //   switch (key) {
  //     case LangKeys.schedule:
  //       return ScheduleSelected(widget.therapistId);
  //     case LangKeys.bio:
  //       return BioSelected(widget.therapistId);
  //     case LangKeys.services:
  //       return const ServicesSelected();
  //     case LangKeys.reviews:
  //       return const ReviewsSelected();
  //     case LangKeys.videos:
  //       return const VideosSelected();
  //     case LangKeys.blogs:
  //       return const BlogsSelected();
  //     default:
  //       return ScheduleSelected(widget.therapistId);
  //   }
  // }
}
