part of 'secure_storage.dart';

const String _trueString = "true";
const String _falseString = "false";

class _SecureStorageHelper {
  const _SecureStorageHelper._(this._storage);
  final FlutterSecureStorage _storage;
  static _SecureStorageHelper? _instance;

  factory _SecureStorageHelper.init() {
    if (_instance != null) {
      return _instance!;
    }
    _instance = const _SecureStorageHelper._(FlutterSecureStorage());
    return _instance!;
  }

  Future<bool> clearData() async {
    try {
      await _storage.deleteAll();
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setString(String key, String data) async {
    try {
      await _storage.write(key: key, value: data);
      return Future.value(true);
    } catch (_) {
      return Future.value(false);
    }
  }

  Future<bool> setInt(String key, int data) async {
    final String stringData = data.toString();
    try {
      await _storage.write(key: key, value: stringData);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<bool> setBool(String key, bool data) async {
    final String stringData = data ? _trueString : _falseString;
    try {
      await _storage.write(key: key, value: stringData);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<String?> getString(String key) async {
    return await _storage.read(key: key);
  }

  Future<int?> getInt(String key) async {
    final String? stringInt = await _storage.read(key: key);
    return int.tryParse(stringInt ?? "");
  }

  Future<bool> getBool(String key) async {
    try {
      final String? stringBool = await _storage.read(key: key);
      if (stringBool == _trueString) {
        return true;
      } else {
        return false;
      }
    } catch (_) {
      return false;
    }
  }
}
