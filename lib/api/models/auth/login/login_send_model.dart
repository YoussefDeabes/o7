import 'package:o7therapy/api/api_keys.dart';

class LoginSendModel {
  String? userEmail;
  String? password;
  final String clientId = 'Xamarin';
  final String clientSecret = ApiKeys.appSecret;
  final String grantType = 'password';

  LoginSendModel({this.userEmail, this.password});

  Map toMap() {
    return {
      "username": userEmail,
      "password": password,
      "client_id": clientId,
      "client_secret": clientSecret,
      "grant_type": grantType,
    };
  }
}
