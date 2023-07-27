part of 'search_bloc.dart';

class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class AddSearchInputEvent extends SearchEvent {
  final bool enableListener;
  final String searchInput;
  const AddSearchInputEvent(this.searchInput, {this.enableListener = true});

  @override
  List<Object> get props => [enableListener, searchInput];
}

class ClearSearchEvent extends SearchEvent {
  final bool enableListener;
  const ClearSearchEvent({this.enableListener = true});

  @override
  List<Object> get props => [enableListener];
}
