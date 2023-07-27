import 'dart:convert';

class FamilyHistory {
  final String? fatherName;
  final String? fatherStatus;
  final String? motherName;
  final String? motherStatus;
  final String? parentsCurrentRelationship;
  final String? livingWithAnyoneOfParentsAnswer;
  final int? siblings;
  final String? isAnySiblingsPassedAway;
  final String? romanticRelationShip;
  final String? haveAnyChildrenOrDependents;
  final String? anyoneInFamilyHasMentalIllnessAnswer;
  final String? anythingElseToKnowAnswer;
  const FamilyHistory({
    this.fatherName,
    this.fatherStatus,
    this.motherName,
    this.motherStatus,
    this.parentsCurrentRelationship,
    this.livingWithAnyoneOfParentsAnswer,
    this.siblings,
    this.isAnySiblingsPassedAway,
    this.romanticRelationShip,
    this.haveAnyChildrenOrDependents,
    this.anyoneInFamilyHasMentalIllnessAnswer,
    this.anythingElseToKnowAnswer,
  });

  FamilyHistory copyWith({
    String? fatherName,
    String? fatherStatus,
    String? motherName,
    String? motherStatus,
    String? parentsCurrentRelationship,
    String? livingWithAnyoneOfParentsAnswer,
    int? siblings,
    String? isAnySiblingsPassedAway,
    String? romanticRelationShip,
    String? haveAnyChildrenOrDependents,
    String? anyoneInFamilyHasMentalIllnessAnswer,
    String? anythingElseToKnowAnswer,
  }) {
    return FamilyHistory(
      fatherName: fatherName ?? this.fatherName,
      fatherStatus: fatherStatus ?? this.fatherStatus,
      motherName: motherName ?? this.motherName,
      motherStatus: motherStatus ?? this.motherStatus,
      parentsCurrentRelationship:
          parentsCurrentRelationship ?? this.parentsCurrentRelationship,
      livingWithAnyoneOfParentsAnswer: livingWithAnyoneOfParentsAnswer ??
          this.livingWithAnyoneOfParentsAnswer,
      siblings: siblings ?? this.siblings,
      isAnySiblingsPassedAway:
          isAnySiblingsPassedAway ?? this.isAnySiblingsPassedAway,
      romanticRelationShip: romanticRelationShip ?? this.romanticRelationShip,
      haveAnyChildrenOrDependents:
          haveAnyChildrenOrDependents ?? this.haveAnyChildrenOrDependents,
      anyoneInFamilyHasMentalIllnessAnswer:
          anyoneInFamilyHasMentalIllnessAnswer ??
              this.anyoneInFamilyHasMentalIllnessAnswer,
      anythingElseToKnowAnswer:
          anythingElseToKnowAnswer ?? this.anythingElseToKnowAnswer,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (fatherName != null) {
      result.addAll({'fatherName': fatherName});
    }
    if (fatherStatus != null) {
      result.addAll({'fatherStatus': fatherStatus});
    }
    if (motherName != null) {
      result.addAll({'motherName': motherName});
    }
    if (motherStatus != null) {
      result.addAll({'motherStatus': motherStatus});
    }
    if (parentsCurrentRelationship != null) {
      result.addAll({'parentsCurrentRelationship': parentsCurrentRelationship});
    }
    if (livingWithAnyoneOfParentsAnswer != null) {
      result.addAll(
          {'livingWithAnyoneOfParentsAnswer': livingWithAnyoneOfParentsAnswer});
    }
    if (siblings != null) {
      result.addAll({'siblings': siblings});
    }
    if (isAnySiblingsPassedAway != null) {
      result.addAll({'isAnySiblingsPassedAway': isAnySiblingsPassedAway});
    }
    if (romanticRelationShip != null) {
      result.addAll({'romanticRelationShip': romanticRelationShip});
    }
    if (haveAnyChildrenOrDependents != null) {
      result
          .addAll({'haveAnyChildrenOrDependents': haveAnyChildrenOrDependents});
    }
    if (anyoneInFamilyHasMentalIllnessAnswer != null) {
      result.addAll({
        'anyoneInFamilyHasMentalIllnessAnswer':
            anyoneInFamilyHasMentalIllnessAnswer
      });
    }
    if (anythingElseToKnowAnswer != null) {
      result.addAll({'anythingElseToKnowAnswer': anythingElseToKnowAnswer});
    }

    return result;
  }

  factory FamilyHistory.fromMap(Map<String, dynamic> map) {
    return FamilyHistory(
      fatherName: map['fatherName'],
      fatherStatus: map['fatherStatus'],
      motherName: map['motherName'],
      motherStatus: map['motherStatus'],
      parentsCurrentRelationship: map['parentsCurrentRelationship'],
      livingWithAnyoneOfParentsAnswer: map['livingWithAnyoneOfParentsAnswer'],
      siblings: map['siblings']?.toInt(),
      isAnySiblingsPassedAway: map['isAnySiblingsPassedAway'],
      romanticRelationShip: map['romanticRelationShip'],
      haveAnyChildrenOrDependents: map['haveAnyChildrenOrDependents'],
      anyoneInFamilyHasMentalIllnessAnswer:
          map['anyoneInFamilyHasMentalIllnessAnswer'],
      anythingElseToKnowAnswer: map['anythingElseToKnowAnswer'],
    );
  }

  String toJson() => json.encode(toMap());

  factory FamilyHistory.fromJson(String source) =>
      FamilyHistory.fromMap(json.decode(source));

  @override
  String toString() {
    return 'FamilyHistory(fatherName: $fatherName, fatherStatus: $fatherStatus, motherName: $motherName, motherStatus: $motherStatus, parentsCurrentRelationship: $parentsCurrentRelationship, livingWithAnyoneOfParentsAnswer: $livingWithAnyoneOfParentsAnswer, siblings: $siblings, isAnySiblingsPassedAway: $isAnySiblingsPassedAway, romanticRelationShip: $romanticRelationShip, haveAnyChildrenOrDependents: $haveAnyChildrenOrDependents, anyoneInFamilyHasMentalIllnessAnswer: $anyoneInFamilyHasMentalIllnessAnswer, anythingElseToKnowAnswer: $anythingElseToKnowAnswer)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is FamilyHistory &&
        other.fatherName == fatherName &&
        other.fatherStatus == fatherStatus &&
        other.motherName == motherName &&
        other.motherStatus == motherStatus &&
        other.parentsCurrentRelationship == parentsCurrentRelationship &&
        other.livingWithAnyoneOfParentsAnswer ==
            livingWithAnyoneOfParentsAnswer &&
        other.siblings == siblings &&
        other.isAnySiblingsPassedAway == isAnySiblingsPassedAway &&
        other.romanticRelationShip == romanticRelationShip &&
        other.haveAnyChildrenOrDependents == haveAnyChildrenOrDependents &&
        other.anyoneInFamilyHasMentalIllnessAnswer ==
            anyoneInFamilyHasMentalIllnessAnswer &&
        other.anythingElseToKnowAnswer == anythingElseToKnowAnswer;
  }

  @override
  int get hashCode {
    return fatherName.hashCode ^
        fatherStatus.hashCode ^
        motherName.hashCode ^
        motherStatus.hashCode ^
        parentsCurrentRelationship.hashCode ^
        livingWithAnyoneOfParentsAnswer.hashCode ^
        siblings.hashCode ^
        isAnySiblingsPassedAway.hashCode ^
        romanticRelationShip.hashCode ^
        haveAnyChildrenOrDependents.hashCode ^
        anyoneInFamilyHasMentalIllnessAnswer.hashCode ^
        anythingElseToKnowAnswer.hashCode;
  }
}
