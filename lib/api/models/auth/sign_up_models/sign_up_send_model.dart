import 'dart:developer';

import 'package:intl/intl.dart';
import 'package:o7therapy/util/extensions/string_extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/extensions/extensions.dart';

enum Gender { male, female, other, preferNotToSay }

enum Goals {
  decreaseAnxiety(backEndId: 1, translatedName: LangKeys.decreaseAnxiety),
  sleepBetter(backEndId: 3, translatedName: LangKeys.sleepBetter),
  findGuidance(backEndId: 4, translatedName: LangKeys.findGuidance),
  feelHappier(backEndId: 5, translatedName: LangKeys.feelHappier),
  liveHealthier(backEndId: 6, translatedName: LangKeys.liveHealthier),
  thinkPositivity(backEndId: 7, translatedName: LangKeys.thinkPositivity),
  recover(backEndId: 8, translatedName: LangKeys.recover),
  findPeace(backEndId: 9, translatedName: LangKeys.findPeace),
  improveRelationships(
      backEndId: 10, translatedName: LangKeys.improveRelationships);

  const Goals({required this.translatedName, required this.backEndId});
  final String translatedName;
  final int backEndId;
}

class SignUpSendModel {
  static final DateTime _now = DateTime.now();

  // year , month , day
  final DateTime _dateTimeBefore18Years;

  String? name;
  Gender? gender;
  DateTime? birthDate;
  List<Goals> goals = [];
  String? email;
  String? password;
  // String? phoneNumber;

  SignUpSendModel()
      : _dateTimeBefore18Years = DateTime(
          _now.year - 18,
          _now.month,
          _now.day - 1,
        );

  bool isOlderThan18Years() {
    log('_dateTimeBefore18Years $_dateTimeBefore18Years');
    return birthDate!.isBefore(_dateTimeBefore18Years);
  }

  DateTime get getDateTimeBefore18Years => _dateTimeBefore18Years;

  Map toMap() {
    return {
      "name": name,
      "email": email,
      "date_of_birth": DateFormat('yyyyMMddHHmmss').format(birthDate!),
      "gender": gender?.name.capitalizedFirstChar(),
      "password": password,
      "account_type": "Adult",
      "guardian_name": null,
      "guardian_date_of_birth": null,
      "guardian_gender": null,
      "guardian_relationship": null,
      "company_code": null,
      "goals": goals.map((goal) => goal.backEndId).toList(), // list of int
      // "phone_number": phoneNumber,
    };
  }
}
