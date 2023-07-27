import 'package:o7therapy/prefs/pref_keys.dart';
import 'package:o7therapy/prefs/pref_util.dart';

class PrefManager {
  static Future<bool> setLang(String? data) async {
    return await PrefUtils.setString(PrefKeys.lang, data!);
  }

  static Future<String?> getLang() async {
    return await PrefUtils.getString(PrefKeys.lang);
  }

  static Future<void> setLoggedIn({bool value = true}) async {
    await PrefUtils.setBool(PrefKeys.isLoggedIn, value);
  }

  static Future<bool> isLoggedIn() async {
    return await PrefUtils.getBool(PrefKeys.isLoggedIn);
  }

  static Future<void> setIsCorporate(bool value) async {
    await PrefUtils.setBool(PrefKeys.isCorporate, value);
  }

  static Future<void> setCompanyCode(String value) async {
    await PrefUtils.setString(PrefKeys.companyCode, value);
  }

  static Future<String?> getCompanyCode() async {
    return await PrefUtils.getString(PrefKeys.companyCode);
  }

  static Future<bool> isCorporate() async {
    return await PrefUtils.getBool(PrefKeys.isCorporate);
  }

  static Future<void> setFirstLogin() async {
    await PrefUtils.setBoolFirstLogin(PrefKeys.isFirstLogin, false);
  }

  static Future<bool> isFirstLogin() async {
    return await PrefUtils.getBoolFirstLogin(PrefKeys.isFirstLogin);
  }

  static Future<void> setToken(String? data) async {
    await PrefUtils.setString(PrefKeys.token, data!);
  }

  static Future<String?> getToken() async {
    return await PrefUtils.getString(PrefKeys.token);
  }

  static Future<void> setName(String? data) async {
    await PrefUtils.setString(PrefKeys.name, data!);
  }

  static Future<String?> getName() async {
    return await PrefUtils.getString(PrefKeys.name);
  }

  static Future<void> setEmail(String? data) async {
    await PrefUtils.setString(PrefKeys.email, data!);
  }

  static Future<String?> getEmail() async {
    return await PrefUtils.getString(PrefKeys.email);
  }
  //
  // static Future<void> setPassword(String? data) async {
  //   await PrefUtils.setString(PrefKeys.password, data!);
  // }
  //
  // static Future<String?> getPassword() async {
  //   return await PrefUtils.getString(PrefKeys.password);
  // }

  static Future<void> setRole(String? data) async {
    await PrefUtils.setString(PrefKeys.role, data!);
  }

  // static Future<String?> getRole() async {
  //   return await PrefUtils.getString(PrefKeys.role);
  // }

  static Future<void> setId(String? data) async {
    await PrefUtils.setString(PrefKeys.uid, data!);
  }

  static Future<String?> getId() async {
    return await PrefUtils.getString(PrefKeys.uid);
  }

  static Future<void> setRefreshToken(String? data) async {
    await PrefUtils.setString(PrefKeys.refreshToken, data!);
  }

  static Future<String?> getRefreshToken() async {
    return await PrefUtils.getString(PrefKeys.refreshToken);
  }

  static Future<void> setCurrency(String? data) async {
    await PrefUtils.setString(PrefKeys.currency, data!);
  }

  static Future<String?> getCurrency() async {
    return await PrefUtils.getString(PrefKeys.currency);
  }

  static Future<void> setZoomUrl(String data) async {
    await PrefUtils.setString(PrefKeys.zoomUrl, data);
  }

  static Future<String?> getZoomUrl() async {
    return await PrefUtils.getString(PrefKeys.zoomUrl);
  }

  static Future<void> setCountryCode(String data) async {
    await PrefUtils.setString(PrefKeys.country, data);
  }

  static Future<String?> getCountryCode() async {
    return await PrefUtils.getString(PrefKeys.country);
  }

  static Future<void> setUser(
    String? name,
    String? token,
    // String? role,
    String? id, {
    required String? refreshToken,
  }) async {
    await setName(name);
    await setToken(token);
    await setId(id);
    await setRefreshToken(refreshToken);
  }

  static Future<void> setResetPasswordRequired() async {
    await PrefUtils.setBool(PrefKeys.isResetPasswordRequired, true);
  }

  static Future<bool> isResetPasswordRequired() async {
    return await PrefUtils.getBool(PrefKeys.isResetPasswordRequired);
  }

  static Future<void> clearAllData() async {
    await PrefUtils.clearData();
  }

  static Future<void> setInsuranceCardId(int? data) async {
    await PrefUtils.setInt(PrefKeys.insuranceCardId, data!);
  }

  static Future<int?> getInsuranceCardId() async {
    return await PrefUtils.getInt(PrefKeys.insuranceCardId);
  }

  static Future<void> setEnforceUpdate({bool value = true}) async {
    await PrefUtils.setBool(PrefKeys.enforceUpdate, value);
  }

  static Future<bool> isEnforceUpdate() async {
    return await PrefUtils.getBool(PrefKeys.enforceUpdate);
  }

  static Future<void> setStoreLink(String data) async {
    await PrefUtils.setString(PrefKeys.storeLink, data);
  }

  static Future<String?> getStoreLink() async {
    return await PrefUtils.getString(PrefKeys.storeLink);
  }

  static Future<bool> setUserRefNumber(String? data) async {
    return await PrefUtils.setString(PrefKeys.userRefNumber, data ?? "");
  }

  static Future<String?> getUserRefNumber() async {
    return await PrefUtils.getString(PrefKeys.userRefNumber);
  }

  static Future<bool> setCorporateName(String? data) async {
    return await PrefUtils.setString(PrefKeys.corporateName, data ?? "");
  }

  static Future<String?> getCorporateName() async {
    return await PrefUtils.getString(PrefKeys.corporateName);
  }
}
