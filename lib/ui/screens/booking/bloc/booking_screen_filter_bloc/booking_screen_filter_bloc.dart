import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/filter_repository.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_models.dart';

part 'booking_screen_filter_event.dart';
part 'booking_screen_filter_state.dart';

class BookingScreenFilterBloc
    extends Bloc<BookingScreenFilterEvent, BookingScreenFilterState> {
  final FilterRepository _repo;

  BookingScreenFilterBloc({required FilterRepository repo})
      : _repo = repo,
        super(BookingScreenFilterState.init()) {
    _repo.getMinMaxValues();
    on<ResetFiltersEvent>(_onResetFiltersEvent);
    on<_UpdateFiltersEvent>(_onUpdateFiltersEvent);
    on<ApplyFiltersEvent>(_onApplyFiltersEvent);
    on<RemoveSingleFilterEvent>(_onRemoveSingleFilterEvent);
  }

  _onResetFiltersEvent(ResetFiltersEvent event, emit) async {
    _repo.getMinMaxValues();
    _repo.clearAllFilters();
    add(_UpdateFiltersEvent(enableListener: event.enableListener));
  }

  _onUpdateFiltersEvent(_UpdateFiltersEvent event, emit) {
    emit(BookingScreenFilterState(
      isListenerEnabled: event.enableListener,
      filterViewModel: _repo.filterViewModel,
      filterItems: _repo.filterItems,
      isThereIsAnyFilterApplied: _repo.isThereIsAnyFilterApplied,
    ));
  }

  _onRemoveSingleFilterEvent(RemoveSingleFilterEvent event, emit) {
    _repo.removeSingleFilter(event.filter);
    add(const _UpdateFiltersEvent());
  }

  /// when the user pressed apply button
  _onApplyFiltersEvent(ApplyFiltersEvent event, emit) {
    _repo.update(filterViewModel: event.filterViewModel);
    add(const _UpdateFiltersEvent());
    log("apply pressed");
  }

  // @override
  // void onChange(Change<BookingScreenFilterState> change) {
  //   log(change.currentState.toString() + change.nextState.toString());
  //   super.onChange(change);
  // }
}
