import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/messages/blocs/search_contacts_bloc/search_contacts_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/search_contacts_bloc/search_contacts_repo.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_bloc/send_bird_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_channels_bloc/sb_channels_bloc.dart';
import 'package:o7therapy/ui/screens/messages/widgets/contacts_screen_widgets/contacts_list_page.dart';
import 'package:o7therapy/ui/screens/messages/widgets/contacts_screen_widgets/empty_contacts_therapists_messages_list_page.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/custom_error_widget.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class ContactsScreen extends StatelessWidget {
  static const routeName = '/contacts-screen';
  const ContactsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchContactsBloc>(
      create: (_) => SearchContactsBloc(
        repo: const SearchContactsRepo(),
      ),
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBarForMoreScreens(
              title: AppLocalizations.of(context).translate(LangKeys.messages)),
          body: RefreshIndicator(
            onRefresh: () async {
              SBChannelsBloc.bloc(context)
                  .add(const GetExistingSBChannelsEvent(reload: true));
            },
            child: BlocConsumer<SBChannelsBloc, SBChannelsState>(
              listener: (context, state) {
                if (state is LoadedExistingSBChannelsState) {
                  context
                      .read<SearchContactsBloc>()
                      .add(UpdateContactsEvent(state.chatList));
                } else if (state is ExceptionSBChannelsState) {
                  log("state.msg ${state.msg}");
                  if (state.msg == "Session expired") {
                    clearData();
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        LoginScreen.routeName, (Route<dynamic> route) => false);
                    showToast(state.msg);
                  } else if (state.msg.contains("not found")) {
                    SendBirdBloc.bloc(context)
                        .add(const ConnectSendBirdEvent());
                  } else {
                    showToast(state.msg);
                  }
                }
              },
              builder: (context, state) {
                if (state is LoadingSBChannelsState) {
                  return const Center(child: CircularProgressIndicator());
                } else if (state is EmptySBChannelsListState) {
                  return EmptyContactsTherapistsMessagesListPage();
                } else if (state is LoadedExistingSBChannelsState) {
                  if (state.chatList.isEmpty) {
                    return EmptyContactsTherapistsMessagesListPage();
                  }
                  return ContactsListPage(hasNext: state.hasNext);
                } else if (state is ExceptionSBChannelsState) {
                  return CustomErrorWidget(state.msg);
                } else {
                  return const SizedBox.shrink();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
