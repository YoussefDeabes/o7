part of 'booking_screen_filter_bloc.dart';

abstract class BookingScreenFilterEvent extends Equatable {
  const BookingScreenFilterEvent();

  @override
  List<Object> get props => [];
}

/// when reset all filter so no filter will applied
class ResetFiltersEvent extends BookingScreenFilterEvent {
  final bool enableListener;
  const ResetFiltersEvent({this.enableListener = true});

  @override
  List<Object> get props => [enableListener];
}

/// update all filters >> called in the bloc only
class _UpdateFiltersEvent extends BookingScreenFilterEvent {
  const _UpdateFiltersEvent({this.enableListener = true});
  final bool enableListener;
}

/// event is triggered >> when user press Apply button
class ApplyFiltersEvent extends BookingScreenFilterEvent {
  final FilterViewModel filterViewModel;
  const ApplyFiltersEvent({required this.filterViewModel});
}

/// Remove only one filter >> this used form the chip
class RemoveSingleFilterEvent extends BookingScreenFilterEvent {
  final Filter filter;
  final String? chipValueNeedToRemove;
  const RemoveSingleFilterEvent(
      {required this.filter, this.chipValueNeedToRemove});
}
