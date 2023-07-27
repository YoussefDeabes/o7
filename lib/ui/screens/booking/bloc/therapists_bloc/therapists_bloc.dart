import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/search_bloc/search_bloc.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/booking_screen_filter_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_sort_bloc/booking_screen_sort_bloc.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_bloc/therapists_repo.dart';

part 'therapists_event.dart';
part 'therapists_state.dart';

class TherapistsBloc extends Bloc<TherapistsEvent, TherapistsState> {
  static _GetTherapistsEvent _lastGetTherapistEvent =
      _GetTherapistsEvent.init();

  final BookingScreenSortBloc _sortBloc;
  final BookingScreenFilterBloc _filterBloc;
  final SearchBloc _searchBloc;
  final BaseTherapistsRepo _repo;

  TherapistsBloc({
    required BaseTherapistsRepo repo,
    required BookingScreenFilterBloc filterBloc,
    required BookingScreenSortBloc sortBloc,
    required SearchBloc searchBloc,
  })  : _repo = repo,
        _filterBloc = filterBloc,
        _sortBloc = sortBloc,
        _searchBloc = searchBloc,
        super(const LoadingTherapistsState()) {
    _onSortAttributeNameChanged();
    _onFilterChanged();
    _onSearchChanged();
    on<_GetTherapistsEvent>(_onGetTherapistsEvent);
    on<GetMoreTherapistsEvent>(_onGetMoreTherapistsEvent);
    on<GetInitQueryTherapistEvent>(_onGetInitQueryTherapistEvent);
  }

  static TherapistsBloc bloc(BuildContext context) =>
      context.read<TherapistsBloc>();

  /// if no updates or first time open service section
  /// >> will return therapists in the list in last state
  /// >> so emit the last state until it get more therapists data or update
  _onGetTherapistsEvent(_GetTherapistsEvent event, emit) async {
    /// update the event
    _lastGetTherapistEvent = event;
    emit(const LoadingTherapistsState());
    Map<String, dynamic> queryParameters = _getQueryParameters(
      filterQuery: event.filterQueryParameters,
      searchQuery: event.searchQuery,
    );
    TherapistsState state = await _repo.getTherapists(
      attributeName: _sortBloc.state.sortType.attributeName,
      direction: event.direction,
      isAttributesUpdated: true,
      queryParameters: queryParameters,
    );
    emit(state);
  }

  _onGetMoreTherapistsEvent(GetMoreTherapistsEvent event, emit) async {
    log(" GetMoreTherapistsEvent:");
    if (state is! LoadedTherapistsState) return;
    Map<String, dynamic> queryParameters = _getQueryParameters(
      filterQuery: _lastGetTherapistEvent.filterQueryParameters,
      searchQuery: _lastGetTherapistEvent.searchQuery,
    );
    TherapistsState newState = await _repo.getTherapists(
      attributeName: _sortBloc.state.sortType.attributeName,
      direction: _lastGetTherapistEvent.direction,
      isAttributesUpdated: false,
      queryParameters: queryParameters,
    );
    emit(newState);
  }

  _onGetInitQueryTherapistEvent(GetInitQueryTherapistEvent event, emit) async {
    log("GetInitQueryTherapistEvent:");
    emit(const LoadingTherapistsState());
    _searchBloc.add(const ClearSearchEvent(enableListener: false));
    _filterBloc.add(const ResetFiltersEvent(enableListener: false));
    _sortBloc.add(const ResetSortTypeEvent(enableListener: false));
    add(_GetTherapistsEvent.init());
  }

  _onSortAttributeNameChanged() {
    _sortBloc.stream.listen((sortState) {
      if (!sortState.isListenerEnabled) {
        log("SortChanged: not Listener Enabled");
        return;
      }
      log("SortChanged: Listener Enabled");

      add(_GetTherapistsEvent(
        searchQuery: _lastGetTherapistEvent.searchQuery,
        sortByAttribute: sortState.sortType.attributeName,
        direction: sortState.sortType.direction,
        filterQueryParameters: _lastGetTherapistEvent.filterQueryParameters,
      ));
    });
  }

  _onFilterChanged() {
    _filterBloc.stream.listen((filterState) {
      if (!filterState.isListenerEnabled) {
        log("filterChanged: not Listener Enabled");
        return;
      }
      log("filterChanged: Listener Enabled");

      add(_GetTherapistsEvent(
        searchQuery: _lastGetTherapistEvent.searchQuery,
        filterQueryParameters: Map.of(filterState.filterParameters()),
        direction: _lastGetTherapistEvent.direction,
        sortByAttribute: _lastGetTherapistEvent.sortByAttribute,
      ));
    });
  }

  _onSearchChanged() {
    _searchBloc.stream.listen((searchState) {
      if (!searchState.isListenerEnabled) {
        log("searchChanged: not Listener Enabled");
        return;
      }
      log("searchChanged: Listener Enabled");

      add(_GetTherapistsEvent(
        searchQuery: Map.of(searchState.searchQuery),
        filterQueryParameters: _lastGetTherapistEvent.filterQueryParameters,
        direction: _lastGetTherapistEvent.direction,
        sortByAttribute: _lastGetTherapistEvent.sortByAttribute,
      ));
    });
  }

  Map<String, dynamic> _getQueryParameters({
    required Map<String, dynamic> filterQuery,
    required Map<String, dynamic> searchQuery,
  }) {
    Map<String, dynamic> queryParameters = Map.of(filterQuery)
      ..addEntries(searchQuery.entries);
    queryParameters.forEach((key, value) => log("key: $key && value: $value"));

    return queryParameters;
  }
}
