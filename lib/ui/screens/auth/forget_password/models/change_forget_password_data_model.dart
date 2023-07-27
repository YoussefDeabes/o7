class ChangeForgetPasswordDataModel {
  String? code;
  String? newPassword;
  String? userEmail;

  ChangeForgetPasswordDataModel({
    this.code,
    this.newPassword,
    this.userEmail,
  });

  ChangeForgetPasswordDataModel copyWith({
    String? code,
    String? newPassword,
    String? userEmail,
  }) {
    return ChangeForgetPasswordDataModel(
      code: code ?? this.code,
      newPassword: newPassword ?? this.newPassword,
      userEmail: userEmail ?? this.userEmail,
    );
  }

  Map<String, dynamic> toQueryDataMap() {
    return <String, dynamic>{
      'code': code,
      'new_password': newPassword,
      'user_email': userEmail,
    };
  }

  @override
  String toString() =>
      'ChangeForgetPasswordDataModel(code: $code, newPassword: $newPassword, userEmail: $userEmail)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChangeForgetPasswordDataModel &&
        other.code == code &&
        other.newPassword == newPassword &&
        other.userEmail == userEmail;
  }

  @override
  int get hashCode => code.hashCode ^ newPassword.hashCode ^ userEmail.hashCode;
}
