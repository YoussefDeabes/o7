import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage_keys.dart';

part 'secure_storage_helper.dart';

class SecureStorage {
  const SecureStorage._();
  static late final _SecureStorageHelper _storageHelper;
  static SecureStorage? _i;

  static void init() {
    if (_i != null) {
      return;
    }
    _i = const SecureStorage._();
    _storageHelper = _SecureStorageHelper.init();
  }

  /// Read RestoreId of freshChat key: [userId] and value: [restoreId]
  /// [userId] get it from backend and is the same of externalId of freshchat
  static Future<String?> readRestoreIdByUserId({required String userId}) async {
    return await _storageHelper.getString(userId);
  }

  /// Save RestoreId of freshChat as Map: { [userId] : [restoreId] }
  /// key: [userId] and value: [restoreId]
  /// [userId] get it from backend and is the same of externalId of freshchat
  static Future<void> writeRestoreId({
    required String userId,
    required String restoreId,
  }) async {
    await _storageHelper.setString(userId, restoreId);
  }

  static Future<String?> readFreshChatToken() async {
    return _storageHelper.getString(SecureStorageKeys.freshChatIdToken);
  }

  /// Write values to secure storage
  static Future<void> writeFreshChatToken({
    required String value,
  }) async {
    await _storageHelper.setString(SecureStorageKeys.freshChatIdToken, value);
  }

  /// save List of Ids on the device that pressed on get matched Button
  /// so they will not see getMatched card another time
  static Future<void> setGetMatchedModel({
    required String value,
  }) async {
    await _storageHelper.setString(
      SecureStorageKeys.getMatchedIds,
      value,
    );
  }

  /// get the users Ids saved on the device that pressed on get matched Button
  static Future<String> getPressedGetMatchedModel() async {
    return await _storageHelper.getString(SecureStorageKeys.getMatchedIds) ??
        "";
  }

  static Future<bool> setLang(String? data) async {
    return await _storageHelper.setString(SecureStorageKeys.lang, data!);
  }

  static Future<String?> getLang() async {
    return await _storageHelper.getString(SecureStorageKeys.lang);
  }

  static Future<bool> setUsersDismissedRasselCard(String? data) async {
    return await _storageHelper.setString(
        SecureStorageKeys.usersDismissedRasselCard, data!);
  }

  static Future<String?> getUsersDismissedRasselCard() async {
    return await _storageHelper
        .getString(SecureStorageKeys.usersDismissedRasselCard);
  }

  static Future<void> setLoggedIn({bool value = true}) async {
    await _storageHelper.setBool(SecureStorageKeys.isLoggedIn, value);
  }

  static Future<bool> isLoggedIn() async {
    return await _storageHelper.getBool(SecureStorageKeys.isLoggedIn);
  }

  static Future<void> setIsCorporate(bool value) async {
    await _storageHelper.setBool(SecureStorageKeys.isCorporate, value);
  }

  static Future<void> setCompanyCode(String value) async {
    await _storageHelper.setString(SecureStorageKeys.companyCode, value);
  }

  static Future<String?> getCompanyCode() async {
    return await _storageHelper.getString(SecureStorageKeys.companyCode);
  }

  static Future<bool> isCorporate() async {
    return await _storageHelper.getBool(SecureStorageKeys.isCorporate);
  }

  static Future<void> setFirstLogin() async {
    await _storageHelper.setBool(SecureStorageKeys.isFirstLogin, false);
  }

  static Future<bool> isFirstLogin() async {
    return await _storageHelper.getBool(SecureStorageKeys.isFirstLogin);
  }

  static Future<void> setToken(String? data) async {
    await _storageHelper.setString(SecureStorageKeys.token, data!);
  }

  static Future<String?> getToken() async {
    return await _storageHelper.getString(SecureStorageKeys.token);
  }

  static Future<void> setName(String? data) async {
    await _storageHelper.setString(SecureStorageKeys.name, data!);
  }

