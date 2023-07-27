part of 'therapists_bloc.dart';

abstract class TherapistsEvent extends Equatable {
  const TherapistsEvent();
  @override
  List<Object?> get props => [];
}

class _GetTherapistsEvent extends TherapistsEvent {
  final String sortByAttribute;
  final String direction;
  final Map<String, dynamic> filterQueryParameters;
  final Map<String, dynamic> searchQuery;
  const _GetTherapistsEvent({
    required this.sortByAttribute,
    required this.direction,
    required this.filterQueryParameters,
    required this.searchQuery,
  });

  /// at this initial state >>
  /// 1- clear the sort to initial
  /// 2- clear the filter to initial
  /// 3- get the initial query values from the backend
  factory _GetTherapistsEvent.init() => const _GetTherapistsEvent(
        sortByAttribute: "Availability",
        direction: "Asc",
        filterQueryParameters: {},
        searchQuery: {},
      );

  _GetTherapistsEvent copyWith({
    String? sortByAttribute,
    String? direction,
    bool? updateList,
    Map<String, dynamic>? filterQueryParameters,
    Map<String, dynamic>? searchQuery,
  }) {
    return _GetTherapistsEvent(
      searchQuery: searchQuery ?? this.searchQuery,
      sortByAttribute: sortByAttribute ?? this.sortByAttribute,
      direction: direction ?? this.direction,
      filterQueryParameters:
          filterQueryParameters ?? this.filterQueryParameters,
    );
  }

  @override
  List<Object?> get props =>
      [sortByAttribute, direction, filterQueryParameters];
}

class GetInitQueryTherapistEvent extends TherapistsEvent {
  const GetInitQueryTherapistEvent();
}

class GetMoreTherapistsEvent extends TherapistsEvent {
  const GetMoreTherapistsEvent();
}
