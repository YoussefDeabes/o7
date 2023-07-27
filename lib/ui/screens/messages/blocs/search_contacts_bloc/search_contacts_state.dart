part of 'search_contacts_bloc.dart';

class SearchContactsState extends Equatable {
  final List<ContactItem> contact;
  const SearchContactsState(this.contact);

  @override
  List<Object> get props => [contact];
}
