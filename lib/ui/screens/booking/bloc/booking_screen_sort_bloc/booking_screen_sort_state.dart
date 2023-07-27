part of 'booking_screen_sort_bloc.dart';

class BookingScreenSortState extends Equatable {
  final bool isListenerEnabled;
  final SortType sortType;
  const BookingScreenSortState({
    required this.sortType,
    this.isListenerEnabled = true,
  });

  @override
  List<Object?> get props => [sortType];
}
