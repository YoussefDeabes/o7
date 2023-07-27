class ChangePasswordSendModel {
  String? currentPassword;
  String? newPassword;
  String? userId;

  ChangePasswordSendModel(
      {this.currentPassword, this.newPassword, this.userId});

  Map toMap() {
    return {
      "current_password": currentPassword,
      "new_password": newPassword,
      "user_id": userId,
    };
  }
}
