import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_sort_bloc/booking_screen_sort_bloc.dart';
import 'package:o7therapy/ui/screens/booking/widgets/booking_screen_icon.dart';
import 'package:o7therapy/ui/screens/booking/widgets/sort_widgets/booking_sort_modal_bottom_sheet.dart';

class SortIcon extends StatelessWidget {
  const SortIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      child: BookingScreenIcon(
        assetPath: AssPath.swapSortIcon,
        onTap: () {
          showModalBottomSheet(
            enableDrag: true,
            isDismissible: true,
            context: context,
            backgroundColor: Colors.white,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadiusDirectional.only(
                topEnd: Radius.circular(16),
                topStart: Radius.circular(16),
              ),
            ),
            builder: (context) => Container(
              color: Colors.transparent,
              padding: const EdgeInsetsDirectional.only(start: 24, end: 24),
              child: BookingSortModalBottomSheet(
                currentSortType:
                    context.read<BookingScreenSortBloc>().state.sortType,
              ),
            ),
          );
        },
      ),
    );
  }
}
