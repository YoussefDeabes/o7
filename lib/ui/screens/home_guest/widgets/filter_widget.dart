import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';

class FilterWidget extends BaseStatelessWidget {
  final List<String> filterList;
  final Function() onPressed;

  FilterWidget({Key? key, required this.filterList, required this.onPressed})
      : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return SizedBox(
      height: height / 18,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: filterList.length,
        itemBuilder: (ctx, index) => Padding(
          padding:
              const EdgeInsets.only(top: 10.0, left: 4, right: 4, bottom: 2),
          child: ElevatedButton(
            onPressed: onPressed,
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                    side: const BorderSide(color: ConstColors.disabled)),
              ),
              backgroundColor:
                  MaterialStateProperty.all(ConstColors.filterButton),
              elevation: MaterialStateProperty.all(0),
            ),
            child: Text(
              filterList[index],
              style: const TextStyle(
                color: ConstColors.text,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
