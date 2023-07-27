import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/messages/blocs/current_opened_chat_bloc/current_opened_chat_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/reply_message_bloc/reply_message_bloc.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_messages_bloc/sb_messages_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/ui/screens/messages/models/load_messages_params.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/can_chat_till_widget.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/chatting_page.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/empty_chatting_page.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/bottom_chat_row.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/custom_error_widget.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class ChattingScreen extends StatefulWidget {
  static const routeName = '/chatting-screen';
  const ChattingScreen({super.key});

  @override
  State<ChattingScreen> createState() => _ChattingScreenState();
}

class _ChattingScreenState extends State<ChattingScreen> {
  late final ScrollController scrollController;
  late final ContactItem? contactItem;

  @override
  void didChangeDependencies() {
    contactItem = ModalRoute.of(context)?.settings.arguments as ContactItem?;
    scrollController = ScrollController();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _closeChatEvent(context);
        return true;
      },
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => SBMessagesBloc()),
            BlocProvider(create: (_) => ReplyMessageBloc()),
          ],
          child: Scaffold(
            appBar: AppBarForMoreScreens(
              title: contactItem?.groupChannelName ?? "",
            ),
            body: Builder(builder: (context) {
              SBMessagesBloc messagesBloc = SBMessagesBloc.bloc(context);
              messagesBloc.add(
                  UpdateGroupChannelSBMessagesEvent(contactItem!.groupChannel));
              messagesBloc.add(const LoadAllPreviousMessagesEvent(
                loadMessagesParams: LoadMessagesParams(reload: true),
              ));

              /// the body will change depending on if there was old chat or not
              /// there is an old chat the CattingPage with old data will show,
              /// else will show the EmptyChattingPage
              return Column(
                children: [
                  Expanded(
                    child: BlocConsumer<SBMessagesBloc, SBMessagesState>(
                      listener: (context, state) {
                        if (state is ExceptionSBMessagesState) {
                          if (state.message != null) {
                            if (state.message == "Session expired") {
                              clearData();
                              Navigator.of(context).pushNamedAndRemoveUntil(
                                  LoginScreen.routeName,
                                  (Route<dynamic> route) => false);
                            }
                            showToast(state.message ?? "");
                          }
                        }
                      },
                      builder: (context, state) {
                        if (state is LoadingSBMessagesState) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (state is EmptyPreviousSBMessagesState) {
                          return const EmptyChattingPage();
                        } else if (state is LoadedSBMessagesState) {
                          if (state.chatMessages.isEmpty) {
                            return const EmptyChattingPage();
                          }
                          return CattingPage(
                            scrollController: scrollController,
                            loadedSBMessagesState: state,
                          );
                        } else if (state is ExceptionSBMessagesState) {
                          return CustomErrorWidget(state.message ?? "");
                        }
                        return const SizedBox.shrink();
                      },
                    ),
                  ),
                  _isClientCanChat
                      ? BottomChatRow(scrollController: scrollController)
                      : CanChatTillWidget(),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }

  bool get _isClientCanChat =>
      contactItem?.canChatTill?.isAfter(DateTime.now()) ?? false;

  _closeChatEvent(BuildContext context) {
    CurrentOpenedChatBloc.bloc(context).add(const CloseChatEvent());
  }
}
