import 'package:o7therapy/util/lang/app_localization_keys.dart';

enum GuestTherapistProfileCategories {
  bio(translatedKey: LangKeys.bio),
  schedule(translatedKey: LangKeys.schedule);

  const GuestTherapistProfileCategories({required this.translatedKey});

  final String translatedKey;
}
