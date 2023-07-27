import 'dart:async';

import 'package:o7therapy/api/api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/change_password/ChangePassword.dart';
import 'package:o7therapy/api/models/change_password/change_password_send_model.dart';
import 'package:o7therapy/ui/screens/change_password/bloc/change_password_bloc.dart';

abstract class BaseChangePasswordRepo {
  Future<ChangePasswordState> changePasswordApi(
      ChangePasswordSendModel changePasswordModel);
}

class ChangePasswordRepo extends BaseChangePasswordRepo {
  @override
  Future<ChangePasswordState> changePasswordApi(
      ChangePasswordSendModel changePasswordModel) async {
    ChangePasswordState? changePasswordState;
    NetworkExceptions? detailsModel;
    try {
      await ApiManager.changePasswordApi(changePasswordModel,
          (ChangePassword changePassword) {
        changePasswordState = SuccessChangePassword(changePassword);
      }, (NetworkExceptions details) {
        detailsModel = details;
        changePasswordState = NetworkError(details.errorMsg!);
      });
    } catch (error) {
      changePasswordState =
          ErrorState(detailsModel?.errorMsg ?? "Unknown error");
    }
    return changePasswordState!;
  }
}
