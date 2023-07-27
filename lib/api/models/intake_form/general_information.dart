import 'dart:convert';

class GeneralInformation {
  final String? seekingHelpAnswer;
  final String? beenGoingOnAnswer;
  final String? comeAtTimeAnswer;
  final String? difficultiesCopeAnswer;
  final String? treatmentGoalsAnswer;
  final String? receivedMentalHealthSupportAnswer;
  final String? typeOfTreatmentAnswer;
  final String? datesOfPreviousTreatmentAnswer;

  const GeneralInformation({
    this.seekingHelpAnswer,
    this.beenGoingOnAnswer,
    this.comeAtTimeAnswer,
    this.difficultiesCopeAnswer,
    this.treatmentGoalsAnswer,
    this.receivedMentalHealthSupportAnswer,
    this.typeOfTreatmentAnswer,
    this.datesOfPreviousTreatmentAnswer,
  });

  GeneralInformation copyWith({
    String? seekingHelpAnswer,
    String? beenGoingOnAnswer,
    String? comeAtTimeAnswer,
    String? difficultiesCopeAnswer,
    String? treatmentGoalsAnswer,
    String? receivedMentalHealthSupportAnswer,
    String? typeOfTreatmentAnswer,
    String? datesOfPreviousTreatmentAnswer,
  }) {
    return GeneralInformation(
      seekingHelpAnswer: seekingHelpAnswer ?? this.seekingHelpAnswer,
      beenGoingOnAnswer: beenGoingOnAnswer ?? this.beenGoingOnAnswer,
      comeAtTimeAnswer: comeAtTimeAnswer ?? this.comeAtTimeAnswer,
      difficultiesCopeAnswer:
          difficultiesCopeAnswer ?? this.difficultiesCopeAnswer,
      treatmentGoalsAnswer: treatmentGoalsAnswer ?? this.treatmentGoalsAnswer,
      receivedMentalHealthSupportAnswer: receivedMentalHealthSupportAnswer ??
          this.receivedMentalHealthSupportAnswer,
      typeOfTreatmentAnswer:
          typeOfTreatmentAnswer ?? this.typeOfTreatmentAnswer,
      datesOfPreviousTreatmentAnswer:
          datesOfPreviousTreatmentAnswer ?? this.datesOfPreviousTreatmentAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (seekingHelpAnswer != null) {
      result.addAll({'seekingHelpAnswer': seekingHelpAnswer});
    }
    if (beenGoingOnAnswer != null) {
      result.addAll({'beenGoingOnAnswer': beenGoingOnAnswer});
    }
    if (comeAtTimeAnswer != null) {
      result.addAll({'comeAtTimeAnswer': comeAtTimeAnswer});
    }
    if (difficultiesCopeAnswer != null) {
      result.addAll({'difficultiesCopeAnswer': difficultiesCopeAnswer});
    }
    if (treatmentGoalsAnswer != null) {
      result.addAll({'treatmentGoalsAnswer': treatmentGoalsAnswer});
    }
    if (receivedMentalHealthSupportAnswer != null) {
      result.addAll({
        'receivedMentalHealthSupportAnswer': receivedMentalHealthSupportAnswer
      });
    }
    if (typeOfTreatmentAnswer != null) {
      result.addAll({'typeOfTreatmentAnswer': typeOfTreatmentAnswer});
    }
    if (datesOfPreviousTreatmentAnswer != null) {
      result.addAll(
          {'datesOfPreviousTreatmentAnswer': datesOfPreviousTreatmentAnswer});
    }

    return result;
  }

  factory GeneralInformation.fromMap(Map<String, dynamic> map) {
    return GeneralInformation(
      seekingHelpAnswer: map['seekingHelpAnswer'],
      beenGoingOnAnswer: map['beenGoingOnAnswer'],
      comeAtTimeAnswer: map['comeAtTimeAnswer'],
      difficultiesCopeAnswer: map['difficultiesCopeAnswer'],
      treatmentGoalsAnswer: map['treatmentGoalsAnswer'],
      receivedMentalHealthSupportAnswer:
          map['receivedMentalHealthSupportAnswer'],
      typeOfTreatmentAnswer: map['typeOfTreatmentAnswer'],
      datesOfPreviousTreatmentAnswer: map['datesOfPreviousTreatmentAnswer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory GeneralInformation.fromJson(String source) =>
      GeneralInformation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'GeneralInformation(seekingHelpAnswer: $seekingHelpAnswer, beenGoingOnAnswer: $beenGoingOnAnswer, comeAtTimeAnswer: $comeAtTimeAnswer, difficultiesCopeAnswer: $difficultiesCopeAnswer, treatmentGoalsAnswer: $treatmentGoalsAnswer, receivedMentalHealthSupportAnswer: $receivedMentalHealthSupportAnswer, typeOfTreatmentAnswer: $typeOfTreatmentAnswer, datesOfPreviousTreatmentAnswer: $datesOfPreviousTreatmentAnswer)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is GeneralInformation &&
        other.seekingHelpAnswer == seekingHelpAnswer &&
        other.beenGoingOnAnswer == beenGoingOnAnswer &&
        other.comeAtTimeAnswer == comeAtTimeAnswer &&
        other.difficultiesCopeAnswer == difficultiesCopeAnswer &&
        other.treatmentGoalsAnswer == treatmentGoalsAnswer &&
        other.receivedMentalHealthSupportAnswer ==
            receivedMentalHealthSupportAnswer &&
        other.typeOfTreatmentAnswer == typeOfTreatmentAnswer &&
        other.datesOfPreviousTreatmentAnswer == datesOfPreviousTreatmentAnswer;
  }

  @override
  int get hashCode {
    return seekingHelpAnswer.hashCode ^
        beenGoingOnAnswer.hashCode ^
        comeAtTimeAnswer.hashCode ^
        difficultiesCopeAnswer.hashCode ^
        treatmentGoalsAnswer.hashCode ^
        receivedMentalHealthSupportAnswer.hashCode ^
        typeOfTreatmentAnswer.hashCode ^
        datesOfPreviousTreatmentAnswer.hashCode;
  }
}
