class UpdateProfileSendModel {
  String? firstName;
  String? dateOfBirth;
  String? gender;
  String? phoneNumber;
  String? countryCode;
  String? secondaryEmail;
  String? guardianDateOfBirth;
  String? guardianGender;
  String? contactPersonEmail;
  String? operation;
  String? guardianName;
  String? guardianRelationship;
  String? education;
  String? work;
  int? numberOfKids;
  String? maritalStatus;
  String? contactPersonName;
  String? contactPersonRelationship;
  String? contactPersonPhoneNumber;
  String? contactPersonCountryCode;
  UpdateProfileSendModel({
    this.firstName,
    this.dateOfBirth,
    this.gender,
    this.phoneNumber,
    this.secondaryEmail,
    this.guardianRelationship,
    this.guardianName,
    this.operation,
    this.contactPersonEmail,
    this.guardianGender,
    this.guardianDateOfBirth,
    this.numberOfKids,
    this.work,
    this.maritalStatus,
    this.contactPersonName,
    this.contactPersonRelationship,
    this.contactPersonPhoneNumber,
    this.education,
    this.countryCode,
    this.contactPersonCountryCode,
  });
  Map updatePersonalInfoToMap() {
    return {
      "first_name": firstName,
      "date_of_birth": dateOfBirth,
      "gender": gender,
      "operation": operation,
    };
  }

  Map updateContactInfoToMap() {
    return {
      "phone_number": phoneNumber,
      "country_code": countryCode,
      "secondary_email": secondaryEmail,
      "operation": operation,
    };
  }

  Map updateEmergencyContactInfoToMap() {
    return {
      "contact_person_name": contactPersonName,
      "contact_person_phone_number": contactPersonPhoneNumber,
      "country_code": contactPersonCountryCode,
      "contact_person_email": contactPersonEmail,
      "contact_person_relationship": contactPersonRelationship,
      "operation": operation,
    };
  }
}
