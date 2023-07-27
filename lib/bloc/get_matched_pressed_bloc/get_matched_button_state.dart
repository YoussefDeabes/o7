part of 'get_matched_button_bloc.dart';

abstract class GetMatchedButtonState extends Equatable {
  const GetMatchedButtonState();

  @override
  List<Object> get props => [];
}

class HideGetMatchedCard extends GetMatchedButtonState {
  const HideGetMatchedCard();
}

class ShowGetMatchedCard extends GetMatchedButtonState {
  const ShowGetMatchedCard();
}
