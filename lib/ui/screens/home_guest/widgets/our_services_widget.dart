import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking_guest/booking_guest_screen/booking_guest_screen.dart';
import 'package:o7therapy/ui/screens/booking_guest/cubit/selected_tab_cubit.dart';
import 'package:o7therapy/ui/screens/home/home_main/home_main_screen.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

const List<String> servicesTitle = [
  LangKeys.oneOnOneSessions,
  LangKeys.couplesTherapy,
  LangKeys.assessmentsAndTesting,
  LangKeys.workshopsAndWebinars,
  LangKeys.groupTherapy,
  LangKeys.programs
];
const List<String> servicesIcons = [
  AssPath.oneOnOne,
  AssPath.coupleTherapy,
  AssPath.assessmentAndTesting,
  AssPath.workshopsAndWebinar,
  AssPath.groupTherapy,
  AssPath.programs
];

const List<SelectedTab> selectedTabs = [
  SelectedTab.oneOnOne,
  SelectedTab.couplesTherapy,
  SelectedTab.assessmentAndTesting,
  SelectedTab.workshops,
  SelectedTab.groupTherapy,
  SelectedTab.programs,
];

class OurServicesWidget extends StatelessWidget {
  const OurServicesWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      staggeredTileBuilder: (index) => const StaggeredTile.fit(1),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      itemCount: servicesTitle.length,
      primary: false,
      shrinkWrap: true,
      itemBuilder: (ctx, index) => InkWell(
        onTap: () {
          Navigator.of(context)
              .pushReplacementNamed(HomeMainScreen.routeName, arguments: 2);
          SelectedTabCubit.bloc(context).changeTab(selectedTabs[index]);
        },
        child: SizedBox(
          height: MediaQuery.of(context).size.height / 6,
          child: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                side: BorderSide(color: ConstColors.disabled)),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircleAvatar(
                  backgroundColor: ConstColors.appWhite,
                  radius: 30,
                  child: SvgPicture.asset(
                    servicesIcons[index],
                    fit: BoxFit.fitWidth,
                  ),
                ),
                Text(
                  context.translate(servicesTitle[index]),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: ConstColors.app),
                  textAlign: TextAlign.center,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
