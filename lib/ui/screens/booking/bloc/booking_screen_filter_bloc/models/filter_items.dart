import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_models.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

// class SelectedLanguages extends FilterItem<Set<LanguagesListFilter>> {
//   const SelectedLanguages({super.value = const {}});

//   /// if the set is not empty then there are language in it
//   /// and need to apply the filter
//   @override
//   bool get isApplied => value.isNotEmpty;
//   @override
//   SelectedLanguages clear() => const SelectedLanguages();

//   @override
//   Filter get filter => Filter.selectedLanguages;

//   @override
//   String get chipTitle => LangKeys.language;

//   @override
//   SelectedLanguages copyWith(Set<LanguagesListFilter>? value) {
//     log("done");
//     return SelectedLanguages(value: value ?? super.value.map((e) => e).toSet());
//   }
// }

abstract class FilterItem<T> {
  final T value;
  const FilterItem({required this.value});
  Filter get filter;

  /// the title or the name of filter like language or gender
  String get chipTitle;

  /// check if the user apply this filter or not
  bool get isApplied;

  /// copyWith used to return a FilterItem depending on the change
  FilterItem<T> copyWith(T? value);

  /// get the keys of the query and must matched with the Values [filterValueForQuery]
  List<String> get filterKeyForQuery;

  /// get the values of the query and must matched with the Key [filterKeyForQuery]
  List<dynamic> get filterValueForQuery;

  /// clear the value of the filter to initial
  /// make the item not selected then it will be not applied
  FilterItem<T> clear();
}

class PriceRange extends FilterItem<FilterPriceData> {
  const PriceRange({required super.value});
  static const init = PriceRange(value: FilterPriceData.init);
  @override
  bool get isApplied =>
      value.initialMaxPrice != value.maxPrice ||
      value.initialMinPrice != value.minPrice;

  @override
  String get chipTitle => "${value.minPrice} - ${value.maxPrice}";

  @override
  PriceRange clear() => copyWith(super.value.copyWith(
        maxPrice: super.value.initialMaxPrice,
        minPrice: super.value.initialMinPrice,
      ));

  @override
  PriceRange copyWith(FilterPriceData? value) => PriceRange(
        value: value ?? super.value.copyWith(),
      );

  @override
  Filter get filter => Filter.priceRange;

  @override
  List<String> get filterKeyForQuery => ["from_price", "to_price"];

  @override
  List<int> get filterValueForQuery => [value.minPrice, value.maxPrice];
}

class SelectArabicLanguage extends FilterItem<bool> {
  const SelectArabicLanguage({super.value = false});

  @override
  bool get isApplied => value;
  @override
  SelectArabicLanguage clear() => const SelectArabicLanguage();

  @override
  Filter get filter => Filter.selectArabicLanguage;

  @override
  String get chipTitle => LanguagesListFilter.arabic.langKey;

  @override
  SelectArabicLanguage copyWith(bool? value) {
    return SelectArabicLanguage(value: value ?? super.value);
  }

  @override
  List<dynamic> get filterValueForQuery =>
      [LanguagesListFilter.arabic.filterValueName];

  @override
  List<String> get filterKeyForQuery => ["filter_by_language"];
}

class SelectEnglishLanguage extends FilterItem<bool> {
  const SelectEnglishLanguage({super.value = false});

  @override
  bool get isApplied => value;
  @override
  SelectEnglishLanguage clear() => const SelectEnglishLanguage();

  @override
  Filter get filter => Filter.selectEnglishLanguage;

  @override
  String get chipTitle => LanguagesListFilter.english.langKey;

  @override
  SelectEnglishLanguage copyWith(bool? value) {
    return SelectEnglishLanguage(value: value ?? super.value);
  }

  @override
  List<dynamic> get filterValueForQuery =>
      [LanguagesListFilter.english.filterValueName];

  @override
  List<String> get filterKeyForQuery => ["filter_by_language"];
}

class SelectFrenchLanguage extends FilterItem<bool> {
  const SelectFrenchLanguage({super.value = false});

  @override
  bool get isApplied => value;
  @override
  SelectFrenchLanguage clear() => const SelectFrenchLanguage();

  @override
  Filter get filter => Filter.selectFrenchLanguage;

  @override
  String get chipTitle => LanguagesListFilter.french.langKey;

  @override
  SelectFrenchLanguage copyWith(bool? value) {
    return SelectFrenchLanguage(value: value ?? super.value);
  }

  @override
  List<dynamic> get filterValueForQuery =>
      [LanguagesListFilter.french.filterValueName];

