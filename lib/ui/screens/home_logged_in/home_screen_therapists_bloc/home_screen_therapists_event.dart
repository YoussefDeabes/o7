part of 'home_screen_therapists_bloc.dart';

abstract class HomeScreenTherapistsEvent extends Equatable {
  const HomeScreenTherapistsEvent();
}

class GetThreeTherapistsEvent extends HomeScreenTherapistsEvent {
  const GetThreeTherapistsEvent();

  @override
  List<Object?> get props => throw UnimplementedError();
}
