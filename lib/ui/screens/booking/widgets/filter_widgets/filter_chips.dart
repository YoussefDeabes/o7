import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/booking_screen_filter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_models.dart';
import 'package:o7therapy/ui/widgets/slivers/shrink_sliver_widget.dart';
import 'package:o7therapy/ui/screens/booking/widgets/sliver_app_bar_delegate.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class FilterChips extends BaseStatelessWidget {
  FilterChips({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return BlocBuilder<BookingScreenFilterBloc, BookingScreenFilterState>(
      builder: (context, state) {
        if (state.isThereIsAnyFilterApplied) {
          return _getFilterChips(state.filterItems);
        } else {
          return const ShrinkSliverWidget();
        }
      },
    );
  }

  /// get the services Categories bar
  Widget _getFilterChips(Set<FilterItem<dynamic>> filterItems) {
    return SliverPersistentHeader(
      pinned: true,
      floating: false,
      delegate: SliverAppBarDelegate(
        maxHeight: 0.04 * height,
        minHeight: 0.04 * height,
        child: Material(
          color: ConstColors.scaffoldBackground,
          child: Container(
            color: ConstColors.scaffoldBackground,
            alignment: Alignment.center,
            height: height,
            width: width,
            padding: EdgeInsets.symmetric(vertical: 0.001 * height),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  translate(LangKeys.filterBy),
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    color: ConstColors.app,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.zero,
                    children: filterItems.map<Widget>((filterItem) {
                      if (filterItem.isApplied) {
                        /// no value : then show the title only
                        return _getFilterChip(
                          chipTitle: filterItem.chipTitle,
                          filter: filterItem.filter,
                        );
                      }
                      return const SizedBox();
                    }).toList(),
                  ),
                ),
                const SizedBox(width: 8),
                _getClearFilterTextButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// get the filter chips
  Widget _getFilterChip({required Filter filter, required String chipTitle}) {
    return Center(
      child: Builder(builder: (context) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: width * 0.01, vertical: 0),
          child: Chip(
            deleteIcon: const Icon(
              Icons.clear_rounded,
              color: ConstColors.text,
              size: 15.0,
            ),
            deleteIconColor: ConstColors.text,
            onDeleted: () => context
                .read<BookingScreenFilterBloc>()
                .add(RemoveSingleFilterEvent(filter: filter)),
            padding: EdgeInsets.zero,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
            backgroundColor: Colors.transparent,
            labelPadding: EdgeInsets.zero,
            label: Text(
              filter == Filter.priceRange ? chipTitle : translate(chipTitle),
              style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w400,
                color: ConstColors.text,
              ),
            ),
          ),
        );
      }),
    );
  }

  /// get Clear Text Button for the filter to clear it
  Widget _getClearFilterTextButton() {
    return Builder(builder: (context) {
      return Material(
        child: InkWell(
          onTap: () {
            // clear all filters
            context.read<BookingScreenFilterBloc>().add(ResetFiltersEvent());
            log("cleared all the filters");
          },
          child: Ink(
            padding: const EdgeInsets.all(3),
            child: Text(
              translate(LangKeys.clear),
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                decoration: TextDecoration.underline,
                color: ConstColors.secondary,
              ),
            ),
          ),
        ),
      );
    });
  }
}
