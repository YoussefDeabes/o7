import 'package:o7therapy/ui/screens/messages/blocs/search_contacts_bloc/search_contacts_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';

abstract class BaseSearchContactsRepo {
  const BaseSearchContactsRepo();

  SearchContactsState getSearchContacts({
    required String inputString,
    required List<ContactItem> contacts,
  });
}

class SearchContactsRepo extends BaseSearchContactsRepo {
  const SearchContactsRepo();

  @override
  SearchContactsState getSearchContacts({
    required String inputString,
    required List<ContactItem> contacts,
  }) {
    final List<ContactItem> updatedContacts = [];
    for (ContactItem contact in contacts) {
      if (contact.groupChannelName != null &&
          (contact.groupChannelName!.toLowerCase().contains(inputString))) {
        updatedContacts.add(contact);
      }
    }
    return SearchContactsState(updatedContacts);
  }
}
