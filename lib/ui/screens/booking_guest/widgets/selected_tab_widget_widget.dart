import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking_guest/booking_guest_screen/booking_guest_screen.dart';
import 'package:o7therapy/util/extensions/media_query_values.dart';

class SelectedTabWidget extends StatefulWidget {
  final SelectedTab selectedTab;

  const SelectedTabWidget({
    Key? key,
    required this.selectedTab,
  }) : super(key: key);

  @override
  State<SelectedTabWidget> createState() => _SelectedTabWidgetState();
}

class _SelectedTabWidgetState extends State<SelectedTabWidget> {
  @override
  Widget build(BuildContext context) {
    return Tab(
      child: Container(
        padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            border: Border.all(
              color: ConstColors.disabled,
            )),
        child: Align(
          alignment: Alignment.center,
          child: Text(context.translate(widget.selectedTab.tabLabel)),
        ),
      ),
    );
  }
}
