import 'dart:convert';

class PersonalInformation {
  final String? fullName;
  final String? dateOfBirth;
  final String? gender;
  final String? primaryPhoneNumberCode;
  final String? primaryPhoneNumber;
  final String? secondaryPhoneNumberCode;
  final String? secondaryPhoneNumber;
  final String? email;
  final String? highestEducationalLevel;
  final String? occupation;
  final String? relationshipStatus;
  final String? home;

  PersonalInformation({
    this.fullName,
    this.dateOfBirth,
    this.gender,
    this.primaryPhoneNumberCode,
    this.primaryPhoneNumber,
    this.secondaryPhoneNumberCode,
    this.secondaryPhoneNumber,
    this.email,
    this.highestEducationalLevel,
    this.occupation,
    this.relationshipStatus,
    this.home,
  });

  PersonalInformation copyWith({
    String? fullName,
    String? dateOfBirth,
    String? gender,
    String? primaryPhoneNumberCode,
    String? primaryPhoneNumber,
    String? secondaryPhoneNumberCode,
    String? secondaryPhoneNumber,
    String? email,
    String? highestEducationalLevel,
    String? occupation,
    String? relationshipStatus,
    String? home,
  }) {
    return PersonalInformation(
      fullName: fullName ?? this.fullName,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      primaryPhoneNumberCode:
          primaryPhoneNumberCode ?? this.primaryPhoneNumberCode,
      primaryPhoneNumber: primaryPhoneNumber ?? this.primaryPhoneNumber,
      secondaryPhoneNumberCode:
          secondaryPhoneNumberCode ?? this.secondaryPhoneNumberCode,
      secondaryPhoneNumber: secondaryPhoneNumber ?? this.secondaryPhoneNumber,
      email: email ?? this.email,
      highestEducationalLevel:
          highestEducationalLevel ?? this.highestEducationalLevel,
      occupation: occupation ?? this.occupation,
      relationshipStatus: relationshipStatus ?? this.relationshipStatus,
      home: home ?? this.home,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (fullName != null) {
      result.addAll({'fullName': fullName});
    }
    if (dateOfBirth != null) {
      result.addAll({'dateOfBirth': dateOfBirth});
    }
    if (gender != null) {
      result.addAll({'gender': gender});
    }
    if (primaryPhoneNumberCode != null) {
      result.addAll({'primaryPhoneNumberCode': primaryPhoneNumberCode});
    }
    if (primaryPhoneNumber != null) {
      result.addAll({'primaryPhoneNumber': primaryPhoneNumber});
    }
    if (secondaryPhoneNumberCode != null) {
      result.addAll({'secondaryPhoneNumberCode': secondaryPhoneNumberCode});
    }
    if (secondaryPhoneNumber != null) {
      result.addAll({'secondaryPhoneNumber': secondaryPhoneNumber});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (highestEducationalLevel != null) {
      result.addAll({'highestEducationalLevel': highestEducationalLevel});
    }
    if (occupation != null) {
      result.addAll({'occupation': occupation});
    }
    if (relationshipStatus != null) {
      result.addAll({'relationshipStatus': relationshipStatus});
    }
    if (home != null) {
      result.addAll({'home': home});
    }

    return result;
  }

  factory PersonalInformation.fromMap(Map<String, dynamic> map) {
    return PersonalInformation(
      fullName: map['fullName'],
      dateOfBirth: map['dateOfBirth'],
      gender: map['gender'],
      primaryPhoneNumberCode: map['primaryPhoneNumberCode'],
      primaryPhoneNumber: map['primaryPhoneNumber'],
      secondaryPhoneNumberCode: map['secondaryPhoneNumberCode'],
      secondaryPhoneNumber: map['secondaryPhoneNumber'],
      email: map['email'],
      highestEducationalLevel: map['highestEducationalLevel'],
      occupation: map['occupation'],
      relationshipStatus: map['relationshipStatus'],
      home: map['home'],
    );
  }

  String toJson() => json.encode(toMap());

  factory PersonalInformation.fromJson(String source) =>
      PersonalInformation.fromMap(json.decode(source));

  @override
  String toString() {
    return 'PersonalInformation(fullName: $fullName, dateOfBirth: $dateOfBirth, gender: $gender, primaryPhoneNumberCode: $primaryPhoneNumberCode, primaryPhoneNumber: $primaryPhoneNumber, secondaryPhoneNumberCode: $secondaryPhoneNumberCode, secondaryPhoneNumber: $secondaryPhoneNumber, email: $email, highestEducationalLevel: $highestEducationalLevel, occupation: $occupation, relationshipStatus: $relationshipStatus, home: $home)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PersonalInformation &&
        other.fullName == fullName &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        other.primaryPhoneNumberCode == primaryPhoneNumberCode &&
        other.primaryPhoneNumber == primaryPhoneNumber &&
        other.secondaryPhoneNumberCode == secondaryPhoneNumberCode &&
        other.secondaryPhoneNumber == secondaryPhoneNumber &&
        other.email == email &&
        other.highestEducationalLevel == highestEducationalLevel &&
        other.occupation == occupation &&
        other.relationshipStatus == relationshipStatus &&
        other.home == home;
  }

  @override
  int get hashCode {
    return fullName.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode ^
        primaryPhoneNumberCode.hashCode ^
        primaryPhoneNumber.hashCode ^
        secondaryPhoneNumberCode.hashCode ^
        secondaryPhoneNumber.hashCode ^
        email.hashCode ^
        highestEducationalLevel.hashCode ^
        occupation.hashCode ^
        relationshipStatus.hashCode ^
        home.hashCode;
  }
}
