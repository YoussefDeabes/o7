import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:o7therapy/prefs/pref_manager.dart';

part 'biometrics_state.dart';

enum SupportState {
  unknown,
  supported,
  unsupported,
}

class BiometricsCubit extends Cubit<BiometricsState> {
  final LocalAuthentication auth;
  BiometricsCubit(this.auth) : super(BiometricsState.init()) {
    _init();
  }

  static BiometricsCubit bloc(BuildContext context) =>
      context.read<BiometricsCubit>();

  Future<void> _init() async {
    await Future.wait([
      _checkBiometrics(),
      _getAvailableBiometrics(),
      _isDeviceSupported(),
    ]);
  }

  Future<void> _isDeviceSupported() async {
    bool isSupported = await auth.isDeviceSupported();
    SupportState updatedSupportState =
        isSupported ? SupportState.supported : SupportState.unsupported;
    emit(state.copyWith(supportState: updatedSupportState));
  }

  Future<void> _checkBiometrics() async {
    bool canCheckBiometrics;
    try {
      canCheckBiometrics = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      canCheckBiometrics = false;
    }
    emit(state.copyWith(canCheckBiometrics: canCheckBiometrics));
  }

  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometrics;

    try {
      availableBiometrics = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      availableBiometrics = <BiometricType>[];
    }
    emit(state.copyWith(availableBiometrics: availableBiometrics));
  }

  Future<void> cancelAuthentication() async {
    await auth.stopAuthentication();
    emit(state.copyWith(isAuthenticating: false));
  }

  void setIsAuthenticatingToFalse() {
    return emit(state.copyWith(isAuthenticating: false));
  }

  void updateAuthorized(String authorized) {
    emit(state.copyWith(authorized: authorized));
  }

  Future<bool> checkIsFirstLogin() async {
    bool isFirstLogin = await PrefManager.isFirstLogin();
    if (isFirstLogin) {
      emit(state.copyWith(
        isAuthenticating: false,
        authorized: 'Authenticating',
      ));
    } else {
      emit(state.copyWith(
        isAuthenticating: true,
        authorized: 'Authenticating',
      ));
    }
    return isFirstLogin;
  }
}
