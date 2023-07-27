import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/services_categories_enum.dart';

part 'services_categories_event.dart';
part 'services_categories_state.dart';

class ServicesCategoriesBloc
    extends Bloc<ServicesCategoriesEvent, ServicesCategoriesState> {
  ServicesCategoriesBloc()
      : super(
          const ServicesCategoriesState(ServicesCategories.oneOnOneSessions),
        ) {
    on<UpdateServicesCategoriesEvent>(_onUpdateServicesCategoriesEvent);
  }

  static ServicesCategoriesBloc bloc(BuildContext context) =>
      context.read<ServicesCategoriesBloc>();

  _onUpdateServicesCategoriesEvent(
    UpdateServicesCategoriesEvent event,
    emit,
  ) async {
    emit(ServicesCategoriesState(event.servicesCategory));
  }
}
