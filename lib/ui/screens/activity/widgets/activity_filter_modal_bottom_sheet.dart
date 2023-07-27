import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';
import 'package:o7therapy/ui/screens/activity/filter_list.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ActivityFilterModalBottomSheet extends BaseStatefulWidget {
  const ActivityFilterModalBottomSheet({Key? key})
      : super(key: key, backGroundColor: Colors.transparent);

  @override
  _ActivityFilterModalBottomSheetState baseCreateState() =>
      _ActivityFilterModalBottomSheetState();
}

class _ActivityFilterModalBottomSheetState
    extends BaseState<ActivityFilterModalBottomSheet> {
  late ActivityBloc bloc;
  Set<ServicesType> selectedServicesType = {};
  Set<SessionStatus> selectedSessionStatus = {};

  @override
  void initState() {
    bloc = context.read<ActivityBloc>();
    ActivityState state = bloc.state;
    if (state is FilterSessionState) {
      selectedServicesType = state.selectedServicesType.map((e) => e).toSet();
      selectedSessionStatus = state.selectedSessionStatus.map((e) => e).toSet();
    }
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 10),
        _getBottomSheetTitle(translate(LangKeys.filterBy)),
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              _getSessionStatusSection(),
              const Divider(),
              _getServicesTypeSection(),
            ],
          )),
        ),
        const SizedBox(height: 26),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _getResetAllButton(),
            _getApplyFilterButton(),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  /// get Services Type Section
  _getServicesTypeSection() {
    return _getSelectionSection(
      selectedItemsSet: selectedServicesType,
      filterSectionHeaderTitle: translate(LangKeys.servicesType),
      allSelections: ServicesType.list,
    );
  }

  /// get Session Status Section
  _getSessionStatusSection() {
    return _getSelectionSection(
      selectedItemsSet: selectedSessionStatus,
      filterSectionHeaderTitle: translate(LangKeys.sessionStatus),
      allSelections: SessionStatus.list,
    );
  }

  /// get language selection section
  Widget _getSelectionSection({
    required Set<FilterList> selectedItemsSet,
    required String filterSectionHeaderTitle,
    required List<FilterList> allSelections,
  }) {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        expansionTileTheme: const ExpansionTileThemeData(
          tilePadding: EdgeInsets.zero,
        ),
      ),
      child: ExpansionTile(
        trailing: _getClearButton(
          color: selectedItemsSet.isEmpty
              ? ConstColors.textDisabled
              : ConstColors.secondary,
          onPressed: selectedItemsSet.isEmpty
              ? null
              : () => setState(() => selectedItemsSet.clear()),
        ),
        title: _getFilterSectionHeader(filterSectionHeaderTitle),
        initiallyExpanded: true,
        children: allSelections
            .map((item) => SelectionRow(
                  text: translate(item.langKey),
                  isSelected:
                      selectedItemsSet.any((i) => i.langKey == item.langKey),
                  onTap: () {
                    setState(() {
                      selectedItemsSet.any((i) => i.langKey == item.langKey)
                          ? selectedItemsSet.remove(item)
                          : selectedItemsSet.add(item);
                    });
                  },
                ))
            .toList(),
      ),
    );
  }

  /// get centered bottom sheet title
  Widget _getBottomSheetTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 14, bottom: 28),
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

  /// get the reset text button
  Widget _getResetAllButton() {
    return ElevatedButton(
      onPressed: () {
        // the ui and bloc will be updated
        // but will not close the bottom sheet
        bloc.add(const ApplyFilterActivityEvt(
          selectedServicesType: {},
          selectedSessionStatus: {},
        ));
        setState(() {
          selectedServicesType.clear();
          selectedSessionStatus.clear();
        });
      },
      style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
            side: const BorderSide(color: ConstColors.app),
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 26)),
      child: Text(
        translate(LangKeys.resetAll),
        style: const TextStyle(
          color: ConstColors.app,
          fontSize: 14,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  /// get filter section header
  Widget _getFilterSectionHeader(String header) {
    return Text(
      header,
      style: const TextStyle(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: ConstColors.app,
      ),
    );
  }

  /// _getClearButton
  Widget _getClearButton({
    required void Function()? onPressed,
    required Color color,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
          padding: EdgeInsets.zero,
          fixedSize: const Size.fromRadius(16),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          alignment: AlignmentDirectional.centerEnd,
          visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity,
          )),
      child: Text(
        translate(LangKeys.clear),
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          decoration: TextDecoration.underline,
          color: color,
        ),
      ),
    );
  }

  /// get Apply Filter Button
  Widget _getApplyFilterButton() {
    return ElevatedButton(
      onPressed: () {
        bloc.add(ApplyFilterActivityEvt(
          selectedServicesType: selectedServicesType,
          selectedSessionStatus: selectedSessionStatus,
        ));
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        elevation: 0,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
          side: const BorderSide(color: ConstColors.app),
        ),
      ),
      child: Text(translate(LangKeys.applyFilter)),
    );
  }
}

class SelectionRow extends StatelessWidget {
  final String text;
  final bool isSelected;
  final void Function() onTap;
  const SelectionRow({
    super.key,
    required this.text,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(text),
      visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity),
      contentPadding: EdgeInsets.zero,
      trailing:
          isSelected ? const SelectedCheckBox() : const UnSelectedCheckBox(),
      onTap: onTap,
    );
  }
}

class SelectionItemName extends StatelessWidget {
  final String text;
  const SelectionItemName({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        color: ConstColors.text,
        fontSize: 14,
      ),
    );
  }
}

class UnSelectedCheckBox extends StatelessWidget {
  const UnSelectedCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AssPath.notCheckedIcon);
  }
}

class SelectedCheckBox extends StatelessWidget {
  const SelectedCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(AssPath.checkedIcon);
  }
}
