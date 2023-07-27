import 'dart:convert';

class MedicalAndPsychologicalHistory {
  final String? receivedPsychiatricMedicationsAnswer;
  final String? medicalConditionsAnswer;
  final String? currentlyOnMedicationAnswer;
  final String? thoughtsHarmingYourselfAnswer;
  final String? attemptedSuicideAnswer;
  final String? haveUrgesAnswer;

  const MedicalAndPsychologicalHistory({
    this.receivedPsychiatricMedicationsAnswer,
    this.medicalConditionsAnswer,
    this.currentlyOnMedicationAnswer,
    this.thoughtsHarmingYourselfAnswer,
    this.attemptedSuicideAnswer,
    this.haveUrgesAnswer,
  });

  MedicalAndPsychologicalHistory copyWith({
    String? receivedPsychiatricMedicationsAnswer,
    String? medicalConditionsAnswer,
    String? currentlyOnMedicationAnswer,
    String? thoughtsHarmingYourselfAnswer,
    String? attemptedSuicideAnswer,
    String? haveUrgesAnswer,
    List<String>? describeYourSituationList,
  }) {
    return MedicalAndPsychologicalHistory(
      receivedPsychiatricMedicationsAnswer:
          receivedPsychiatricMedicationsAnswer ??
              this.receivedPsychiatricMedicationsAnswer,
      medicalConditionsAnswer:
          medicalConditionsAnswer ?? this.medicalConditionsAnswer,
      currentlyOnMedicationAnswer:
          currentlyOnMedicationAnswer ?? this.currentlyOnMedicationAnswer,
      thoughtsHarmingYourselfAnswer:
          thoughtsHarmingYourselfAnswer ?? this.thoughtsHarmingYourselfAnswer,
      attemptedSuicideAnswer:
          attemptedSuicideAnswer ?? this.attemptedSuicideAnswer,
      haveUrgesAnswer: haveUrgesAnswer ?? this.haveUrgesAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (receivedPsychiatricMedicationsAnswer != null) {
      result.addAll({
        'receivedPsychiatricMedicationsAnswer':
            receivedPsychiatricMedicationsAnswer
      });
    }
    if (medicalConditionsAnswer != null) {
      result.addAll({'medicalConditionsAnswer': medicalConditionsAnswer});
    }
    if (currentlyOnMedicationAnswer != null) {
      result
          .addAll({'currentlyOnMedicationAnswer': currentlyOnMedicationAnswer});
    }
    if (thoughtsHarmingYourselfAnswer != null) {
      result.addAll(
          {'thoughtsHarmingYourselfAnswer': thoughtsHarmingYourselfAnswer});
    }
    if (attemptedSuicideAnswer != null) {
      result.addAll({'attemptedSuicideAnswer': attemptedSuicideAnswer});
    }
    if (haveUrgesAnswer != null) {
      result.addAll({'haveUrgesAnswer': haveUrgesAnswer});
    }

    return result;
  }

  factory MedicalAndPsychologicalHistory.fromMap(Map<String, dynamic> map) {
    return MedicalAndPsychologicalHistory(
      receivedPsychiatricMedicationsAnswer:
          map['receivedPsychiatricMedicationsAnswer'],
      medicalConditionsAnswer: map['medicalConditionsAnswer'],
      currentlyOnMedicationAnswer: map['currentlyOnMedicationAnswer'],
      thoughtsHarmingYourselfAnswer: map['thoughtsHarmingYourselfAnswer'],
      attemptedSuicideAnswer: map['attemptedSuicideAnswer'],
      haveUrgesAnswer: map['haveUrgesAnswer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory MedicalAndPsychologicalHistory.fromJson(String source) =>
      MedicalAndPsychologicalHistory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'MedicalAndPsychologicalHistory(receivedPsychiatricMedicationsAnswer: $receivedPsychiatricMedicationsAnswer, medicalConditionsAnswer: $medicalConditionsAnswer, currentlyOnMedicationAnswer: $currentlyOnMedicationAnswer, thoughtsHarmingYourselfAnswer: $thoughtsHarmingYourselfAnswer, attemptedSuicideAnswer: $attemptedSuicideAnswer, haveUrgesAnswer: $haveUrgesAnswer)';
  }
}
