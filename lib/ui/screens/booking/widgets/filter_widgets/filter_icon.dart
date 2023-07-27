import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/booking_filter_modal_bottom_sheet.dart';
import 'package:o7therapy/ui/screens/booking/widgets/booking_screen_icon.dart';
import 'package:o7therapy/util/extensions/extensions.dart';

class FilterIcon extends StatelessWidget {
  const FilterIcon({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.center,
      width: 32,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 4),
      child: BookingScreenIcon(
        assetPath: AssPath.filterIcon,
        onTap: () {
          showModalBottomSheet(
            isScrollControlled: true,
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
              height: context.height - 65,
              padding: const EdgeInsetsDirectional.only(start: 24, end: 24),
              child: const BookingFilterModalBottomSheet(),
            ),
          );
        },
      ),
    );
  }
}
