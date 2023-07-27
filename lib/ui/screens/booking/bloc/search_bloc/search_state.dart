part of 'search_bloc.dart';

class SearchState extends Equatable {
  final bool isListenerEnabled;
  final Map<String, String> searchQuery;
  const SearchState(this.searchQuery, {this.isListenerEnabled = true});

  @override
  List<Object> get props => [
        searchQuery.values,
        searchQuery.keys,
        isListenerEnabled,
      ];
}
