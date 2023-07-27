import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/custom_sliver.dart';
import 'package:o7therapy/ui/screens/booking/widgets/search_text_field.dart';
import 'package:o7therapy/ui/screens/booking/widgets/sort_widgets/sort_icon.dart';

class SearchSectionRow extends BaseStatelessWidget {
  SearchSectionRow({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: CustomSliver(
          maxHeight: 0.06 * height,
          minHeight: 0.06 * height,
          child: Material(
            color: ConstColors.scaffoldBackground,
            child: Container(
              alignment: AlignmentDirectional.center,
              height: height,
              width: width,
              color: ConstColors.scaffoldBackground,
              padding: EdgeInsets.symmetric(vertical: 0.003 * height),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SearchTextField(enableEditingTextFiled: true,),
                  const SizedBox(width: 8),
                  SortIcon(),
                ],
              ),
            ),
          )),
    );
  }
}
