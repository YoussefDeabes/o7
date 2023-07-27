part of 'search_contacts_bloc.dart';

class SearchContactsEvent extends Equatable {
  const SearchContactsEvent();

  @override
  List<Object?> get props => [];
}

class AddSearchContactsInputEvent extends SearchContactsEvent {
  final String searchInput;
  const AddSearchContactsInputEvent(this.searchInput);

  @override
  List<Object> get props => [searchInput];
}

class UpdateContactsEvent extends SearchContactsEvent {
  final List<ContactItem> contacts;
  const UpdateContactsEvent(this.contacts);

  @override
  List<Object> get props => [contacts];
}

class ClearSearchContactsEvent extends SearchContactsEvent {
  const ClearSearchContactsEvent();

  @override
  List<Object> get props => [];
}
