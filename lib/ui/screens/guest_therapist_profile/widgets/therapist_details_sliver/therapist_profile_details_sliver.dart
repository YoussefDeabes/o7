import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/therapist_details_sliver/therapist_details_sliver.dart';

class TherapistProfileDetailsSliver extends StatelessWidget {
  final TherapistData therapistData;
  final bool innerBoxIsScrolled;
  const TherapistProfileDetailsSliver({
    super.key,
    required this.therapistData,
    required this.innerBoxIsScrolled,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      floating: false,
      pinned: true,
      snap: false,
      collapsedHeight: 0,
      forceElevated: innerBoxIsScrolled,
      toolbarHeight: 0,
      automaticallyImplyLeading: false,
      backgroundColor: ConstColors.scaffoldBackground,
      expandedHeight: MediaQuery.of(context).size.height * 0.4,
      flexibleSpace: FlexibleSpaceBar(
        collapseMode: CollapseMode.none,
        background: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TherapistProfileImage(imageUrl: therapistData.image?.url ?? ""),
            Column(
              children: [
                TherapistProfileTitle(title: therapistData.name ?? ""),
                TherapistProfileProfessionDescription(
                    profession: therapistData.profession ?? ""),
              ],
            ),
            TherapistProfileExperienceRatingRow(
                yearsOfExperience: therapistData.yearsOfExperience ?? 0),
          ],
        ),
      ),
    );
  }
}
