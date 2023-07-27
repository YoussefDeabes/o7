import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/bloc/get_matched_pressed_bloc/get_matched_button_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/booking_screen_filter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_sort_bloc/booking_screen_sort_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_sort_bloc/sort_type.dart';
import 'package:o7therapy/ui/screens/booking/bloc/search_bloc/search_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/services_screen_get_matched_card.dart';
import 'package:o7therapy/ui/widgets/slivers/shrink_sliver_widget.dart';
import 'package:o7therapy/ui/screens/booking/widgets/sliver_app_bar_delegate.dart';
import 'package:o7therapy/ui/screens/booking/widgets/therapist_booked_before_widgets/therapist_booked_before_card.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class TherapistsBookedBeforeSection extends StatelessWidget {
  const TherapistsBookedBeforeSection(
    this.isTherapistsBookedBeforeDismissed, {
    super.key,
  });
  final ValueNotifier<bool> isTherapistsBookedBeforeDismissed;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: isTherapistsBookedBeforeDismissed,
      builder: (context, isDismissed, child) {
        log("value is $isDismissed");
        if (isDismissed) {
          return const ShrinkSliverWidget();
        }
        TherapistsState therapistsListState =
            context.watch<TherapistsBloc>().state;
        SearchState searchTherapistState = context.watch<SearchBloc>().state;
        TherapistsBookedBeforeState therapistsBookedBeforeState =
            context.watch<TherapistsBookedBeforeBloc>().state;
        BookingScreenFilterState bookingScreenFilterState =
            context.watch<BookingScreenFilterBloc>().state;
        BookingScreenSortState bookingScreenSortState =
            context.watch<BookingScreenSortBloc>().state;

        /// don't show this vertical section if there are no therapist list
        if (therapistsListState is! LoadedTherapistsState) {
          return const ShrinkSliverWidget();
        }

        /// don't show vertical section when user search on something >>
        /// if there search input
        if (searchTherapistState.searchQuery.isNotEmpty) {
          return const ShrinkSliverWidget();
        }

        /// don't show vertical section when user apply filter
        if (bookingScreenFilterState.isThereIsAnyFilterApplied) {
          return const ShrinkSliverWidget();
        }

        /// don't show vertical section when user apply sort != earliestAvailable
        if (bookingScreenSortState.sortType != SortType.earliestAvailable) {
          return const ShrinkSliverWidget();
        }

        if (therapistsBookedBeforeState is LoadedTherapistsBookedBeforeState) {
          if (therapistsBookedBeforeState.therapists.isEmpty) {
            GetMatchedButtonState getMatchedButtonState =
                context.watch<GetMatchedButtonBloc>().state;
            if (getMatchedButtonState is HideGetMatchedCard) {
              return const ShrinkSliverWidget();
            }
            return const ServicesScreenGetMatchedCard();
          }
          return SliverPersistentHeader(
            pinned: false,
            floating: false,
            delegate: SliverAppBarDelegate(
              maxHeight: 0.235 * context.height,
              minHeight: 0.235 * context.height,
              child: Container(
                height: 0.25 * context.height,
                color: ConstColors.scaffoldBackground,
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TherapistsBookedBeforeTextWidget(),
                        DismissBookedBeforeButton(
                          isTherapistsBookedBeforeDismissed:
                              isTherapistsBookedBeforeDismissed,
                        ),
                      ],
                    ),
                    Expanded(
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        shrinkWrap: true,
                        primary: false,
                        addRepaintBoundaries: false,
                        addSemanticIndexes: false,
                        itemCount:
                            therapistsBookedBeforeState.therapists.length,
                        itemBuilder: (context, index) {
                          return TherapistBookedBeforeCard(
                            therapistModel:
                                therapistsBookedBeforeState.therapists[index],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
        return const ShrinkSliverWidget();
      },
    );
  }
}

class TherapistsBookedBeforeTextWidget extends StatelessWidget {
  const TherapistsBookedBeforeTextWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      context.translate(LangKeys.therapistsBookedBefore),
      style: const TextStyle(
        color: ConstColors.app,
        fontSize: 16,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class DismissBookedBeforeButton extends StatelessWidget {
  const DismissBookedBeforeButton({
    super.key,
    required this.isTherapistsBookedBeforeDismissed,
  });

  final ValueNotifier<bool> isTherapistsBookedBeforeDismissed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        isTherapistsBookedBeforeDismissed.value = true;
      },
      child: Text(
        context.translate(LangKeys.dismiss),
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: ConstColors.secondary,
            decoration: TextDecoration.underline),
      ),
    );
  }
}
