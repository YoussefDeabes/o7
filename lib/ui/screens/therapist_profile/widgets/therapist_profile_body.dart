import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/bio_page_guest_therapist_profile.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/tab_bar_guest_therapist_profile.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/therapist_details_sliver/therapist_profile_details_sliver.dart';
import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/therapist_profile_tab_bar_view.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_available_slots_cubit/therapist_available_slots_cubit.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/schedule_screen.dart';
import 'package:o7therapy/ui/screens/therapist_profile/widgets/profile_category.dart';
import 'package:o7therapy/ui/widgets/custom_error_widget.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/api/models/available_slots_datetime/Data.dart';

class TherapistProfileBody extends StatelessWidget {
  final TherapistData therapistData;
  final TabController tabController;
  final String Function(String) translate;

  const TherapistProfileBody({
    required this.tabController,
    super.key,
    required this.translate,
    required this.therapistData,
  });

  @override
  Widget build(BuildContext context) {
    return NestedScrollView(
      headerSliverBuilder: (
        BuildContext context,
        bool innerBoxIsScrolled,
      ) {
        return [
          TherapistProfileDetailsSliver(
            therapistData: therapistData,
            innerBoxIsScrolled: innerBoxIsScrolled,
          ),
          TabBarGuestTherapistProfile(
            tabController,
            translate: translate,
            tabs: ProfileCategories.values.map<Widget>(
              (profileCategory) {
                return ProfileCategoryTab(
                  text: translate(
                    profileCategory.translatedKey,
                  ),
                );
              },
            ).toList(),
          ),
        ];
      },
      body: TherapistProfileTabBarView(
        tabController,
        children: [
          Container(
            color: ConstColors.appWhite,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(child: BioPageGuestTherapistProfile()),
                Container(
                  height: 60,
                  width: MediaQuery.of(context).size.width * 0.75,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: ElevatedButton(
                    onPressed: () {
                      MixpanelBookingBloc.bloc(context).add(
                        BookASessionButtonInBioClickedEvent(
                          therapistData.id,
                          therapistData.name,
                        ),
                      );
                      tabController.animateTo(ProfileCategories.schedule.index);
                    },
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ))),
                    child: Text(translate(LangKeys.bookASession)),
                  ),
                )
              ],
            ),
          ),
          BlocBuilder<TherapistAvailableSlotsCubit,
                  TherapistAvailableSlotsState>(
              builder: (context, TherapistAvailableSlotsState state) {
            if (state is LoadingAvailableSlotsState) {
              return const Center(
                child: SizedBox(
                  height: 40,
                  width: 40,
                  child: CircularProgressIndicator(strokeWidth: 2.0),
                ),
              );
            } else if (state is ErrorAvailableSlotsState) {
              return const CustomErrorWidget("");
            } else if (state is TherapistAvailableSlotsDataState) {
              return ScheduleScreen(
                slots: state.availableSlots.data!.map((item) {
                  return Data(
                      id: item.id,
                      from: _getDate(item.from!),
                      to: _getDate(item.to!));
                }).toList(),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                therapistData: therapistData,
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  DateTime _getDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    String hour = date.substring(8, 10);
    String minute = date.substring(10, 12);
    String second = date.substring(12, 14);
    String formattedDate = "$year-$month-${day}T$hour:$minute:${second}Z";
    return DateTime.parse(formattedDate).toLocal();
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
// import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/bio_page_guest_therapist_profile.dart';
// import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/tab_bar_guest_therapist_profile.dart';
// import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/therapist_details_sliver/therapist_profile_details_sliver.dart';
// import 'package:o7therapy/ui/screens/guest_therapist_profile/widgets/therapist_profile_tab_bar_view.dart';
// import 'package:o7therapy/ui/screens/therapist_profile/therapist_available_slots_cubit/therapist_available_slots_cubit.dart';
// import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/schedule_screen.dart';
// import 'package:o7therapy/ui/screens/therapist_profile/widgets/profile_category.dart';
// import 'package:o7therapy/ui/widgets/custom_error_widget.dart';
// import 'package:o7therapy/ui/widgets/slivers/exception_sliver_widget.dart';
// import 'package:o7therapy/ui/widgets/slivers/shrink_sliver_widget.dart';
// import 'package:o7therapy/ui/widgets/slivers/sliver_circular_progress_indicator.dart';
// import 'package:o7therapy/util/lang/app_localization_keys.dart';
// import 'package:o7therapy/api/models/available_slots_datetime/Data.dart';

// class TherapistProfileBody extends StatelessWidget {
//   final TherapistData therapistData;
//   final TabController tabController;
//   final String Function(String) translate;

//   const TherapistProfileBody({
//     required this.tabController,
//     super.key,
//     required this.translate,
//     required this.therapistData,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return NestedScrollView(
//         physics: const BouncingScrollPhysics(parent: ScrollPhysics()),
//         headerSliverBuilder: (
//           BuildContext context,
//           bool innerBoxIsScrolled,
//         ) {
//           return [
//             TherapistProfileDetailsSliver(
//               therapistData: therapistData,
//               innerBoxIsScrolled: innerBoxIsScrolled,
//             ),
//             SliverOverlapAbsorber(
//               handle: NestedScrollView.sliverOverlapAbsorberHandleFor(context),
//               sliver: TabBarGuestTherapistProfile(
//                 tabController,
//                 translate: translate,
//                 tabs: ProfileCategories.values.map<Widget>(
//                   (profileCategory) {
//                     return ProfileCategoryTab(
//                       text: translate(
//                         profileCategory.translatedKey,
//                       ),
//                     );
//                   },
//                 ).toList(),
//               ),
//             ),
//           ];
//         },
//         body: TherapistProfileTabBarView(
//           tabController,
//           children:   <Widget>[
//             BlocBuilder<TherapistAvailableSlotsCubit,
//                 TherapistAvailableSlotsState>(builder: (
//               BuildContext context,
//               TherapistAvailableSlotsState state,
//             ) {
//               if (state is LoadingAvailableSlotsState) {
//                 return const SliverCircularProgressIndicator();
//               } else if (state is ErrorAvailableSlotsState) {
//                 return const ExceptionSliverWidget(exception: "");
//               } else if (state is TherapistAvailableSlotsDataState) {
//                 return SliverToBoxAdapter(
//                   child: ScheduleScreen(
//                     slots: state.availableSlots.data!.map((item) {
//                       return Data(
//                           id: item.id,
//                           from: _getDate(item.from!),
//                           to: _getDate(item.to!));
//                     }).toList(),
//                     height: MediaQuery.of(context).size.height,
//                     width: MediaQuery.of(context).size.width,
//                     therapistData: therapistData,
//                   ),
//                 );
//               }
//               return const ShrinkSliverWidget();
//             }),
//             SliverToBoxAdapter(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const Expanded(child: BioPageGuestTherapistProfile()),
//                   Container(
//                     height: 60,
//                     width: MediaQuery.of(context).size.width * 0.75,
//                     padding: const EdgeInsets.symmetric(vertical: 8),
//                     child: ElevatedButton(
//                       onPressed: () {
//                         tabController.animateTo(0);
//                       },
//                       style: ButtonStyle(
//                           shape:
//                               MaterialStateProperty.all<RoundedRectangleBorder>(
//                                   RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(30.0),
//                       ))),
//                       child: Text(translate(LangKeys.bookASession)),
//                     ),
//                   )
//                 ],
//               ),
//             ),
//           ].map((Widget sliverWidget) {
//             return Builder(
//               // This Builder is needed to provide a BuildContext that is
//               // "inside" the NestedScrollView, so that
//               // sliverOverlapAbsorberHandleFor() can find the
//               // NestedScrollView.
//               builder: (BuildContext context) {
//                 return CustomScrollView(
//                   // The "controller" and "primary" members should be left
//                   // unset, so that the NestedScrollView can control this
//                   // inner scroll view.
//                   // If the "controller" property is set, then this scroll
//                   // view will not be associated with the NestedScrollView.
//                   // The PageStorageKey should be unique to this ScrollView;
//                   // it allows the list to remember its scroll position when
//                   // the tab view is not on the screen.
//                   key: PageStorageKey<Widget>(sliverWidget),
//                   slivers: <Widget>[
//                     SliverOverlapInjector(
//                       // This is the flip side of the SliverOverlapAbsorber
//                       // above.
//                       handle: NestedScrollView.sliverOverlapAbsorberHandleFor(
//                         context,
//                       ),
//                     ),
//                     sliverWidget,
//                   ],
//                 );
//               },
//             );
//           }).toList(),
//         ));
//   }

//   DateTime _getDate(String date) {
//     String year = date.substring(0, 4);
//     String month = date.substring(4, 6);
//     String day = date.substring(6, 8);
//     String hour = date.substring(8, 10);
//     String minute = date.substring(10, 12);
//     String second = date.substring(12, 14);
//     String formattedDate = "$year-$month-${day}T$hour:$minute:${second}Z";
//     return DateTime.parse(formattedDate).toLocal();
//   }
// }