  static Future<String?> getName() async {
    return await _storageHelper.getString(SecureStorageKeys.name);
  }

  static Future<void> setEmail(String? data) async {
    await _storageHelper.setString(SecureStorageKeys.email, data!);
  }

  static Future<String?> getEmail() async {
    return await _storageHelper.getString(SecureStorageKeys.email);
  }

  static Future<void> setRole(String? data) async {
    await _storageHelper.setString(SecureStorageKeys.role, data!);
  }

  static Future<String?> getId() async {
    return await _storageHelper.getString(SecureStorageKeys.uid);
  }

  static Future<void> setId(String? data) async {
    await _storageHelper.setString(SecureStorageKeys.uid, data!);
  }

  static Future<void> setRefreshToken(String? data) async {
    await _storageHelper.setString(SecureStorageKeys.refreshToken, data!);
  }

  static Future<String?> getRefreshToken() async {
    return await _storageHelper.getString(SecureStorageKeys.refreshToken);
  }

  static Future<void> setCurrency(String? data) async {
    await _storageHelper.setString(SecureStorageKeys.currency, data!);
  }

  static Future<String?> getCurrency() async {
    return await _storageHelper.getString(SecureStorageKeys.currency);
  }

  static Future<void> setZoomUrl(String data) async {
    await _storageHelper.setString(SecureStorageKeys.zoomUrl, data);
  }

  static Future<String?> getZoomUrl() async {
    return await _storageHelper.getString(SecureStorageKeys.zoomUrl);
  }

  static Future<void> setCountryCode(String data) async {
    await _storageHelper.setString(SecureStorageKeys.country, data);
  }

  static Future<String?> getCountryCode() async {
    return await _storageHelper.getString(SecureStorageKeys.country);
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
    await _storageHelper.setBool(
        SecureStorageKeys.isResetPasswordRequired, true);
  }

  static Future<bool> isResetPasswordRequired() async {
    return await _storageHelper
        .getBool(SecureStorageKeys.isResetPasswordRequired);
  }

  static Future<void> clearAllData() async {
    await _storageHelper.clearData();
  }

  static Future<void> setInsuranceCardId(int? data) async {
    await _storageHelper.setInt(SecureStorageKeys.insuranceCardId, data!);
  }

  static Future<int?> getInsuranceCardId() async {
    return await _storageHelper.getInt(SecureStorageKeys.insuranceCardId);
  }

  static Future<void> setEnforceUpdate({bool value = true}) async {
    await _storageHelper.setBool(SecureStorageKeys.enforceUpdate, value);
  }

  static Future<bool> isEnforceUpdate() async {
    return await _storageHelper.getBool(SecureStorageKeys.enforceUpdate);
  }

  static Future<void> setStoreLink(String data) async {
    await _storageHelper.setString(SecureStorageKeys.storeLink, data);
  }

  static Future<String?> getStoreLink() async {
    return await _storageHelper.getString(SecureStorageKeys.storeLink);
  }

  static Future<bool> setUserRefNumber(String? data) async {
    return await _storageHelper.setString(
        SecureStorageKeys.userRefNumber, data ?? "");
  }

  static Future<String?> getUserRefNumber() async {
    return await _storageHelper.getString(SecureStorageKeys.userRefNumber);
  }

  static Future<bool> setCorporateName(String? data) async {
    return await _storageHelper.setString(
        SecureStorageKeys.corporateName, data ?? "");
  }

  static Future<String?> getCorporateName() async {
    return await _storageHelper.getString(SecureStorageKeys.corporateName);
  }

  static Future<bool> setHasActiveRasselSubscription(String? data) async {
    return await _storageHelper.setString(
        SecureStorageKeys.hasActiveRasselSubscription, data ?? "");
  }

  static Future<String?> getHasActiveRasselSubscription() async {
    return await _storageHelper.getString(SecureStorageKeys.hasActiveRasselSubscription);
  }
}
