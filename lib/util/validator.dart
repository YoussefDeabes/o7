import 'package:o7therapy/util/extensions/string_extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class Validator {
  /// returns true if the text is null or the text is empty
  /// returns false if there is a value
  static bool isEmptyOrNull(String? txt) {
    return (txt != null && txt.isNotEmpty) ? false : true;
  }

  static bool isEmail(String email) {
    const String pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    var regExp = RegExp(pattern);
    return regExp.hasMatch(email.trim());
  }

  static bool isPassword(String password) {
    /// if password length less than 8 then the password not valid
    if (isLessThan8Characters(password)) {
      return false;
    } else if (!isContainNumber(password)) {
      /// password not contains numbers
      return false;
    } else if (!isContainUpperCase(password)) {
      ///  password not contains UpperCase letters
      return false;
    } else if (!isContainLowerCase(password)) {
      ///  password not contains LowerCase letters
      return false;
    } else if (!isContainSpecialCharacter(password)) {
      ///  password not contains Special Characters
      return false;
    }
    return true;
  }

  static bool isPasswordMatched(String password, String confirmPassword) {
    return password == confirmPassword;
  }

  static bool isCode(String password) {
    return password.length >= 4;
  }

  static bool isNumber(String number) {
    const String pattern = r'^[0-9]+$';
    var regExp = RegExp(pattern);
    return regExp.hasMatch(number.trim());
  }

  static bool isContainNumber(String password) {
    const String pattern = r'[0-9]';
    var regExp = RegExp(pattern);
    return regExp.hasMatch(password);
  }

  static bool isLessThan8Characters(String password) {
    return password.length < 8;
  }

  static bool isContainSpecialCharacter(String password) {
    const String pattern = r'[!@#$%^&*(),.?":{}|<>]';
    var regExp = RegExp(pattern);
    if (password.contains(regExp)) {
      return true;
    } else if (password.contains('-') ||
        password.contains('£') ||
        password.contains('?') ||
        password.contains(',') ||
        password.contains(';') ||
        password.contains(':') ||
        password.contains('"') ||
        password.contains("'") ||
        password.contains('^') ||
        password.contains('[') ||
        password.contains(']') ||
        password.contains('/') ||
        password.contains('>') ||
        password.contains('<') ||
        password.contains('{') ||
        password.contains('}') ||
        password.contains('~') ||
        password.contains('_') ||
        password.contains('\\')) {
      return true;
    } else {
      return false;
    }
  }

  static bool isContainUpperCase(String password) {
    const String pattern = r'[A-Z]';
    var regExp = RegExp(pattern);
    return password.contains(regExp);
  }

  static bool isContainLowerCase(String password) {
    const String pattern = r'[a-z]';
    var regExp = RegExp(pattern);
    return password.contains(regExp);
  }

  static bool isValidIndex(int index) {
    return index != -1;
  }

  static ValidationState validateEmail(String email) {
    if (email.isNullOrEmpty) {
      return ValidationState.Empty;
    } else if (!isEmail(email)) {
      return ValidationState.Formatting;
    } else {
      return ValidationState.Valid;
    }
  }

  static ValidationState validatePassword(String password) {
    if (password.isNullOrEmpty) {
      return ValidationState.Empty;
    } else if (!isPassword(password)) {
      return ValidationState.Formatting;
    } else {
      return ValidationState.Valid;
    }
  }

  static ValidationState validateAuthCode(String code) {
    if (code.isNullOrEmpty) {
      return ValidationState.Empty;
    } else if (code.length != 6) {
      return ValidationState.Formatting;
    } else {
      return ValidationState.Valid;
    }
  }

  static ValidationState validateNumber(String number, int length) {
    if (number.isNullOrEmpty) {
      return ValidationState.Empty;
    } else if (number.length != length) {
      return ValidationState.Formatting;
    } else {
      return ValidationState.Valid;
    }
  }

  static bool validatePhoneNumber(String number) {
    const String pattern = '[^0-9]';
    var regExp = RegExp(pattern);
    return number.contains(regExp);
  }

  static ValidationState validateText(String text) {
    if (text.isNullOrEmpty) {
      return ValidationState.Empty;
    } else {
      return ValidationState.Valid;
    }
  }
}

enum ValidationState { Empty, Formatting, Valid }
