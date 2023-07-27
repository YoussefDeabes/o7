import 'package:flutter/foundation.dart';
import 'package:o7therapy/ui/screens/booking/bloc/search_bloc/search_bloc.dart';

abstract class BaseSearchRepo {
  const BaseSearchRepo();

  SearchState getSearchMap({
    required String inputString,
  });
}

class SearchRepo extends BaseSearchRepo {
  const SearchRepo();

  @override
  SearchState getSearchMap({required String inputString}) {
    Map<String, String> searchQuery = {};
    searchQuery[SearchBloc.searchKeyword] = inputString;
    debugPrint(searchQuery.toString());
    return SearchState(searchQuery);
  }
}
