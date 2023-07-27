import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_models.dart';

class FilterModel {
  final Map<Filter, FilterItem> _filterItems;

  FilterModel()
      : _filterItems = {
          // Filter.selectedLanguages: const SelectedLanguages(),
          Filter.selectArabicLanguage: const SelectArabicLanguage(),
          Filter.selectEnglishLanguage: const SelectEnglishLanguage(),
          Filter.selectFrenchLanguage: const SelectFrenchLanguage(),
          Filter.selectGermanLanguage: const SelectGermanLanguage(),
          Filter.therapistGender: const TherapistGender(),
          Filter.therapistAcceptsNewClients: const TherapistAcceptsNewClients(),
          Filter.therapistPrescribesMedication:
              const TherapistPrescribesMedication(),
          Filter.bookedWithBefore: const BookedWithBefore(),
          Filter.previouslyMatchedTherapist: const PreviouslyMatchedTherapist(),
          Filter.priceRange: PriceRange.init,
        };

  /// Clear All Filters .. to initial values
  void clearAllFilters() {
    _filterItems.forEach((key, value) {
      _filterItems[key] = value.clear();
    });
  }

  /// update single value of filer
  void updateFilter<T>(Filter filterEnum, T value) {
    _filterItems[filterEnum] = _filterItems[filterEnum]!.copyWith(value);
  }

  /// Remove Single Filter From the filters >> called in the chip
  void removeSingleFilter(Filter filterRemoved) {
    _filterItems[filterRemoved] = _filterItems[filterRemoved]!.clear();
  }

  /// get a value of the filter
  T getFilter<T>(Filter filter) => _filterItems[filter]!.value;

  Map<Filter, FilterItem> get filterItems => _filterItems;

  bool isThereIsAnyFilterApplied() {
    for (var filterItem in _filterItems.values) {
      if (filterItem.isApplied) {
        return true;
      }
    }
    return false;
  }
}
