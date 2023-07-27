import 'package:o7therapy/util/lang/app_localization_keys.dart';

enum Filter {
  // selectedLanguages,
  therapistGender,
  therapistAcceptsNewClients,
  therapistPrescribesMedication,
  bookedWithBefore,
  previouslyMatchedTherapist,
  selectArabicLanguage,
  selectEnglishLanguage,
  selectFrenchLanguage,
  selectGermanLanguage,
  priceRange,
}

enum TherapistGenderFilter {
  male(langKey: LangKeys.male, filterValueName: "Male"),
  female(langKey: LangKeys.female, filterValueName: "Female");

  const TherapistGenderFilter({
    required this.langKey,
    required this.filterValueName,
  });
  final String langKey;
  final String filterValueName;

  String toMap() => name;
  static TherapistGenderFilter fromMap(String value) {
    return TherapistGenderFilter.values
        .firstWhere((gender) => gender.name == value);
  }
}

enum LanguagesListFilter {
  arabic(langKey: LangKeys.arabic, filterValueName: "Arabic"),
  english(langKey: LangKeys.english, filterValueName: "English"),
  french(langKey: LangKeys.french, filterValueName: "Frensh"),
  german(langKey: LangKeys.german, filterValueName: "German");

  const LanguagesListFilter({
    required this.langKey,
    required this.filterValueName,
  });
  final String langKey;
  final String filterValueName;
}

class FilterPriceData {
  final int _initialMinPrice;
  final int _initialMaxPrice;
  final int _minPrice;
  final int _maxPrice;
  final String _currency;

  const FilterPriceData({
    required int initialMinPrice,
    required int initialMaxPrice,
    required int minPrice,
    required int maxPrice,
    required String currency,
  })  : _initialMinPrice = initialMinPrice,
        _initialMaxPrice = initialMaxPrice,
        _minPrice = minPrice,
        _maxPrice = maxPrice,
        _currency = currency;

  static const FilterPriceData init = FilterPriceData(
    initialMinPrice: 100,
    initialMaxPrice: 10000,
    minPrice: 1000,
    maxPrice: 10000,
    currency: "USD",
  );

  FilterPriceData copyWith({
    int? initialMinPrice,
    int? initialMaxPrice,
    int? minPrice,
    int? maxPrice,
    String? currency,
  }) {
    return FilterPriceData(
      initialMinPrice: initialMinPrice ?? _initialMinPrice,
      initialMaxPrice: initialMaxPrice ?? _initialMaxPrice,
      minPrice: minPrice ?? _minPrice,
      maxPrice: maxPrice ?? _maxPrice,
      currency: currency ?? _currency,
    );
  }

  int get initialMinPrice => _initialMinPrice;
  int get initialMaxPrice => _initialMaxPrice;
  int get minPrice => _minPrice;
  int get maxPrice => _maxPrice;
  String get currency => _currency;

  @override
  String toString() {
    return 'FilterPriceData(_initialMinPrice: $_initialMinPrice, _initialMaxPrice: $_initialMaxPrice, _minPrice: $_minPrice, _maxPrice: $_maxPrice, _currency: $_currency)';
  }
}
