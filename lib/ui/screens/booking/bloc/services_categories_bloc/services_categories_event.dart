part of 'services_categories_bloc.dart';

abstract class ServicesCategoriesEvent extends Equatable {
  const ServicesCategoriesEvent();

  @override
  List<Object?> get props => [];
}

class UpdateServicesCategoriesEvent extends ServicesCategoriesEvent {
  final ServicesCategories servicesCategory;
  const UpdateServicesCategoriesEvent(this.servicesCategory);

  @override
  List<Object?> get props => [servicesCategory];
}
