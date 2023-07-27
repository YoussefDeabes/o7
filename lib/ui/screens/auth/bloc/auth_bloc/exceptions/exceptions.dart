// class NameException implements Exception {
//   String get mainMessage => "Name Exception!";
//   final String detailedMsg;
//   const NameException({this.detailedMsg = ""}) : super( );
// }

import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// all exceptions that might happened while user sign up
enum SignUpCustomExceptions {
  nameException(
    mainMessage: "Name Exception!",
    detailedMsg: LangKeys.nameNicknameEmptyErr,
  ),
  noGenderException(
    mainMessage: "Gender Exception!",
    detailedMsg: LangKeys.enterYourGender,
  ),
  noAgeEnteredException(
    mainMessage: "Age Exception!",
    detailedMsg: LangKeys.enterYourAge,
  ),
  kidException(
    mainMessage: "Age Exception!",
    detailedMsg: LangKeys.smallUser,
  ),

  emailEmptyException(
    mainMessage: "Mail Exception!",
    detailedMsg: LangKeys.emailEmptyErr,
  ),

  emailFormattedException(
    mainMessage: "Mail Exception!",
    detailedMsg: LangKeys.invalidEmail,
  ),

  passwordEmptyException(
    mainMessage: "Password Exception!",
    detailedMsg: LangKeys.passwordEmptyErr,
  ),
  passwordFormattedException(
    mainMessage: "Password Exception!",
    detailedMsg: LangKeys.invalidPassword,
  ),

  passwordNoMatchedException(
    mainMessage: "Password Exception!",
    detailedMsg: "Sorry,You are too small to use the app!",
  ),

  networkError(
    mainMessage: "Password Exception!",
    detailedMsg: "Sorry,You are too small to use the app!",
  );

  const SignUpCustomExceptions(
      {required this.mainMessage, required this.detailedMsg});

  final String mainMessage;
  final String detailedMsg;
}
