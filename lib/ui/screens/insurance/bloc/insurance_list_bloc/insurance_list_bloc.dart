import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/insurance_api_manager.dart';
import 'package:o7therapy/api/models/insurance/insurance_providers_list/insurance_providers_wrapper.dart';
import 'package:o7therapy/api/models/insurance/insurance_providers_list/provider_data.dart';

part 'insurance_list_event.dart';
part 'insurance_list_state.dart';

/// the bloc used to fetch the insurance list from the back end
class InsuranceListBloc extends Bloc<InsuranceListEvent, InsuranceListState> {
  InsuranceListBloc() : super(const LoadingInsuranceListState()) {
    on<GetInsuranceListEvent>(_onGetInsuranceListEvent);
  }

  static InsuranceListBloc getInsuranceListBloc(BuildContext context) =>
      context.read<InsuranceListBloc>();

  _onGetInsuranceListEvent(event, emit) async {
    emit(const LoadingInsuranceListState());
    await InsuranceApiManager.getInsuranceProvidersList(
      success: (InsuranceProvidersWrapper wrapper) {
        emit(LoadedInsuranceListState(insuranceProvidersList: wrapper.data));
      },
      fail: (NetworkExceptions detailsApiModel) {
        emit(ExceptionInsuranceListState(message: detailsApiModel.errorMsg!));
      },
    );
  }
}
