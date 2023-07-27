// enum ProfileGender { Male, Female, Other }

// enum PatientAccountType { Adult, Child, Couple }

// enum GuardianRelationships { Father, Mother, Brother, Sister, Relative, Other }

// enum MaritalStatus { Single, Engaged, Married, Divorced, Separated, Widow }

// enum Relationships {
//   Father,
//   Mother,
//   Brother,
//   Sister,
//   Son,
//   Daughter,
//   Relative,
//   Friend,
//   Other
// }

class MyProfileWrapper {
  MyProfileWrapper({
    required this.data,
    required this.errorCode,
    required this.errorMsg,
    required this.errorDetails,
    required this.expiration,
    required this.persistence,
    required this.totalSeconds,
  });

  final UserProfileInfo? data;
  final int? errorCode;
  final String? errorMsg;
  final String? errorDetails;
  final Expiration? expiration;
  final Persistence? persistence;
  final int? totalSeconds;

  factory MyProfileWrapper.fromJson(Map<String, dynamic> json) =>
      MyProfileWrapper(
        data: json["data"] != null
            ? UserProfileInfo.fromJson(json["data"])
            : null,
        errorCode: json["error_code"],
        errorMsg: json["error_msg"],
        errorDetails: json["error_details"],
        expiration: json['expiration'] != null
            ? Expiration.fromJson(json['expiration'])
            : null,
        persistence: json['persistence'] != null
            ? Persistence.fromJson(json['persistence'])
            : null,
        totalSeconds: json["total_seconds"],
      );

  Map<String, dynamic> toJson() => {
        "data": data?.toJson(),
        "error_code": errorCode,
        "error_msg": errorMsg,
        "error_details": errorDetails,
        "expiration": expiration?.toJson(),
        "persistence": persistence?.toJson(),
        "total_seconds": totalSeconds,
      };
}

class UserProfileInfo {
  UserProfileInfo({
    required this.id,
    required this.name,
    required this.email,
    required this.secondaryEmail,
    required this.dateOfBirth,
    required this.gender,
    required this.accountType,
    required this.guardianDateOfBirth,
    required this.guardianGender,
    required this.guardianName,
    required this.guardianRelationship,
    required this.education,
    required this.work,
    required this.phoneNumber,
    required this.numberOfKids,
    required this.maritalStatus,
    required this.contactPersonName,
    required this.contactPersonPhoneNumber,
    required this.contactPersonEmail,
    required this.contactPersonRelationship,
    required this.isIntakeFormSubmitted,
    required this.cappingBalance,
  });

  final String? id;
  final String? name;
  final String? email;
  final String? secondaryEmail;
  final String? dateOfBirth;
  final int? gender;
  final int? accountType;
  final String? guardianDateOfBirth;
  final int? guardianGender;
  final String? guardianName;
  final int? guardianRelationship;
  final String? education;
  final String? work;
  final String? phoneNumber;
  final int? numberOfKids;
  final int? maritalStatus;
  final String? contactPersonName;
  final String? contactPersonPhoneNumber;
  final String? contactPersonEmail;
  final int? contactPersonRelationship;
  final bool? isIntakeFormSubmitted;
  final int? cappingBalance;
  factory UserProfileInfo.fromJson(Map<String, dynamic> json) =>
      UserProfileInfo(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        secondaryEmail: json["secondary_email"],
        dateOfBirth: json["date_of_birth"],
        gender: json["gender"],
        accountType: json["account_type"],
        guardianDateOfBirth: json["guardian_date_of_birth"],
        guardianGender: json["guardian_gender"],
        guardianName: json["guardian_name"],
        guardianRelationship: json["guardian_relationship"],
        education: json["education"],
        work: json["work"],
        phoneNumber: json["phone_number"],
        numberOfKids: json["number_of_kids"],
        maritalStatus: json["marital_status"],
        contactPersonName: json["contact_person_name"],
        contactPersonEmail: json["contact_person_email"],
        contactPersonPhoneNumber: json["contact_person_phone_number"],
        contactPersonRelationship: json["contact_person_relationship"],
        isIntakeFormSubmitted: json["is_intake_form_submitted"],
        cappingBalance: json["capping_balance"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "secondary_email": secondaryEmail,
        "date_of_birth": dateOfBirth,
        "gender": gender,
        "account_type": accountType,
        "guardian_date_of_birth": guardianDateOfBirth,
        "guardian_gender": guardianGender,
        "guardian_name": guardianName,
        "guardian_relationship": guardianRelationship,
        "education": education,
        "work": work,
        "phone_number": phoneNumber,
        "number_of_kids": numberOfKids,
        // "marital_status": maritalStatus,
        "contact_person_name": contactPersonName,
        "contact_person_phone_number": contactPersonPhoneNumber,
        "contact_person_email": contactPersonEmail,
        "contact_person_relationship": contactPersonRelationship,
        "is_intake_form_submitted": isIntakeFormSubmitted,
        "capping_balance": cappingBalance,
      };
}

class Expiration {
  Expiration({
    required this.isAllowed,
    required this.duration,
    required this.method,
    required this.mode,
    required this.isSessionExpiry,
  });

  final bool? isAllowed;
  final int? duration;
  final int? method;
  final int? mode;
  final bool? isSessionExpiry;

  factory Expiration.fromJson(Map<String, dynamic> json) => Expiration(
        isAllowed: json["is_allowed"],
        duration: json["duration"],
        method: json["method"],
        mode: json["mode"],
        isSessionExpiry: json["is_session_expiry"],
      );

  Map<String, dynamic> toJson() => {
        "is_allowed": isAllowed,
        "duration": duration,
        "method": method,
        "mode": mode,
        "is_session_expiry": isSessionExpiry,
      };
}

class Persistence {
  Persistence({
    required this.scope,
    required this.isEncrypted,
  });

  final int? scope;
  final bool? isEncrypted;

  factory Persistence.fromJson(Map<String, dynamic> json) => Persistence(
        scope: json["scope"],
        isEncrypted: json["is_encrypted"],
      );

  Map<String, dynamic> toJson() => {
        "scope": scope,
        "is_encrypted": isEncrypted,
      };
}
