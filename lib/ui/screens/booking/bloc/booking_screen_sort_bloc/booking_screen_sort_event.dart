part of 'booking_screen_sort_bloc.dart';

abstract class BookingScreenSortEvent extends Equatable {
  const BookingScreenSortEvent();
}

class UpdateSortTypeEvent extends BookingScreenSortEvent {
  final SortType sortType;
  const UpdateSortTypeEvent({required this.sortType});

  @override
  List<Object?> get props => [sortType];
}

class ResetSortTypeEvent extends BookingScreenSortEvent {
  final SortType sortType = SortType.earliestAvailable;
  final bool enableListener;
  const ResetSortTypeEvent({this.enableListener = true});

  @override
  List<Object?> get props => [sortType, enableListener];
}
