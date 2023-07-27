import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/bloc/therapist_bio_bloc/therapist_bio_bloc.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/guest_therapist_profile_category_enum.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/bio_page_guest_therapist_profile.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/schedule_page_guest_therapist_profile.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/tab_bar_guest_therapist_profile.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/therapist_details_sliver/therapist_profile_details_sliver.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/therapist_profile_tab_bar_view.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class GuestTherapistProfileScreen extends BaseScreenWidget {
  static const routeName = '/guest-therapist-profile-screen';
  const GuestTherapistProfileScreen({Key? key})
      : super(
          key: key,
          backGroundColor: Colors.transparent,
        );

  @override
  BaseState<GuestTherapistProfileScreen> screenCreateState() =>
      _GuestTherapistProfileScreenState();
}

class _GuestTherapistProfileScreenState
    extends BaseScreenState<GuestTherapistProfileScreen>
    with TickerProviderStateMixin {
  late TherapistData therapistData;
  late final TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
      length: GuestTherapistProfileCategories.values.length,
      vsync: this,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  void didChangeDependencies() {
    final args = ModalRoute.of(context)!.settings.arguments
        as Map<String, TherapistData>;
    therapistData = args['therapistModel'] as TherapistData;

    TherapistBioBloc.bloc(context)
        .add(GetTherapistBioEvent(therapistData.id ?? ""));
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: DefaultTabController(
        length: GuestTherapistProfileCategories.values.length,
        child: Scaffold(
          appBar: AppBarForMoreScreens(
            title: translate(LangKeys.therapistProfile),
          ),
          body: NestedScrollView(
            floatHeaderSlivers: false,
            headerSliverBuilder: (
              BuildContext context,
              bool innerBoxIsScrolled,
            ) {
              return [
                SliverOverlapAbsorber(
                  handle:
                      NestedScrollView.sliverOverlapAbsorberHandleFor(context),
                  sliver: TherapistProfileDetailsSliver(
                    therapistData: therapistData,
                    innerBoxIsScrolled: innerBoxIsScrolled,
                  ),
                ),
                TabBarGuestTherapistProfile(
                  _tabController,
                  tabs: GuestTherapistProfileCategories.values.map<Widget>(
                    (profileCategory) {
                      return ProfileCategoryTab(
                        text: translate(
                          profileCategory.translatedKey,
                        ),
                      );
                    },
                  ).toList(),
                  translate: translate,
                ),
              ];
            },
            body: TherapistProfileTabBarView(
              _tabController,
              children: [
                const BioPageGuestTherapistProfile(),
                SchedulePageGuestTherapistProfile()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
