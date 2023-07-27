import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/filter_min_max_values.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_models.dart';

abstract class BaseFilterRepository {
  const BaseFilterRepository();

  /// clear all the filters
  void clearAllFilters();
  void update({
    required FilterViewModel filterViewModel,
  });

  void removeSingleFilter(Filter filterRemoved);
}

/// SelectedLanguages - TherapistGender - TherapistAcceptsNewClients
/// TherapistPrescribesMedication - BookedWithBefore - PreviouslyMatchedTherapist
class FilterRepository extends BaseFilterRepository {
  final FilterModel _filterModel;
  const FilterRepository({required FilterModel filterModel})
      : _filterModel = filterModel;

  void getMinMaxValues() async {
    _filterModel.updateFilter<FilterPriceData>(
      Filter.priceRange,
      FilterMinMaxValues.filterPriceData,
    );
  }

  @override
  void clearAllFilters() {
    _filterModel.clearAllFilters();
  }

  @override
  void update({required FilterViewModel filterViewModel}) {
    _filterModel.updateFilter<bool>(
      Filter.selectArabicLanguage,
      filterViewModel.selectArabicLanguage,
    );
    _filterModel.updateFilter<bool>(
      Filter.selectEnglishLanguage,
      filterViewModel.selectEnglishLanguage,
    );
    _filterModel.updateFilter<bool>(
      Filter.selectFrenchLanguage,
      filterViewModel.selectFrenchLanguage,
    );
    _filterModel.updateFilter<bool>(
      Filter.selectGermanLanguage,
      filterViewModel.selectGermanLanguage,
    );
    _filterModel.updateFilter<TherapistGenderFilter?>(
      Filter.therapistGender,
      filterViewModel.selectedTherapistGender,
    );
    _filterModel.updateFilter<bool>(
      Filter.therapistAcceptsNewClients,
      filterViewModel.isSelectedTherapistAcceptsNewClients,
    );
    _filterModel.updateFilter<bool>(
      Filter.therapistPrescribesMedication,
      filterViewModel.isSelectedTherapistPrescribesMedication,
    );
    _filterModel.updateFilter<bool>(
      Filter.bookedWithBefore,
      filterViewModel.isSelectedBookedWithBefore,
    );
    _filterModel.updateFilter<bool>(
      Filter.previouslyMatchedTherapist,
      filterViewModel.isSelectedPreviouslyMatchedTherapist,
    );
    _filterModel.updateFilter<FilterPriceData>(
      Filter.priceRange,
      filterViewModel.priceData,
    );
  }

  bool get isThereIsAnyFilterApplied =>
      _filterModel.isThereIsAnyFilterApplied();

  FilterViewModel get filterViewModel => FilterViewModel(
        priceData: _filterModel.getFilter<FilterPriceData>(Filter.priceRange),
        selectedTherapistGender: _filterModel
            .getFilter<TherapistGenderFilter?>(Filter.therapistGender),
        selectArabicLanguage:
            _filterModel.getFilter<bool>(Filter.selectArabicLanguage),
        selectEnglishLanguage:
            _filterModel.getFilter<bool>(Filter.selectEnglishLanguage),
        selectFrenchLanguage:
            _filterModel.getFilter<bool>(Filter.selectFrenchLanguage),
        selectGermanLanguage:
            _filterModel.getFilter<bool>(Filter.selectGermanLanguage),
        isSelectedTherapistAcceptsNewClients:
            _filterModel.getFilter<bool>(Filter.therapistAcceptsNewClients),
        isSelectedTherapistPrescribesMedication:
            _filterModel.getFilter<bool>(Filter.therapistPrescribesMedication),
        isSelectedBookedWithBefore:
            _filterModel.getFilter<bool>(Filter.bookedWithBefore),
        isSelectedPreviouslyMatchedTherapist:
            _filterModel.getFilter<bool>(Filter.previouslyMatchedTherapist),
      );

  Set<FilterItem> get filterItems =>
      _filterModel.filterItems.values.map((e) => e).toSet();
  @override
  void removeSingleFilter(Filter filterRemoved) {
    _filterModel.removeSingleFilter(filterRemoved);
  }
}
