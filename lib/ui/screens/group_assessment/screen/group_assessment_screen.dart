import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/group_assessment_payment_page.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/group_assessment_details_page.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/group_assessment_select_date_and_time_page.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

enum GroupAssessmentPages {
  groupAssessmentSelectDateAndTimePage,
  groupAssessmentDetailsPage,
  groupAssessmentPaymentPage,
}

class GroupAssessmentScreen extends BaseStatelessWidget {
  static const routeName = '/group-assessment-screen';
  late final GroupAssessmentPages groupAssessmentPage;
  GroupAssessmentScreen({super.key});

  @override
  Widget baseBuild(BuildContext context) {
    groupAssessmentPage = (ModalRoute.of(context)?.settings.arguments ??
            GroupAssessmentPages.groupAssessmentSelectDateAndTimePage)
        as GroupAssessmentPages;

    return SafeArea(
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBarForMoreScreens(
            title: translate(LangKeys.groupAssessment),
          ),
          body: _getBody(),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return SingleChildScrollView(
      child: Column(
        children: [_stepsSlide(), _getGroupAssessmentPage()],
      ),
    );
  }

  Widget _getGroupAssessmentPage() {
    switch (groupAssessmentPage) {
      case GroupAssessmentPages.groupAssessmentSelectDateAndTimePage:
        return GroupAssessmentSelectDateAndTimePage();
      case GroupAssessmentPages.groupAssessmentDetailsPage:
        return const GroupAssessmentDetailsPage();
      case GroupAssessmentPages.groupAssessmentPaymentPage:
        return const GroupAssessmentPaymentPage();
      default:
        return GroupAssessmentSelectDateAndTimePage();
    }
  }

  Widget _stepsSlide() {
    return Padding(
      padding: const EdgeInsets.only(top: 32.0, bottom: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          DoneStepSlide(width: width * 0.2),
          groupAssessmentPage.index >= 1
              ? DoneStepSlide(width: width * 0.2)
              : UnDoneStepSlide(width: width * 0.2),
          groupAssessmentPage.index >= 2
              ? DoneStepSlide(width: width * 0.2)
              : UnDoneStepSlide(width: width * 0.2),
        ],
      ),
    );
  }
}

class UnDoneStepSlide extends StatelessWidget {
  const UnDoneStepSlide({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Container(
            color: ConstColors.accentColor.withOpacity(0.3),
            width: width,
            height: 3.5),
      ),
    );
  }
}

class DoneStepSlide extends StatelessWidget {
  const DoneStepSlide({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        child: Container(
            color: ConstColors.accentColor, width: width, height: 3.5),
      ),
    );
  }
}
