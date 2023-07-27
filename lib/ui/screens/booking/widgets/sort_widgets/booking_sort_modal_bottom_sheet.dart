import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_sort_bloc/booking_screen_sort_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_sort_bloc/sort_type.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class BookingSortModalBottomSheet extends StatelessWidget {
  const BookingSortModalBottomSheet({Key? key, required this.currentSortType})
      : super(key: key);
  final SortType currentSortType;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        _getBottomSheetTitle(context.translate(LangKeys.sortBy)),
        const SizedBox(height: 15),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Earliest Availability
            _getSectionTitle(context.translate(LangKeys.availability)),
            _getRadioListTile(
              title: context.translate(SortType.earliestAvailable.langKey!),
              sortType: SortType.earliestAvailable,
              context: context,
            ),
            const SizedBox(height: 15),
            // Price
            _getSectionTitle(context.translate(LangKeys.price)),
            _getRadioListTile(
              title: context.translate(SortType.priceHighToLow.langKey!),
              sortType: SortType.priceHighToLow,
              context: context,
            ),
            _getRadioListTile(
              title: context.translate(SortType.priceLowToHigh.langKey!),
              sortType: SortType.priceLowToHigh,
              context: context,
            ),
            const SizedBox(height: 15),
            // Experience
            _getSectionTitle(context.translate(LangKeys.experience)),
            _getRadioListTile(
              title: context
                  .translate(SortType.yearsOfExperienceAscending.langKey!),
              sortType: SortType.yearsOfExperienceAscending,
              context: context,
            ),
            _getRadioListTile(
              title: context
                  .translate(SortType.yearsOfExperienceDescending.langKey!),
              sortType: SortType.yearsOfExperienceDescending,
              context: context,
            ),
            const SizedBox(height: 15),
            // Top Rating
            // _getSectionTitle(context.translate(LangKeys.rating)),
            // _getRadioListTile(
            //   title: context.translate(SortType.topRating.langKey!),
            //   sortType: SortType.topRating,
            //   context: context,
            // ),
          ],
        ),
        const SizedBox(height: 25),
      ],
    );
  }

  /// get centered bottom sheet title
  Widget _getBottomSheetTitle(String title) {
    return Center(
      child: Text(
        title,
        style: const TextStyle(
          color: ConstColors.app,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  /// get filter section header
  Widget _getSectionTitle(String header) {
    return Text(
      header,
      textAlign: TextAlign.start,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: ConstColors.secondary,
      ),
    );
  }

  /// get _getRadioListTile
  Widget _getRadioListTile({
    required String title,
    required SortType sortType,
    required BuildContext context,
  }) {
    return ListTile(
      visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity),
      contentPadding: EdgeInsets.zero,
      title: Text(title),
      onTap: () {
        Navigator.pop(context);
        context
            .read<BookingScreenSortBloc>()
            .add(UpdateSortTypeEvent(sortType: sortType));
      },
      trailing: SvgPicture.asset(
        currentSortType == sortType
            ? AssPath.selectedRadioButton
            : AssPath.unselectedRadioButton,
      ),
    );
  }
}
