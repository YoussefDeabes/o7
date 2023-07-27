import 'dart:developer';

import 'package:o7therapy/util/lang/app_localization_keys.dart';

enum Gender { male, female, preferNotToSay, other }

enum Goals {
  decreaseAnxiety(translatedName: LangKeys.decreaseAnxiety),
  betterSleeping(translatedName: LangKeys.betterSleeping),
  thinkPositivity(translatedName: LangKeys.thinkPositivity),
  feelHappier(translatedName: LangKeys.feelHappier),
  liveHealthier(translatedName: LangKeys.liveHealthier),
  improveSocialSkills(translatedName: LangKeys.improveSocialSkills);

  const Goals({required this.translatedName});
  final String translatedName;
}

class SignUpModel {
  static final DateTime _now = DateTime.now();

  // year , month , day
  final DateTime _dateTimeBefore18Years;

  String? name;
  Gender? gender;
  DateTime? birthDate;
  List<Goals> goals = [];
  String? email;
  String? password;

  SignUpModel() : _dateTimeBefore18Years = DateTime(_now.year - 18);

  bool isOlderThan18Years() {
    log('_dateTimeBefore18Years $_dateTimeBefore18Years');
    return birthDate!.isBefore(_dateTimeBefore18Years);
  }

  DateTime get getDateTimeBefore18Years => _dateTimeBefore18Years;
}
