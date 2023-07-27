import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

part 'auth_secure_storage_state.dart';

/// Create storage
const String KEY_USERNAME = "KEY_USERNAME";
const String KEY_PASSWORD = "KEY_PASSWORD";
const String KEY_LOCAL_AUTH_ENABLED = "KEY_LOCAL_AUTH_ENABLED";

class AuthSecureStorageCubit extends Cubit<AuthSecureStorageState> {
  final FlutterSecureStorage _storage;
  AuthSecureStorageCubit(this._storage)
      : super(const InitialAuthSecureStorage());

  static AuthSecureStorageCubit bloc(BuildContext context) =>
      context.read<AuthSecureStorageCubit>();

  /// Read values
  Future<DataAuthSecureStorage> readFromStorage() async {
    final String emailTxt = await _storage.read(key: KEY_USERNAME) ?? '';
    final String passwordTxt = await _storage.read(key: KEY_PASSWORD) ?? '';
    return DataAuthSecureStorage(email: emailTxt, password: passwordTxt);
  }

  /// Write values to secure storage when success Login
  Future<void> writeToStorage({
    required String email,
    required String password,
  }) async {
    await _storage.write(key: KEY_USERNAME, value: email);
    await _storage.write(key: KEY_PASSWORD, value: password);
  }

  /// It enables local_auth and saves data into storage
  Future<void> onEnableLocalAuth() async {
    /// Save
    await _storage.write(key: KEY_LOCAL_AUTH_ENABLED, value: "true");
  }
}
