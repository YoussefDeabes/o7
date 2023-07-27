import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_repo.dart';
import 'package:o7therapy/ui/screens/home_logged_in/models/user_discount_data.dart';

part 'check_user_discount_state.dart';

class CheckUserDiscountCubit extends Cubit<CheckUserDiscountState> {
  final BaseCheckUserDiscountRepository _repo;
  CheckUserDiscountCubit(this._repo)
      : super(const LoadingCheckUserDiscountState());

  static CheckUserDiscountCubit bloc(BuildContext context) =>
      context.read<CheckUserDiscountCubit>();

  static UserDiscountData? userDiscountData;
  static ClientStatus? clientStatus;

  void checkUserDiscountEvent() async {
    emit(const LoadingCheckUserDiscountState());
    CheckUserDiscountState state = await _repo.checkUserDiscount();
    if (state is LoadedUserDiscountState) {
      userDiscountData = state.userDiscountData;
      clientStatus = state.userDiscountData.clientStatus;
      await _saveUserDiscountDataToSharedPref(state.userDiscountData);
    }
    emit(state);
  }

  Future<void> _saveUserDiscountDataToSharedPref(UserDiscountData data) async {
    try {
      if (data.isCorporate != null && data.isCorporate == true) {
        await PrefManager.setIsCorporate(true);
        await PrefManager.setCompanyCode(data.companyCode ?? "");
      } else if (data.isInsurance != null && data.isInsurance == true) {
        await PrefManager.setIsCorporate(false);
        await PrefManager.setCompanyCode(data.companyCode ?? "");
      } else {
        await PrefManager.setCompanyCode(data.companyCode ?? "");
        await PrefManager.setIsCorporate(false);
      }
      await PrefManager.setCorporateName(data.corporateName);
      await PrefManager.setUserRefNumber(data.userReferenceNumber);
    } catch (error) {
      log(error.toString());
    }
  }
}
