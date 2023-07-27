import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/custom_sliver.dart';
import 'package:o7therapy/ui/screens/booking/widgets/search_text_field.dart';
import 'package:o7therapy/ui/screens/booking/widgets/sort_widgets/sort_icon.dart';
import 'package:o7therapy/util/extensions/extensions.dart';

class SearchButton extends StatelessWidget {
  const SearchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverPersistentHeader(
      pinned: false,
      floating: true,
      delegate: CustomSliver(
        child: Material(
          color: ConstColors.scaffoldBackground,
          child: InkWell(
            onTap: () {
              // Navigator.pushNamed(context, SearchResultsScreen.routeName).then((value) =>
              //     TherapistsBloc.bloc(context).add(const GetInitQueryTherapistEvent()));
            },
            child: Container(
              alignment: AlignmentDirectional.center,
              color: ConstColors.scaffoldBackground,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SearchTextField(enableEditingTextFiled: true),
                  const SizedBox(width: 8),
                  const SortIcon(),
                ],
              ),
            ),
          ),
        ),
        maxHeight: 0.06 * context.height,
        minHeight: 0.06 * context.height,
      ),
    );
  }
}
