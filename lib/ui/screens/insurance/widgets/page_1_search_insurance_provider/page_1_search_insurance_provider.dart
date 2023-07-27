import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/insurance/insurance_providers_list/provider_data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';

import 'package:o7therapy/ui/screens/insurance/bloc/insurance_list_bloc/insurance_list_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/screen/edit_insurance_data_screen.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/shared_widgets/shared_widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class PageOneSearchInsuranceProvider extends BaseStatefulWidget {
  const PageOneSearchInsuranceProvider({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> baseCreateState() {
    return _PageOneSearchInsuranceProviderState();
  }
}

class _PageOneSearchInsuranceProviderState
    extends BaseState<PageOneSearchInsuranceProvider> {
  String? _userSelection;
  List<ProviderData>? providersList;
  @override
  Widget baseBuild(BuildContext context) {
    return SingleChildScrollView(
      child: SizedBox(
        height: height * 0.85,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            InsurancePageRoundedBox(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    translate(LangKeys.pleaseSelectYourInsuranceProviderTo),
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: ConstColors.text,
                    ),
                  ),
                  SizedBox(height: height * 0.04),
                  BlocBuilder<InsuranceListBloc, InsuranceListState>(
                    builder: (context, state) {
                      if (state is LoadedInsuranceListState) {
                        providersList = state.insuranceProvidersList;
                        return _getRawAutoComplete(
                          providersList: state.insuranceProvidersList,
                        );
                      } else if (state is LoadingInsuranceListState) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (state is ExceptionInsuranceListState) {
                        return Text('${state.message} some Thing went wrong ');
                      }
                      return Container();
                    },
                  ),
                  SizedBox(height: height * 0.01),
                ],
              ),
            ),
            _getNextButton(context),
          ],
        ),
      ),
    );
  }

  /// get next button that navigate the user to page two
  Container _getNextButton(BuildContext context) {
    return Container(
      alignment: AlignmentDirectional.bottomEnd,
      margin: EdgeInsets.symmetric(vertical: height * 0.035),
      child: InsurancePageButton(
        width: width * 0.3,
        buttonLabel: translate(LangKeys.next),
        fontColor: _getSelectedProvider() == null
            ? ConstColors.textDisabled
            : ConstColors.appWhite,
        borderSideColor: ConstColors.disabled,
        onPressed: _getSelectedProvider() == null
            ? null
            : () {
                log("Next Pressed to go to next page >> insurance screen or show error");
                debugPrint(_getSelectedProvider().toString());
                Navigator.pushNamed(
                  context,
                  EditInsuranceDataScreen.routeName,
                  arguments: _getSelectedProvider(),
                );
              },
      ),
    );
  }

  /// get the row auto complete for the search bar and it's selection
  Widget _getRawAutoComplete({required List<ProviderData> providersList}) {
    return LayoutBuilder(builder: (context, constraints) {
      return RawAutocomplete(
        optionsBuilder: (TextEditingValue textEditingValue) {
          List<String> matches =
              providersList.map((e) => e.providerName).toList();
          matches.retainWhere((item) {
            return item
                .toLowerCase()
                .contains(textEditingValue.text.toLowerCase());
          });
          return matches;
        },
        onSelected: (String selection) {
          debugPrint('You just selected $selection');
          setState(() {
            _userSelection = selection;
          });
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          return TextField(
            controller: textEditingController,
            focusNode: focusNode,
            onSubmitted: (String value) => setState(
              () => _userSelection = value,
            ),
            style: const TextStyle(fontSize: 14.0),
            onChanged: (value) => setState(() => _userSelection = value),
            enableSuggestions: true,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              labelText: translate(LangKeys.searchInsuranceProvider),
              alignLabelWithHint: true,
              suffixIcon: Padding(
                padding: EdgeInsets.symmetric(vertical: 0.012 * height),
                child: SvgPicture.asset(AssPath.searchIcon),
              ),
            ),
          );
        },
        optionsViewBuilder: (
          BuildContext context,
          void Function(String) onSelected,
          Iterable<String> options,
        ) {
          return Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Material(
                color: Colors.transparent,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0)),
                ),
                elevation: 2,
                shadowColor: ConstColors.solid,
                child: Container(
                  height: 49.0 * options.length,
                  width: constraints.biggest.width,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(4.0),
                    color: ConstColors.appWhite,
                  ),
                  child: ListView.separated(
                      shrinkWrap: true,
                      padding: EdgeInsets.zero,
                      itemCount: options.length,
                      separatorBuilder: (context, index) => const Center(
                            child: Divider(
                              color: ConstColors.disabled,
                              indent: 2,
                              endIndent: 2,
                            ),
                          ),
                      itemBuilder: (BuildContext context, int index) {
                        final String option = options.elementAt(index);
                        return InkWell(
                          onTap: () => onSelected(option),
                          child: Container(
                            // height: 30.0,
                            alignment: AlignmentDirectional.centerStart,
                            margin: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 15,
                            ),
                            child: Text(
                              option,
                              style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: ConstColors.text,
                              ),
                            ),
                          ),
                        );
                      }),
                ),
              ),
            ),
          );
        },
      );
    });
  }

  /// helper Methods
  ProviderData? _getSelectedProvider() {
    if (_userSelection == null || providersList == null) {
      return null;
    } else if (providersList!
        .any((item) => item.providerName == _userSelection)) {
      return providersList!
          .firstWhere((element) => element.providerName == _userSelection);
    } else {
      return null;
    }
  }
}