  @override
  List<String> get filterKeyForQuery => ["filter_by_language"];
}

class SelectGermanLanguage extends FilterItem<bool> {
  const SelectGermanLanguage({super.value = false});

  @override
  bool get isApplied => value;
  @override
  SelectGermanLanguage clear() => const SelectGermanLanguage();

  @override
  Filter get filter => Filter.selectGermanLanguage;

  @override
  String get chipTitle => LanguagesListFilter.german.langKey;

  @override
  SelectGermanLanguage copyWith(bool? value) {
    return SelectGermanLanguage(value: value ?? super.value);
  }

  @override
  List<dynamic> get filterValueForQuery =>
      [LanguagesListFilter.german.filterValueName];

  @override
  List<String> get filterKeyForQuery => ["filter_by_language"];
}

class TherapistGender extends FilterItem<TherapistGenderFilter?> {
  const TherapistGender({super.value});

  /// if the value is null then nothing chosen by user in the filter
  /// else it will be male or female
  @override
  bool get isApplied => value != null;
  @override
  TherapistGender clear() => const TherapistGender();

  @override
  Filter get filter => Filter.therapistGender;

  @override
  String get chipTitle => value == null ? "" : value!.langKey;

  @override
  TherapistGender copyWith(value) => TherapistGender(value: value);

  @override
  List<dynamic> get filterValueForQuery => [value!.filterValueName];

  @override
  List<String> get filterKeyForQuery => ["filter_by_gender"];
}

class TherapistAcceptsNewClients extends FilterItem<bool> {
  /// call with the initial value
  const TherapistAcceptsNewClients({super.value = false});

  /// the value is false then this filter is not applied
  @override
  bool get isApplied => value;
  @override
  TherapistAcceptsNewClients clear() =>
      const TherapistAcceptsNewClients(value: false);

  @override
  Filter get filter => Filter.therapistAcceptsNewClients;

  @override
  String get chipTitle => LangKeys.acceptsNewClients;

  @override
  TherapistAcceptsNewClients copyWith(value) =>
      TherapistAcceptsNewClients(value: value ?? super.value);

  @override
  List<bool> get filterValueForQuery => [value];

  @override
  List<String> get filterKeyForQuery => ["accept_new_client"];
}

class TherapistPrescribesMedication extends FilterItem<bool> {
  /// call with the initial value
  const TherapistPrescribesMedication({super.value = false});

  /// the value is false then this filter is not applied
  @override
  bool get isApplied => value;
  @override
  TherapistPrescribesMedication clear() =>
      const TherapistPrescribesMedication(value: false);

  @override
  Filter get filter => Filter.therapistPrescribesMedication;

  @override
  String get chipTitle => LangKeys.prescribesMedication;
  @override
  TherapistPrescribesMedication copyWith(value) =>
      TherapistPrescribesMedication(value: value ?? super.value);

  @override
  List<bool> get filterValueForQuery => [value];

  @override
  List<String> get filterKeyForQuery => ["filter_by_medication"];
}

class BookedWithBefore extends FilterItem<bool> {
  /// call with the initial value
  const BookedWithBefore({super.value = false});

  /// the value is false then this filter is not applied
  @override
  bool get isApplied => value;
  @override
  BookedWithBefore clear() => const BookedWithBefore(value: false);

  @override
  Filter get filter => Filter.bookedWithBefore;

  @override
  String get chipTitle => LangKeys.bookedWithBefore;
  @override
  BookedWithBefore copyWith(value) =>
      BookedWithBefore(value: value ?? super.value);

  @override
  List<dynamic> get filterValueForQuery => [""];

  @override
  List<String> get filterKeyForQuery => ["booked_with_before"];
}

class PreviouslyMatchedTherapist extends FilterItem<bool> {
  /// call with the initial value
  const PreviouslyMatchedTherapist({super.value = false});

  /// the value is false then this filter is not applied
  @override
  bool get isApplied => value;
  @override
  PreviouslyMatchedTherapist clear() =>
      const PreviouslyMatchedTherapist(value: false);

  @override
  Filter get filter => Filter.previouslyMatchedTherapist;

  @override
  String get chipTitle => LangKeys.previouslyMatchedTherapist;

  @override
  PreviouslyMatchedTherapist copyWith(value) =>
      PreviouslyMatchedTherapist(value: value ?? super.value);

  @override
  List<dynamic> get filterValueForQuery => [""];

  @override
  List<String> get filterKeyForQuery => [""];
}
