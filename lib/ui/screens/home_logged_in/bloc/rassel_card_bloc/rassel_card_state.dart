part of 'rassel_card_bloc.dart';

abstract class RasselCardState extends Equatable {
  const RasselCardState();

  @override
  List<Object> get props => [];
}

class RasselCardInitial extends RasselCardState {
  const RasselCardInitial();
}

class DismissedRasselCardState extends RasselCardState {
  const DismissedRasselCardState();

  @override
  List<Object> get props => [];
}

class NotDismissedRasselCardState extends RasselCardState {
  const NotDismissedRasselCardState();

  @override
  List<Object> get props => [];
}
