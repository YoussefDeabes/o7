import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/booking_screen_filter_bloc.dart';

import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_models.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/bottom_sheet_filter_items/clear_button.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/bottom_sheet_filter_items/filter_section_header.dart';
import 'package:o7therapy/util/firebase/analytics/booking_analytics.dart';
import 'package:o7therapy/ui/screens/booking/widgets/filter_widgets/bottom_sheet_filter_items/price_range_section/price_range_section.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class BookingFilterModalBottomSheet extends BaseStatefulWidget {
  const BookingFilterModalBottomSheet({Key? key})
      : super(key: key, backGroundColor: Colors.transparent);

  @override
  BaseState<BookingFilterModalBottomSheet> baseCreateState() =>
      _BookingFilterModalBottomSheetState();
}

class _BookingFilterModalBottomSheetState
    extends BaseState<BookingFilterModalBottomSheet> {
  final GlobalKey<PriceRangeSectionState> priceRangeGlobalKey = GlobalKey();
  late RangeValues currentRangeValues;
  bool _isExpanded = true;
  late BookingScreenFilterBloc bloc;
  // Set<LanguagesListFilter> selectedLanguages = {};
  TherapistGenderFilter? selectedTherapistGender;
  bool isSelectedTherapistAcceptsNewClients = false;
  bool isSelectedTherapistPrescribesMedication = false;
  bool isSelectedBookedWithBefore = false;
  bool isSelectedPreviouslyMatchedTherapist = false;
  late FilterPriceData filterPrice;

  bool selectArabicLanguage = false;
  bool selectEnglishLanguage = false;
  bool selectFrenchLanguage = false;
  bool selectGermanLanguage = false;

  @override
  void initState() {
    bloc = context.read<BookingScreenFilterBloc>();
    BookingScreenFilterState state = bloc.state;
    // the 8 filters
    filterPrice = state.priceData;
    currentRangeValues = RangeValues(
      filterPrice.minPrice.toDouble(),
      filterPrice.maxPrice.toDouble(),
    );

    selectArabicLanguage = state.selectArabicLanguage;
    selectEnglishLanguage = state.selectEnglishLanguage;
    selectFrenchLanguage = state.selectFrenchLanguage;
    selectGermanLanguage = state.selectGermanLanguage;
    selectedTherapistGender = state.therapistGender;
    // selectedLanguages = state.selectedLanguages.map((e) => e).toSet();
    isSelectedTherapistAcceptsNewClients = state.therapistAcceptsNewClients;
    isSelectedTherapistPrescribesMedication =
        state.therapistPrescribesMedication;
    isSelectedBookedWithBefore = state.bookedWithBefore;
    isSelectedPreviouslyMatchedTherapist = state.previouslyMatchedTherapist;
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: Stack(children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _getBackButton(context),
                ),
                Align(
                  alignment: Alignment.center,
                  child: _getBottomSheetTitle(translate(LangKeys.filterBy)),
                ),
              ]),
            ),
          ],
        ),
        Expanded(
          child: SingleChildScrollView(
              child: Column(
            children: <Widget>[
              /// Price Range
              PriceRangeSection(
                key: priceRangeGlobalKey,
                currentRangeValues: currentRangeValues,
                filterPrice: filterPrice,
                onRangeChanged: (RangeValues values) {
                  setState(() => currentRangeValues = values);
                },
                onResetPressed: () => setState(() {
                  currentRangeValues = RangeValues(
                    filterPrice.initialMinPrice.toDouble(),
                    filterPrice.initialMaxPrice.toDouble(),
                  );
                }),
              ),
              const Divider(),
              _getGenderSelectionSection(),
              const Divider(),
              _getLanguageSelectionSection(),
              const Divider(),
              _getTherapistAcceptsNewClientsSection(),
              const Divider(),
              _getTherapistPrescribesMedicationSection(),
              const Divider(),
              // _getBookedWithBeforeSection(),
              // const Divider(),
              // _getPreviouslyMatchedTherapistSection(),
            ],
          )),
        ),
        const SizedBox(height: 25),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _getResetButton(),
            _getApplyFilterButton(),
          ],
        ),
        const SizedBox(height: 15),
      ],
    );
  }

  /// Get BackButton To Exit bottom sheet
  Widget _getBackButton(BuildContext context) {
    return ClipOval(
        child: Material(
      child: IconButton(
        padding: EdgeInsets.zero,
        alignment: AlignmentDirectional.center,
        iconSize: 20,
        visualDensity: const VisualDensity(
            horizontal: VisualDensity.minimumDensity,
            vertical: VisualDensity.minimumDensity),
        onPressed: () => Navigator.pop(context),
        color: ConstColors.app,
        icon: const Icon(Icons.arrow_back_ios_sharp),
      ),
    ));
  }

  /// get the gender selection section to let the user select the therapist gender
  Widget _getGenderSelectionSection() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FilterSectionHeader(
                  headerText: translate(LangKeys.therapistGender)),
              ClearButton(
                onPressed: () {
                  setState(() => selectedTherapistGender = null);
                },
              ),
            ],
          ),
          ...TherapistGenderFilter.values.map(
            (gender) => _getRadioListTile(
              visualDensity: const VisualDensity(
                  horizontal: VisualDensity.minimumDensity,
                  vertical: VisualDensity.minimumDensity),
              title: translate(gender.langKey),
              groupValue: selectedTherapistGender,
              value: gender,
              onChanged: (val) {
                // bloc.add(UpdateTherapistGenderEvent(value: gender));
                // setState(() => filterModel.therapistGender.value = gender);
                setState(() => selectedTherapistGender = gender);
              },
            ),
          )
        ]);
  }

  /// get _getRadioListTile
  Widget _getRadioListTile({
    required String title,
    required Object? groupValue,
    required Object value,
    bool selected = false,
    required void Function(Object?)? onChanged,
    VisualDensity? visualDensity,
    bool toggleable = false,
  }) {
    return RadioListTile(
      toggleable: toggleable,
      visualDensity: visualDensity,
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
      title: Text(title),
      groupValue: groupValue,
      value: value,
      selected: selected,
      onChanged: onChanged,
    );
  }

  /// get CheckboxListTile
  Widget _getCheckboxListTile({
    required String titleString,
    required bool? value,
    required void Function(bool?)? onChanged,
  }) {
    return CheckboxListTile(
      title: Text(titleString),
      value: value,
      visualDensity: const VisualDensity(
          horizontal: VisualDensity.minimumDensity,
          vertical: VisualDensity.minimumDensity),
      contentPadding: EdgeInsets.zero,
      controlAffinity: ListTileControlAffinity.trailing,
      activeColor: ConstColors.app,
      checkColor: Colors.white,
      onChanged: onChanged,
    );
  }

  /// get language selection section
  Widget _getLanguageSelectionSection() {
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
        expansionTileTheme: const ExpansionTileThemeData(
          tilePadding: EdgeInsets.zero,
        ),
      ),
      child: ExpansionTile(
        initiallyExpanded: _isExpanded,
        onExpansionChanged: (value) {
          setState(() => _isExpanded = !_isExpanded);
        },
        trailing: ClearButton(
          onPressed: () {
            setState(() {
              // selectedLanguages.clear(),
              selectArabicLanguage = false;
              selectEnglishLanguage = false;
              selectFrenchLanguage = false;
              selectGermanLanguage = false;
            });
          },
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            FilterSectionHeader(headerText: translate(LangKeys.language)),
            const SizedBox(width: 10),
            Icon(
              _isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
              color: _isExpanded ? ConstColors.app : ConstColors.appGrey,
            ),
          ],
        ),

        children: [
          CheckboxListTile(
            title: Text(translate(LanguagesListFilter.arabic.langKey)),
            value: selectArabicLanguage,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: ConstColors.app,
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                selectArabicLanguage = !selectArabicLanguage;
              });
            },
          ),
          CheckboxListTile(
            title: Text(translate(LanguagesListFilter.english.langKey)),
            value: selectEnglishLanguage,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: ConstColors.app,
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                selectEnglishLanguage = !selectEnglishLanguage;
              });
            },
          ),
          CheckboxListTile(
            title: Text(translate(LanguagesListFilter.french.langKey)),
            value: selectFrenchLanguage,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: ConstColors.app,
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                selectFrenchLanguage = !selectFrenchLanguage;
              });
            },
          ),
          CheckboxListTile(
            title: Text(translate(LanguagesListFilter.german.langKey)),
            value: selectGermanLanguage,
            visualDensity: const VisualDensity(
                horizontal: VisualDensity.minimumDensity,
                vertical: VisualDensity.minimumDensity),
            contentPadding: EdgeInsets.zero,
            controlAffinity: ListTileControlAffinity.trailing,
            activeColor: ConstColors.app,
            checkColor: Colors.white,
            onChanged: (value) {
              setState(() {
                selectGermanLanguage = !selectGermanLanguage;
              });
            },
          ),
        ],
        // LanguagesListFilter.values
        //     .map((language) => CheckboxListTile(
        //           title: Text(translate(language.langKey)),
        //           value: selectedLanguages.contains(language),
        //           visualDensity: const VisualDensity(
        //               horizontal: VisualDensity.minimumDensity,
        //               vertical: VisualDensity.minimumDensity),
        //           contentPadding: EdgeInsets.zero,
        //           controlAffinity: ListTileControlAffinity.trailing,
        //           activeColor: ConstColors.app,
        //           checkColor: Colors.white,
        //           onChanged: (value) {
        //             setState(() {
        //               if (value != null) {
        //                 selectedLanguages.contains(language)
        //                     ? selectedLanguages.remove(language)
        //                     : selectedLanguages.add(language);
        //               }
        //             });
        //           },
        //         ))
        //     .toList(),
      ),
    );
  }

  /// get Therapist Accepts New Clients Section
  Widget _getTherapistAcceptsNewClientsSection() {
    return _getCheckboxListTile(
      titleString: translate(LangKeys.acceptsNewClients),
      value: isSelectedTherapistAcceptsNewClients,
      onChanged: (value) {
        setState(() {
          isSelectedTherapistAcceptsNewClients =
              !isSelectedTherapistAcceptsNewClients;
        });
      },
    );
  }

  /// get Therapist Prescribes Medication Section
  Widget _getTherapistPrescribesMedicationSection() {
    return _getCheckboxListTile(
      titleString: translate(LangKeys.prescribesMedication),
      value: isSelectedTherapistPrescribesMedication,
      onChanged: (value) {
        setState(() {
          isSelectedTherapistPrescribesMedication =
              !isSelectedTherapistPrescribesMedication;
        });
      },
    );
  }

  /// get Booked With Before Section
  Widget _getBookedWithBeforeSection() {
    return _getCheckboxListTile(
      titleString: translate(LangKeys.bookedWithBefore),
      value: isSelectedBookedWithBefore,
      onChanged: (value) {
        setState(() {
          isSelectedBookedWithBefore = !isSelectedBookedWithBefore;
        });
      },
    );
  }

  /// get Previously Matched Therapist Section
  Widget _getPreviouslyMatchedTherapistSection() {
    return _getCheckboxListTile(
      titleString: translate(LangKeys.previouslyMatchedTherapist),
      value: isSelectedPreviouslyMatchedTherapist,
      onChanged: (value) {
        setState(() {
          isSelectedPreviouslyMatchedTherapist =
              !isSelectedPreviouslyMatchedTherapist;
        });
      },
    );
  }

  /// get centered bottom sheet title
  Widget _getBottomSheetTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: ConstColors.app,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  /// get the reset text button
  Widget _getResetButton() {
    return ElevatedButton(
      onPressed: () {
        // the ui and bloc will be updated
        // but will not close the bottom sheet
        bloc.add(const ResetFiltersEvent());
        setState(() {
          // the ui and bloc will be updated
          // but will not close the bottom sheet
          selectedTherapistGender = null;
          selectArabicLanguage = false;
          selectEnglishLanguage = false;
          selectFrenchLanguage = false;
          selectGermanLanguage = false;
          currentRangeValues = RangeValues(
            filterPrice.initialMinPrice.toDouble(),
            filterPrice.initialMaxPrice.toDouble(),
          );
          priceRangeGlobalKey.currentState?.reset();
          // selectedLanguages = {};
          isSelectedTherapistAcceptsNewClients = false;
          isSelectedTherapistPrescribesMedication = false;
          isSelectedBookedWithBefore = false;
          isSelectedPreviouslyMatchedTherapist = false;
        });
      },
      style: ElevatedButton.styleFrom(
        side: const BorderSide(width: 1.0, color: ConstColors.app),
        minimumSize: Size(width * 0.3, 50),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        shadowColor: Colors.black,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black38,
      ),
      child: Text(
        translate(LangKeys.reset),
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: ConstColors.app,
        ),
      ),
    );
  }

  /// get Apply Filter Button
  Widget _getApplyFilterButton() {
    return ElevatedButton(
      onPressed: () {
        bloc.add(ApplyFiltersEvent(
          filterViewModel: FilterViewModel(
              selectFrenchLanguage: selectFrenchLanguage,
              selectGermanLanguage: selectGermanLanguage,
              selectedTherapistGender: selectedTherapistGender,
              // selectedLanguages: selectedLanguages,
              selectArabicLanguage: selectArabicLanguage,
              selectEnglishLanguage: selectEnglishLanguage,
              isSelectedTherapistAcceptsNewClients:
                  isSelectedTherapistAcceptsNewClients,
              isSelectedTherapistPrescribesMedication:
                  isSelectedTherapistPrescribesMedication,
              isSelectedBookedWithBefore: isSelectedBookedWithBefore,
              isSelectedPreviouslyMatchedTherapist:
                  isSelectedPreviouslyMatchedTherapist,
              priceData: FilterPriceData(
                  initialMinPrice: filterPrice.initialMinPrice,
                  initialMaxPrice: filterPrice.initialMaxPrice,
                  minPrice: currentRangeValues.start.toInt(),
                  maxPrice: currentRangeValues.end.toInt(),
                  currency: filterPrice.currency)),
        ));
        BookingAnalytics.i.therapistListFilter(
          isSelectFrench: selectFrenchLanguage,
          isSelectGerman: selectGermanLanguage,
          isSelectArabic: selectArabicLanguage,
          isSelectEnglish: selectEnglishLanguage,
          isAcceptNewClient: isSelectedTherapistAcceptsNewClients,
          filterByGender: selectedTherapistGender?.filterValueName,
          isFilterByMedication: isSelectedTherapistPrescribesMedication,
          fromPrice: currentRangeValues.start.toInt(),
          toPrice: currentRangeValues.end.toInt(),
          currency: filterPrice.currency,
        );
        // bloc.add(ApplyFiltersEvent(
        //     selectedTherapistGender: selectedTherapistGender,
        //     // selectedLanguages: selectedLanguages,
        //     selectArabicLanguage: selectArabicLanguage,
        //     selectEnglishLanguage: selectEnglishLanguage,
        //     isSelectedTherapistAcceptsNewClients:
        //         isSelectedTherapistAcceptsNewClients,
        //     isSelectedTherapistPrescribesMedication:
        //         isSelectedTherapistPrescribesMedication,
        //     isSelectedBookedWithBefore: isSelectedBookedWithBefore,
        //     isSelectedPreviouslyMatchedTherapist:
        //         isSelectedPreviouslyMatchedTherapist,
        //     priceData: FilterPriceData(
        //         initialMinPrice: filterPrice.initialMinPrice,
        //         initialMaxPrice: filterPrice.initialMaxPrice,
        //         minPrice: currentRangeValues.start.toInt(),
        //         maxPrice: currentRangeValues.end.toInt(),
        //         currency: filterPrice.currency)));
        Navigator.pop(context);
      },
      style: ElevatedButton.styleFrom(
        minimumSize: Size(width * 0.4, 50),
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      ),
      child: Text(translate(LangKeys.applyFilter)),
    );
  }
}
