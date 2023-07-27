import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_sort_bloc/sort_type.dart';
import 'package:o7therapy/util/firebase/analytics/booking_analytics.dart';

part 'booking_screen_sort_event.dart';
part 'booking_screen_sort_state.dart';

class BookingScreenSortBloc
    extends Bloc<BookingScreenSortEvent, BookingScreenSortState> {
  BookingScreenSortBloc._internal()
      : super(const BookingScreenSortState(
            sortType: SortType.earliestAvailable)) {
    on<UpdateSortTypeEvent>(_onUpdateSortTypeEvent);
    on<ResetSortTypeEvent>(_onResetSortTypeEvent);
  }

  static final BookingScreenSortBloc _instance =
      BookingScreenSortBloc._internal();

  factory BookingScreenSortBloc() => _instance;

  /// listen to update at the therapist list bloc
  _onUpdateSortTypeEvent(UpdateSortTypeEvent event, emit) {
    BookingAnalytics.i.therapistListSort(sortType: event.sortType.name);
    emit(BookingScreenSortState(sortType: event.sortType));
  }

  _onResetSortTypeEvent(ResetSortTypeEvent event, emit) {
    emit(BookingScreenSortState(
      sortType: event.sortType,
      isListenerEnabled: event.enableListener,
    ));
  }
}
