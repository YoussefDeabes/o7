import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_enums.dart';

class FilterViewModel {
  // final Set<LanguagesListFilter> selectedLanguages;
  final bool selectArabicLanguage;
  final bool selectEnglishLanguage;
  final bool selectFrenchLanguage;
  final bool selectGermanLanguage;
  final TherapistGenderFilter? selectedTherapistGender;
  final bool isSelectedTherapistAcceptsNewClients;
  final bool isSelectedTherapistPrescribesMedication;
  final bool isSelectedBookedWithBefore;
  final bool isSelectedPreviouslyMatchedTherapist;
  final FilterPriceData priceData;

  const FilterViewModel({
    // this.selectedLanguages = const {},
    this.selectArabicLanguage = false,
    this.selectEnglishLanguage = false,
    this.selectFrenchLanguage = false,
    this.selectGermanLanguage = false,
    this.selectedTherapistGender,
    this.isSelectedTherapistAcceptsNewClients = false,
    this.isSelectedTherapistPrescribesMedication = false,
    this.isSelectedBookedWithBefore = false,
    this.isSelectedPreviouslyMatchedTherapist = false,
    this.priceData = FilterPriceData.init,
  });

  factory FilterViewModel.init() => const FilterViewModel(
        // isThereIsAnyFilterApplied: false,
        selectedTherapistGender: null,
        selectArabicLanguage: false,
        selectEnglishLanguage: false,
        selectFrenchLanguage: false,
        selectGermanLanguage: false,
        isSelectedTherapistAcceptsNewClients: false,
        isSelectedTherapistPrescribesMedication: false,
        isSelectedBookedWithBefore: false,
        isSelectedPreviouslyMatchedTherapist: false,
        priceData: FilterPriceData.init,
      );

  @override
  String toString() {
    return 'FilterViewModel(selectArabicLanguage: $selectArabicLanguage, selectEnglishLanguage: $selectEnglishLanguage, selectFrenchLanguage: $selectFrenchLanguage, selectGermanLanguage: $selectGermanLanguage, selectedTherapistGender: $selectedTherapistGender, isSelectedTherapistAcceptsNewClients: $isSelectedTherapistAcceptsNewClients, isSelectedTherapistPrescribesMedication: $isSelectedTherapistPrescribesMedication, isSelectedBookedWithBefore: $isSelectedBookedWithBefore, isSelectedPreviouslyMatchedTherapist: $isSelectedPreviouslyMatchedTherapist, priceData: $priceData)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FilterViewModel &&
        other.selectArabicLanguage == selectArabicLanguage &&
        other.selectEnglishLanguage == selectEnglishLanguage &&
        other.selectFrenchLanguage == selectFrenchLanguage &&
        other.selectGermanLanguage == selectGermanLanguage &&
        other.selectedTherapistGender == selectedTherapistGender &&
        other.isSelectedTherapistAcceptsNewClients ==
            isSelectedTherapistAcceptsNewClients &&
        other.isSelectedTherapistPrescribesMedication ==
            isSelectedTherapistPrescribesMedication &&
        other.isSelectedBookedWithBefore == isSelectedBookedWithBefore &&
        other.isSelectedPreviouslyMatchedTherapist ==
            isSelectedPreviouslyMatchedTherapist &&
        other.priceData == priceData;
  }

  @override
  int get hashCode {
    return selectArabicLanguage.hashCode ^
        selectEnglishLanguage.hashCode ^
        selectFrenchLanguage.hashCode ^
        selectGermanLanguage.hashCode ^
        selectedTherapistGender.hashCode ^
        isSelectedTherapistAcceptsNewClients.hashCode ^
        isSelectedTherapistPrescribesMedication.hashCode ^
        isSelectedBookedWithBefore.hashCode ^
        isSelectedPreviouslyMatchedTherapist.hashCode ^
        priceData.hashCode;
  }
}
