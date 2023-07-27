import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';

enum FilterChoice {
  schedule,
  bio,
  services,
  reviews,
  videos,
  blogs,
}

class FilterWidget extends StatefulWidget {
  final List<String> filterList;
  final Function() onPressed;

  const FilterWidget(
      {Key? key, required this.filterList, required this.onPressed})
      : super(key: key);

  @override
  State<FilterWidget> createState() => _FilterWidgetState();
}

class _FilterWidgetState extends State<FilterWidget> {
  int selectedButton = -1;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shrinkWrap: true,
        primary: false,
        itemCount: widget.filterList.length,
        itemBuilder: (ctx, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ElevatedButton(
            onPressed: () {
              setState(() => selectedButton = index);
              widget.onPressed;
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(color: ConstColors.disabled)),
              ),
              backgroundColor: selectedButton == index
                  ? MaterialStateProperty.all(ConstColors.app)
                  : MaterialStateProperty.all(ConstColors.filterButton),
              elevation: MaterialStateProperty.all(0),
            ),
            child: Text(
              widget.filterList[index],
              style: TextStyle(
                color: selectedButton == index
                    ? ConstColors.appWhite
                    : ConstColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Get chosen filter
  FilterChoice _getChoice(int index) {
    switch (index) {
      case 0:
        return FilterChoice.schedule;
      case 1:
        return FilterChoice.bio;
      case 2:
        return FilterChoice.services;
      case 3:
        return FilterChoice.reviews;
      case 4:
        return FilterChoice.videos;
      case 5:
        return FilterChoice.blogs;
      default:
        return FilterChoice.schedule;
    }
  }
}
