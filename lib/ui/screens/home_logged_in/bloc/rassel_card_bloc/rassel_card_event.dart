part of 'rassel_card_bloc.dart';

abstract class RasselCardEvent extends Equatable {
  const RasselCardEvent();

  @override
  List<Object> get props => [];
}

class DismissRasselCardEvent extends RasselCardEvent {
  const DismissRasselCardEvent();

  @override
  List<Object> get props => [];
}

class CheckRasselCardIsDismissedEvent extends RasselCardEvent {
  const CheckRasselCardIsDismissedEvent();

  @override
  List<Object> get props => [];
}
