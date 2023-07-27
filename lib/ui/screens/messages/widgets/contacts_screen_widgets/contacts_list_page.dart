import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:o7therapy/ui/screens/booking/widgets/no_data_found_widget.dart';
import 'package:o7therapy/ui/screens/messages/blocs/search_contacts_bloc/search_contacts_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_bloc.dart';

import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/ui/screens/messages/widgets/contacts_screen_widgets/contact_item_widget.dart';
import 'package:o7therapy/ui/screens/messages/widgets/contacts_screen_widgets/search_contacts_text_field.dart';

class ContactsListPage extends StatefulWidget {
  const ContactsListPage({
    super.key,
    required this.hasNext,
  });

  final bool hasNext;
  @override
  State<ContactsListPage> createState() {
    return _ContactsListPageState();
  }
}

class _ContactsListPageState extends State<ContactsListPage> {
  final PagingController<int, ContactItem> _pagingController =
      PagingController(firstPageKey: 0);

  late final SBChannelsBloc _sBChannelsBloc;

  @override
  void initState() {
    super.initState();
    _sBChannelsBloc = SBChannelsBloc.bloc(context);
    _pagingControllerHandler();

    /// adding first state
    // _addPageInPagingController(
    //   // contactItems: widget.firstContactItems,
    //   // hasNext: widget.hasNext,
    // );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SearchContactsTextField(),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: BlocBuilder<SearchContactsBloc, SearchContactsState>(
                builder: (context, state) {
              _refreshPagingController(contactItems: state.contact);
              return PagedListView<int, ContactItem>(
                pagingController: _pagingController,
                shrinkWrap: true,
                builderDelegate: PagedChildBuilderDelegate<ContactItem>(
                  animateTransitions: true,
                  noItemsFoundIndicatorBuilder: (context) {
                    return NoDataFoundWidget();
                  },
                  itemBuilder: (context, item, index) {
                    return ContactItemWidget(
                      key: ValueKey(item.therapistId),
                      contactItem: item,
                    );
                  },
                ),
              );
            }),
          ),
        )
      ],
    );
  }

  void _pagingControllerHandler() {
    /// when the user reach the end of screen this listener will trigger
    /// and add and event to the bloc to get more
    // _pagingController.addPageRequestListener(
    //   (pageKey) => _sBChannelsBloc.add(const GetMoreSBChannelsEvent()),
    // );

    /// listen to SendBirdState state so if it changed this will triggered
    /// and will add the new data to the _pagingController
    _sBChannelsBloc.stream.listen((SBChannelsState state) {
      // if (state is LoadedExistingSBChannelsState) {
      //   log(state.hasNext.toString());
      //   _addPageInPagingController(
      //     contactItems: state.chatList,
      //     hasNext: state.hasNext,
      //   );
      // }
    });
  }

  void _addPageInPagingController({
    required List<ContactItem> contactItems,
    required bool hasNext,
  }) {
    if (!hasNext) {
      _pagingController.appendLastPage(contactItems);
    } else {
      final int nextPageKey = 1 + contactItems.length;
      _pagingController.appendPage(contactItems, nextPageKey);
    }
  }

  void _refreshPagingController({
    required List<ContactItem> contactItems,
  }) {
    _pagingController.refresh();
    _pagingController.appendLastPage(contactItems);
  }
}
