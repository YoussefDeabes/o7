part of 'services_categories_bloc.dart';

class ServicesCategoriesState extends Equatable {
  final ServicesCategories servicesCategory;
  const ServicesCategoriesState(this.servicesCategory);

  @override
  List<Object?> get props => [servicesCategory];
}
