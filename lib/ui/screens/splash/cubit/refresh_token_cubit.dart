import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/base/refresh_token/dio_refresh_token.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

part 'refresh_token_state.dart';

class RefreshTokenCubit extends Cubit<RefreshTokenState> {
  RefreshTokenCubit() : super(const RefreshTokenInitial()) {
    _refreshToken();
  }

  _refreshToken() async {
    bool isLoggedIn = await PrefManager.isLoggedIn();
    if (!isLoggedIn) {
      return;
    }
    if (await DioRefreshToken.refreshToken()) {
      emit(const TrueRefreshToken());
      await PrefManager.setLoggedIn(value: true);
      await SecureStorage.setLoggedIn(value: true);
    } else {
      emit(const FalseRefreshToken());
      await PrefManager.setLoggedIn(value: false);
      await SecureStorage.setLoggedIn(value: false);
    }
  }

  reset() => emit(const RefreshTokenInitial());

  static RefreshTokenCubit cubit(BuildContext context) =>
      context.read<RefreshTokenCubit>();
}
