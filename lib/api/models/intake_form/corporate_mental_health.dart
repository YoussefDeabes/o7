import 'dart:convert';

import 'package:flutter/foundation.dart';

class CorporateMentalHealth {
  final String? lastYearWorkFeelAnswer;
  final String? lastYearFeelYourselfAnswer;
  final List<String>? experiencesStressorsAtWorkAnswerList;
  final List<String>? workStressInPersonalLifeAnswerList;
  final String? quittingYourJobAnswer;
  final String? quitJobNextSixMonthAnswer;
  final String? interestedPhysicalWellnessAnswer;
  final List<String>? mentalHealthSupportAnswerList;

  const CorporateMentalHealth({
    this.lastYearWorkFeelAnswer,
    this.lastYearFeelYourselfAnswer,
    this.experiencesStressorsAtWorkAnswerList,
    this.workStressInPersonalLifeAnswerList,
    this.quittingYourJobAnswer,
    this.quitJobNextSixMonthAnswer,
    this.interestedPhysicalWellnessAnswer,
    this.mentalHealthSupportAnswerList,
  });

  CorporateMentalHealth copyWith({
    String? lastYearWorkFeelAnswer,
    String? lastYearFeelYourselfAnswer,
    List<String>? experiencesStressorsAtWorkAnswerList,
    List<String>? workStressInPersonalLifeAnswerList,
    String? quittingYourJobAnswer,
    String? quitJobNextSixMonthAnswer,
    String? interestedPhysicalWellnessAnswer,
    List<String>? mentalHealthSupportAnswerList,
  }) {
    return CorporateMentalHealth(
      lastYearWorkFeelAnswer:
          lastYearWorkFeelAnswer ?? this.lastYearWorkFeelAnswer,
      lastYearFeelYourselfAnswer:
          lastYearFeelYourselfAnswer ?? this.lastYearFeelYourselfAnswer,
      experiencesStressorsAtWorkAnswerList:
          experiencesStressorsAtWorkAnswerList ??
              this.experiencesStressorsAtWorkAnswerList,
      workStressInPersonalLifeAnswerList: workStressInPersonalLifeAnswerList ??
          this.workStressInPersonalLifeAnswerList,
      quittingYourJobAnswer:
          quittingYourJobAnswer ?? this.quittingYourJobAnswer,
      quitJobNextSixMonthAnswer:
          quitJobNextSixMonthAnswer ?? this.quitJobNextSixMonthAnswer,
      interestedPhysicalWellnessAnswer: interestedPhysicalWellnessAnswer ??
          this.interestedPhysicalWellnessAnswer,
      mentalHealthSupportAnswerList:
          mentalHealthSupportAnswerList ?? this.mentalHealthSupportAnswerList,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (lastYearWorkFeelAnswer != null) {
      result.addAll({'lastYearWorkFeelAnswer': lastYearWorkFeelAnswer});
    }
    if (lastYearFeelYourselfAnswer != null) {
      result.addAll({'lastYearFeelYourselfAnswer': lastYearFeelYourselfAnswer});
    }
    if (experiencesStressorsAtWorkAnswerList != null) {
      result.addAll({
        'experiencesStressorsAtWorkAnswerList':
            experiencesStressorsAtWorkAnswerList
      });
    }
    if (workStressInPersonalLifeAnswerList != null) {
      result.addAll({
        'workStressInPersonalLifeAnswerList': workStressInPersonalLifeAnswerList
      });
    }
    if (quittingYourJobAnswer != null) {
      result.addAll({'quittingYourJobAnswer': quittingYourJobAnswer});
    }
    if (quitJobNextSixMonthAnswer != null) {
      result.addAll({'quitJobNextSixMonthAnswer': quitJobNextSixMonthAnswer});
    }
    if (interestedPhysicalWellnessAnswer != null) {
      result.addAll({
        'interestedPhysicalWellnessAnswer': interestedPhysicalWellnessAnswer
      });
    }
    if (mentalHealthSupportAnswerList != null) {
      result.addAll(
          {'mentalHealthSupportAnswerList': mentalHealthSupportAnswerList});
    }

    return result;
  }

  factory CorporateMentalHealth.fromMap(Map<String, dynamic> map) {
    return CorporateMentalHealth(
      lastYearWorkFeelAnswer: map['lastYearWorkFeelAnswer'],
      lastYearFeelYourselfAnswer: map['lastYearFeelYourselfAnswer'],
      experiencesStressorsAtWorkAnswerList:
          List<String>.from(map['experiencesStressorsAtWorkAnswerList']),
      workStressInPersonalLifeAnswerList:
          List<String>.from(map['workStressInPersonalLifeAnswerList']),
      quittingYourJobAnswer: map['quittingYourJobAnswer'],
      quitJobNextSixMonthAnswer: map['quitJobNextSixMonthAnswer'],
      interestedPhysicalWellnessAnswer: map['interestedPhysicalWellnessAnswer'],
      mentalHealthSupportAnswerList:
          List<String>.from(map['mentalHealthSupportAnswerList']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CorporateMentalHealth.fromJson(String source) =>
      CorporateMentalHealth.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CorporateMentalHealth(lastYearWorkFeelAnswer: $lastYearWorkFeelAnswer, lastYearFeelYourselfAnswer: $lastYearFeelYourselfAnswer, experiencesStressorsAtWorkAnswerList: $experiencesStressorsAtWorkAnswerList, workStressInPersonalLifeAnswerList: $workStressInPersonalLifeAnswerList, quittingYourJobAnswer: $quittingYourJobAnswer, quitJobNextSixMonthAnswer: $quitJobNextSixMonthAnswer, interestedPhysicalWellnessAnswer: $interestedPhysicalWellnessAnswer, mentalHealthSupportAnswerList: $mentalHealthSupportAnswerList)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CorporateMentalHealth &&
        other.lastYearWorkFeelAnswer == lastYearWorkFeelAnswer &&
        other.lastYearFeelYourselfAnswer == lastYearFeelYourselfAnswer &&
        listEquals(other.experiencesStressorsAtWorkAnswerList,
            experiencesStressorsAtWorkAnswerList) &&
        listEquals(other.workStressInPersonalLifeAnswerList,
            workStressInPersonalLifeAnswerList) &&
        other.quittingYourJobAnswer == quittingYourJobAnswer &&
        other.quitJobNextSixMonthAnswer == quitJobNextSixMonthAnswer &&
        other.interestedPhysicalWellnessAnswer ==
            interestedPhysicalWellnessAnswer &&
        listEquals(
            other.mentalHealthSupportAnswerList, mentalHealthSupportAnswerList);
  }

  @override
  int get hashCode {
    return lastYearWorkFeelAnswer.hashCode ^
        lastYearFeelYourselfAnswer.hashCode ^
        experiencesStressorsAtWorkAnswerList.hashCode ^
        workStressInPersonalLifeAnswerList.hashCode ^
        quittingYourJobAnswer.hashCode ^
        quitJobNextSixMonthAnswer.hashCode ^
        interestedPhysicalWellnessAnswer.hashCode ^
        mentalHealthSupportAnswerList.hashCode;
  }
}
