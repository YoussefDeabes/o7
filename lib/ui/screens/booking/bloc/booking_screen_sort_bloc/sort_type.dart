import 'package:o7therapy/util/lang/app_localization_keys.dart';

enum SortType {
  earliestAvailable(
    langKey: LangKeys.earliestAvailable,
    attributeName: "Availability",
    direction: "Asc",
  ),
  priceHighToLow(
    langKey: LangKeys.priceHighToLow,
    attributeName: "Price",
    direction: "Desc",
  ),
  priceLowToHigh(
    langKey: LangKeys.priceLowToHigh,
    attributeName: "Price",
    direction: "Asc",
  ),
  yearsOfExperienceAscending(
    langKey: LangKeys.yearsOfExperienceAscending,
    attributeName: "PracticingSince",
    direction: "Asc",
  ),
  yearsOfExperienceDescending(
    langKey: LangKeys.yearsOfExperienceDescending,
    attributeName: "PracticingSince",
    direction: "Desc",
  ),
  topRating(
    langKey: LangKeys.topRating,
    attributeName: "Availability",
    direction: "Desc",
  );

  const SortType({
    required this.langKey,
    required this.attributeName,
    required this.direction,
  });

  final String attributeName;
  final String? langKey;
  final String direction;
}
