import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:o7therapy/api/models/intake_form/corporate_mental_health.dart';
import 'package:o7therapy/api/models/intake_form/emergency_contact_details.dart';
import 'package:o7therapy/api/models/intake_form/family_history.dart';
import 'package:o7therapy/api/models/intake_form/general_information.dart';
import 'package:o7therapy/api/models/intake_form/medical_and_psychological_history.dart';
import 'package:o7therapy/api/models/intake_form/personal_information.dart';

class IntakeForm {
  final PersonalInformation personalInformation;
  final CorporateMentalHealth corporateMentalHealth;
  final EmergencyContactDetails emergencyContactDetails;
  final FamilyHistory familyHistory;
  final List<String>? describeYourSituationList;
  final GeneralInformation generalInformation;
  final MedicalAndPsychologicalHistory medicalAndPsychologicalHistory;

  const IntakeForm({
    required this.personalInformation,
    required this.corporateMentalHealth,
    required this.emergencyContactDetails,
    required this.familyHistory,
    required this.describeYourSituationList,
    required this.generalInformation,
    required this.medicalAndPsychologicalHistory,
  });

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    result.addAll({'personalInformation': personalInformation.toMap()});
    result.addAll({'corporateMentalHealth': corporateMentalHealth.toMap()});
    result.addAll({'emergencyContactDetails': emergencyContactDetails.toMap()});
    result.addAll({'familyHistory': familyHistory.toMap()});
    if (describeYourSituationList != null) {
      result.addAll({'describeYourSituationList': describeYourSituationList});
    }
    result.addAll({'generalInformation': generalInformation.toMap()});
    result.addAll({
      'medicalAndPsychologicalHistory': medicalAndPsychologicalHistory.toMap()
    });

    return result;
  }

  IntakeForm copyWith({
    PersonalInformation? personalInformation,
    CorporateMentalHealth? corporateMentalHealth,
    EmergencyContactDetails? emergencyContactDetails,
    FamilyHistory? familyHistory,
    List<String>? describeYourSituationList,
    GeneralInformation? generalInformation,
    MedicalAndPsychologicalHistory? medicalAndPsychologicalHistory,
  }) {
    return IntakeForm(
      personalInformation: personalInformation ?? this.personalInformation,
      corporateMentalHealth:
          corporateMentalHealth ?? this.corporateMentalHealth,
      emergencyContactDetails:
          emergencyContactDetails ?? this.emergencyContactDetails,
      familyHistory: familyHistory ?? this.familyHistory,
      describeYourSituationList:
          describeYourSituationList ?? this.describeYourSituationList,
      generalInformation: generalInformation ?? this.generalInformation,
      medicalAndPsychologicalHistory:
          medicalAndPsychologicalHistory ?? this.medicalAndPsychologicalHistory,
    );
  }

  factory IntakeForm.fromMap(Map<String, dynamic> map) {
    return IntakeForm(
      personalInformation:
          PersonalInformation.fromMap(map['personalInformation']),
      corporateMentalHealth:
          CorporateMentalHealth.fromMap(map['corporateMentalHealth']),
      emergencyContactDetails:
          EmergencyContactDetails.fromMap(map['emergencyContactDetails']),
      familyHistory: FamilyHistory.fromMap(map['familyHistory']),
      describeYourSituationList:
          List<String>.from(map['describeYourSituationList']),
      generalInformation: GeneralInformation.fromMap(map['generalInformation']),
      medicalAndPsychologicalHistory: MedicalAndPsychologicalHistory.fromMap(
          map['medicalAndPsychologicalHistory']),
    );
  }

  String toJson() => json.encode(toMap());

  factory IntakeForm.fromJson(String source) =>
      IntakeForm.fromMap(json.decode(source));

  @override
  String toString() {
    return 'IntakeForm(personalInformation: $personalInformation, corporateMentalHealth: $corporateMentalHealth, emergencyContactDetails: $emergencyContactDetails, familyHistory: $familyHistory, describeYourSituationList: $describeYourSituationList, generalInformation: $generalInformation, medicalAndPsychologicalHistory: $medicalAndPsychologicalHistory)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is IntakeForm &&
        other.personalInformation == personalInformation &&
        other.corporateMentalHealth == corporateMentalHealth &&
        other.emergencyContactDetails == emergencyContactDetails &&
        other.familyHistory == familyHistory &&
        listEquals(
            other.describeYourSituationList, describeYourSituationList) &&
        other.generalInformation == generalInformation &&
        other.medicalAndPsychologicalHistory == medicalAndPsychologicalHistory;
  }

  @override
  int get hashCode {
    return personalInformation.hashCode ^
        corporateMentalHealth.hashCode ^
        emergencyContactDetails.hashCode ^
        familyHistory.hashCode ^
        describeYourSituationList.hashCode ^
        generalInformation.hashCode ^
        medicalAndPsychologicalHistory.hashCode;
  }
}
