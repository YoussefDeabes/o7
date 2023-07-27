import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:o7therapy/util/firebase/analytics/keys/analytics_event_name.dart';
import 'package:o7therapy/util/firebase/analytics/keys/analytics_param_name.dart';

const String _corporateUser = "corporate";
const String _individualUser = "individual";
const String _unspecifiedUser = "unspecified";

final class AuthAnalytics {
  const AuthAnalytics._();
  static AuthAnalytics? _instance;
  static AuthAnalytics get i => _instance ??= const AuthAnalytics._();
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> registerLaterClick() async {
    await _analytics.logEvent(name: AnalyticsEventName.registerLaterClick);
  }

  Future<void> getStartedClick() async {
    await _analytics.logEvent(name: AnalyticsEventName.getStartedClick);
  }

  /// when user login Successfully track login event
  Future<void> _successLogin() async {
    await _analytics.logLogin(loginMethod: "email");
  }

  Future<void> _successSignUp() async {
    await _analytics.logSignUp(signUpMethod: "email");
  }

  Future<void> signUpClick() async {
    await _analytics.logEvent(name: AnalyticsEventName.signUpClick);
  }

  Future<void> unverifiedSignUp() async {
    await _analytics.logEvent(name: AnalyticsEventName.unverifiedSignUp);
  }

  Future<void> completedSignUp({
    required bool? isCorporate,
    required String? corporateName,
  }) async {
    Future.wait([
      _successSignUp(),
      _setClientType(isCorporate),
      _setCorporateName(corporateName),
    ]);
  }

  Future<void> successLogin({
    required bool? isCorporate,
    required String? corporateName,
  }) async {
    Future.wait([
      _successLogin(),
      _setClientType(isCorporate),
      _setCorporateName(corporateName),
    ]);
  }

  Future<void> setUserId({required String? id}) => _analytics.setUserId(id: id);
  Future<void> _setClientType(bool? isCorporate) async {
    String clientType;
    if (isCorporate == null) {
      clientType = _unspecifiedUser;
    } else {
      clientType = isCorporate ? _corporateUser : _individualUser;
    }
    return await _analytics.setUserProperty(
      name: AnalyticsParamName.clientType,
      value: clientType,
    );
  }

  Future<void> _setCorporateName(String? corporateName) async {
    return await _analytics.setUserProperty(
      name: AnalyticsParamName.corporateName,
      value: corporateName,
    );
  }

  Future<void> setUserDateOfBirth({
    required String dateOfBirth,
  }) async {
    await _analytics.setUserProperty(
      name: AnalyticsParamName.dateOfBirth,
      value: dateOfBirth,
    );
  }

  Future<void> logout() async {
    await _analytics.logEvent(name: AnalyticsEventName.logout);
    return _analytics.setUserId();
  }
}
