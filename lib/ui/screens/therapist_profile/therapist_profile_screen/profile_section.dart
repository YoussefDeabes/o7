import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_bloc.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/profile_category.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/profile_category_chip.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/sliver_appbar_title.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:shimmer/shimmer.dart';

class ProfileSection extends StatefulWidget {
  final TherapistData profile;
  final Widget screenSelected;
  final double height;
  final double width;
  final TherapistProfileState state;

  const ProfileSection(
      {Key? key,
      required this.profile,
      required this.height,
      required this.width,
      required this.screenSelected,
      required this.state})
      : super(key: key);

  @override
  State<ProfileSection> createState() => _ProfileSectionState();
}

class _ProfileSectionState extends State<ProfileSection> with Translator {
  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
          // pinned: true,
          snap: false,
          floating: false,
          primary: false,
          backgroundColor: ConstColors.appWhite,
          foregroundColor: ConstColors.app,
          // title: SliverAppBarTitle(child: _profileTitle(widget.profile.name ?? "")),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                  topLeft: Radius.zero,
                  topRight: Radius.zero),
              side: BorderSide(color: ConstColors.disabled)),
          expandedHeight: widget.height / 2,
          flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.parallax,
              background: _headerColumn(widget.profile))),
      SliverToBoxAdapter(
          child: Column(
        children: [
          _getFilterChips(),
          widget.screenSelected,
        ],
      ))
    ]);
  }

  //Getting the sliver appbar header content
  Widget _headerColumn(TherapistData profile) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _therapistProfileImage(profile),
        Column(
          children: [
            _profileTitle(profile.name!),
            _therapistProfessionalDescription(profile),
          ],
        ),
        _pricingRow(profile),
        _experienceRatingRow(profile),
      ],
    );
  }

  //Get filter chips
  Widget _getFilterChips() {
    return Container(
      color: ConstColors.scaffoldBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 0.004 * widget.height),
          SizedBox(
            width: widget.width,
            height: 0.06 * widget.height,
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              scrollDirection: Axis.horizontal,
              children: ProfileCategories.values
                  .map<Widget>((profileCategory) =>
                      _getProfileCategoryChip(profileCategory))
                  .toList(),
            ),
          ),
          SizedBox(height: 0.004 * widget.height),
        ],
      ),
    );
  }

  //Get therapist profile image
  Widget _therapistProfileImage(TherapistData profile) {
    return ClipRRect(
        borderRadius: const BorderRadius.all(
          Radius.circular(16),
        ),
        child: SizedBox(
            width: 140,
            child: CachedNetworkImage(
              imageUrl: ApiKeys.baseUrl + profile.image!.url!,
              fit: BoxFit.fitHeight,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.white,
                child: Container(
                  // height: double.infinity,
                  width: 0.27 * widget.width,
                  decoration: const BoxDecoration(color: Colors.black26),
                ),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(child: Icon(Icons.error))),
            )));
  }

  //Get profile title
  Widget _profileTitle(String title) {
    return Text(title,
        style: const TextStyle(
            fontSize: 18, fontWeight: FontWeight.w700, color: ConstColors.app));
  }

  //Get professional career description
  Widget _therapistProfessionalDescription(TherapistData profile) {
    return SizedBox(
        width: widget.width / 1.5,
        child: Text(profile.profession!,
            style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w400,
                color: ConstColors.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 2));
  }

  //Getting pricing row
  Widget _pricingRow(TherapistData profile) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Text(getStatusString(profile),
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ConstColors.app)),
      Text(_getFiftyMinText(),
          style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: ConstColors.accentColor),
          textAlign: TextAlign.center,
          maxLines: 2)
    ]);
  }

  String _getFiftyMinText() {
    if (AppLocalizations.of(context).locale.languageCode == "ar") {
      return '${translate(LangKeys.fifty)} ${translate(LangKeys.minute)}';
    } else {
      return '${translate(LangKeys.fifty)} ${translate(LangKeys.minutes)}';
    }
  }

  String getStatusString(TherapistData profile) {
    if (profile.flatRate == null || profile.flatRate == false) {
      return '${profile.feesPerSession!.floor()}${translateCurrency(profile.currency)}/';
    } else {
      return '${translate(LangKeys.coveredByEWP)}/';
    }
  }

  ///chips for Profile Categories
  Widget _getProfileCategoryChip(ProfileCategories profileCategory) {
    return ProfileCategoryChip(
      width: widget.width,
      profileCategory: profileCategory,
      therapistId: widget.profile.id!,
    );
  }

  Widget _experienceRatingRow(TherapistData profile) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      _experienceRatingColumn(AssPath.caseIcon, translate(LangKeys.experience),
          profile.yearsOfExperience!.toString(), translate(LangKeys.years)),
      // _experienceRatingColumn(AssPath.starIcon, translate(LangKeys.rating),
      //     '4.0', '20 ${translate(LangKeys.review)}')
    ]);
  }

  Widget _experienceRatingColumn(
      String assetPath, String title, String rate, String description) {
    return Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Padding(
          padding: const EdgeInsets.only(bottom: 3.0),
          child: SvgPicture.asset(
            assetPath,
            // scale: 1.8,
          )),
      Text(title,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: ConstColors.text)),
      Text(rate,
          style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: ConstColors.app)),
      Text(description,
          style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w400,
              color: ConstColors.textSecondary))
    ]);
  }
}
