part of 'get_matched_button_bloc.dart';

abstract class GetMatchedButtonEvent extends Equatable {
  const GetMatchedButtonEvent();

  @override
  List<Object> get props => [];
}

class CheckGetMatchedCardEvent extends GetMatchedButtonEvent {
  const CheckGetMatchedCardEvent();
}

class PressedGetMatchedButtonEvent extends GetMatchedButtonEvent {
  const PressedGetMatchedButtonEvent();
}
