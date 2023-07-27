import 'dart:convert';

class EmergencyContactDetails {
  final String? name;
  final String? email;
  final String? phoneNumberCode;
  final String? phoneNumber;
  final String? relationship;
  const EmergencyContactDetails({
    this.name,
    this.email,
    this.phoneNumberCode,
    this.phoneNumber,
    this.relationship,
  });

  EmergencyContactDetails copyWith({
    String? name,
    String? email,
    String? phoneNumberCode,
    String? phoneNumber,
    String? relationship,
  }) {
    return EmergencyContactDetails(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumberCode: phoneNumberCode ?? this.phoneNumberCode,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      relationship: relationship ?? this.relationship,
    );
  }

  Map<String, dynamic> toMap() {
    final result = <String, dynamic>{};

    if (name != null) {
      result.addAll({'name': name});
    }
    if (email != null) {
      result.addAll({'email': email});
    }
    if (phoneNumberCode != null) {
      result.addAll({'phoneNumberCode': phoneNumberCode});
    }
    if (phoneNumber != null) {
      result.addAll({'phoneNumber': phoneNumber});
    }
    if (relationship != null) {
      result.addAll({'relationship': relationship});
    }

    return result;
  }

  factory EmergencyContactDetails.fromMap(Map<String, dynamic> map) {
    return EmergencyContactDetails(
      name: map['name'],
      email: map['email'],
      phoneNumberCode: map['phoneNumberCode'],
      phoneNumber: map['phoneNumber'],
      relationship: map['relationship'],
    );
  }

  String toJson() => json.encode(toMap());

  factory EmergencyContactDetails.fromJson(String source) =>
      EmergencyContactDetails.fromMap(json.decode(source));

  @override
  String toString() {
    return 'EmergencyContactDetails(name: $name, email: $email, phoneNumberCode: $phoneNumberCode, phoneNumber: $phoneNumber, relationship: $relationship)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is EmergencyContactDetails &&
        other.name == name &&
        other.email == email &&
        other.phoneNumberCode == phoneNumberCode &&
        other.phoneNumber == phoneNumber &&
        other.relationship == relationship;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        email.hashCode ^
        phoneNumberCode.hashCode ^
        phoneNumber.hashCode ^
        relationship.hashCode;
  }
}
