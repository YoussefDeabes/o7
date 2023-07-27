part of 'booking_screen_filter_bloc.dart';

class BookingScreenFilterState extends Equatable {
  final bool isListenerEnabled;
  final bool _isThereIsAnyFilterApplied;
  final Set<FilterItem> _filterItems;
  final FilterViewModel _filterViewModel;
  const BookingScreenFilterState({
    this.isListenerEnabled = true,
    required Set<FilterItem> filterItems,
    required FilterViewModel filterViewModel,
    required bool isThereIsAnyFilterApplied,
  })  : _isThereIsAnyFilterApplied = isThereIsAnyFilterApplied,
        _filterItems = filterItems,
        _filterViewModel = filterViewModel;

  TherapistGenderFilter? get therapistGender =>
      _filterViewModel.selectedTherapistGender;

  bool get selectArabicLanguage => _filterViewModel.selectArabicLanguage;
  bool get selectEnglishLanguage => _filterViewModel.selectEnglishLanguage;
  bool get selectFrenchLanguage => _filterViewModel.selectFrenchLanguage;
  bool get selectGermanLanguage => _filterViewModel.selectGermanLanguage;
  bool get therapistAcceptsNewClients =>
      _filterViewModel.isSelectedTherapistAcceptsNewClients;
  bool get therapistPrescribesMedication =>
      _filterViewModel.isSelectedTherapistPrescribesMedication;
  bool get bookedWithBefore => _filterViewModel.isSelectedBookedWithBefore;
  bool get previouslyMatchedTherapist =>
      _filterViewModel.isSelectedPreviouslyMatchedTherapist;
  bool get isThereIsAnyFilterApplied => _isThereIsAnyFilterApplied;
  FilterPriceData get priceData => _filterViewModel.priceData.copyWith();
  Set<FilterItem> get filterItems => _filterItems;

  Map<String, dynamic> filterParameters() {
    Map<String, dynamic> parameters = {};
    for (FilterItem item in _filterItems) {
      if (item.isApplied) {
        for (int i = 0; i < item.filterKeyForQuery.length; i++) {
          // only the price range
          if (item is PriceRange) {
            parameters[item.filterKeyForQuery[i]] = item.filterValueForQuery[i];

            // if the key is already applied >> then get the list and and the new value to it
          } else if (parameters.containsKey(item.filterKeyForQuery[i])) {
            (parameters[item.filterKeyForQuery[i]] as List)
                .add(item.filterValueForQuery[i]);

            // else there is no key at the query then add it
          } else {
            parameters[item.filterKeyForQuery[i]] = item.filterValueForQuery;
          }
        }
      }
    }
    return parameters;
  }

  factory BookingScreenFilterState.init() => BookingScreenFilterState(
        filterItems: const {},
        filterViewModel: FilterViewModel.init(),
        isThereIsAnyFilterApplied: false,
      );

  @override
  List<Object?> get props => [
        selectArabicLanguage,
        selectEnglishLanguage,
        selectFrenchLanguage,
        selectGermanLanguage,
        therapistGender,
        therapistAcceptsNewClients,
        therapistPrescribesMedication,
        bookedWithBefore,
        previouslyMatchedTherapist,
        isThereIsAnyFilterApplied,
        priceData.initialMaxPrice,
        priceData.initialMinPrice,
        priceData.maxPrice,
        priceData.minPrice,
        priceData.currency,
      ];

  @override
  String toString() =>
      'BookingScreenFilterState(_isThereIsAnyFilterApplied: $_isThereIsAnyFilterApplied, _filterItems: $_filterItems, _filterViewModel: ${_filterViewModel.toString()})';
}
