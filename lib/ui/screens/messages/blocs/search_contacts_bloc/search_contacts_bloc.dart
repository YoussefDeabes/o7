import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/search_contacts_bloc/search_contacts_repo.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';

part 'search_contacts_event.dart';
part 'search_contacts_state.dart';

class SearchContactsBloc
    extends Bloc<SearchContactsEvent, SearchContactsState> {
  static const String searchKeyword = "keywords";
  final BaseSearchContactsRepo repo;
  List<ContactItem> contacts;
  String searchInput;
  SearchContactsBloc({
    this.contacts = const [],
    this.searchInput = "",
    required this.repo,
  }) : super(SearchContactsState(contacts)) {
    on<UpdateContactsEvent>(_onUpdateContactsEvent);
    on<AddSearchContactsInputEvent>(_onAddSearchContactsInputEvent);
    on<ClearSearchContactsEvent>(_onClearSearchContactsEvent);
  }

  static SearchContactsBloc bloc(BuildContext context) =>
      context.read<SearchContactsBloc>();

  _onUpdateContactsEvent(
    UpdateContactsEvent event,
    Emitter<SearchContactsState> emit,
  ) {
    contacts = event.contacts;
    emit(SearchContactsState(contacts));
    if (searchInput.isEmpty) {
      emit(SearchContactsState(contacts));
    } else {
      emit(
        repo.getSearchContacts(inputString: searchInput, contacts: contacts),
      );
    }
  }

  _onAddSearchContactsInputEvent(
    AddSearchContactsInputEvent event,
    Emitter<SearchContactsState> emit,
  ) {
    searchInput = event.searchInput.toLowerCase();
    if (searchInput.isEmpty) {
      emit(SearchContactsState(contacts));
    } else {
      emit(
        repo.getSearchContacts(inputString: searchInput, contacts: contacts),
      );
    }
  }

  _onClearSearchContactsEvent(
    ClearSearchContactsEvent event,
    Emitter<SearchContactsState> emit,
  ) {
    searchInput = "";
    emit(SearchContactsState(contacts));
  }
}
