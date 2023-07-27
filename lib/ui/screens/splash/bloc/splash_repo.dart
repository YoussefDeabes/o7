import 'dart:async';
import 'dart:io';

import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/enforce_update/EnforceUpdate.dart';
import 'package:o7therapy/ui/screens/splash/bloc/splash_bloc.dart';

abstract class BaseSplashRepo {
  const BaseSplashRepo();

  Future<SplashState> checkEnforceUpdate(String version);
}

class SplashRepo extends BaseSplashRepo {
  const SplashRepo();

  @override
  Future<SplashState> checkEnforceUpdate(String version) async {
    SplashState? splashState;
    NetworkExceptions? detailsModel;
    String platform = '';
    try {
      if (Platform.isAndroid) {
        platform = 'android';
      } else {
        platform = 'ios';
      }
      await ApiManager.updateVersion(version,platform,(EnforceUpdate enforce) async {

        splashState = EnforceUpdateSuccess(enforce);

      }, (NetworkExceptions details) {
        detailsModel = details;
        splashState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      splashState =
          ErrorState(detailsModel?.errorMsg ?? error.toString());
    }
    return splashState!;
  }
}
