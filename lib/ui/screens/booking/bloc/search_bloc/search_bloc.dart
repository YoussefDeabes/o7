import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/search_bloc/search_repo.dart';
import 'package:o7therapy/util/firebase/analytics/booking_analytics.dart';

part 'search_event.dart';
part 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  static const String searchKeyword = "keywords";
  final BaseSearchRepo repo;
  SearchBloc({required this.repo}) : super(const SearchState({})) {
    on<AddSearchInputEvent>(_onAddSearchInputEvent);
    on<ClearSearchEvent>(_onClearSearchEvent);
  }

  static SearchBloc bloc(BuildContext context) => context.read<SearchBloc>();

  _onAddSearchInputEvent(AddSearchInputEvent event, Emitter<SearchState> emit) {
    BookingAnalytics.i.therapistListSearch(searchTerm: event.searchInput);
    emit(repo.getSearchMap(inputString: event.searchInput));
  }

  _onClearSearchEvent(ClearSearchEvent event, Emitter<SearchState> emit) {
    emit(SearchState(const {}, isListenerEnabled: event.enableListener));
  }
}
