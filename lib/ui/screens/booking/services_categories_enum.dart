import 'package:o7therapy/util/lang/app_localization_keys.dart';

enum ServicesCategories {
  oneOnOneSessions(
    translatedKey: LangKeys.on1Sessions,
  ),
  groupTherapy(
    translatedKey: LangKeys.groupTherapy,
  ),
  workshops(
    translatedKey: LangKeys.workshops,
  );

  const ServicesCategories({required this.translatedKey});
  final String translatedKey;
}
