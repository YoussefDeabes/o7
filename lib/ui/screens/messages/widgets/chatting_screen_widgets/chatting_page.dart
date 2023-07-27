import 'package:flutter/material.dart';
import 'package:o7therapy/ui/screens/messages/blocs/send_bird_messages_bloc/sb_messages_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:o7therapy/ui/screens/messages/models/load_messages_params.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/message_widget_builder.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_separator_widget.dart';

class CattingPage extends StatefulWidget {
  const CattingPage({
    super.key,
    required this.scrollController,
    required this.loadedSBMessagesState,
  });
  final ScrollController scrollController;
  final LoadedSBMessagesState loadedSBMessagesState;

  @override
  State<CattingPage> createState() => _CattingPageState();
}

class _CattingPageState extends State<CattingPage> with WidgetsBindingObserver {
  late final SBMessagesBloc sbMessagesBloc;
  late final ScrollController _scrollController;

  @override
  void initState() {
    sbMessagesBloc = SBMessagesBloc.bloc(context);
    _scrollController = widget.scrollController;
    _scrollController.addListener(_scrollListener);

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        right: 16.0,
        left: 16.0,
      ),
      child: ListView.separated(
        reverse: true,
        itemCount: _getItemsCount,
        controller: _scrollController,
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        shrinkWrap: true,
        separatorBuilder: (context, index) {
          // if the index is the before last index by one
          // if total is 6 last index = 5 and current is 4
          // then did not call the widget separator
          if (index >= (_getItemsCount - 2) &&
              widget.loadedSBMessagesState.hasNext) {
            return const SizedBox.shrink();
          }
          return MessagesSeparatorWidget(
            currentDateTime:
                widget.loadedSBMessagesState.chatMessages[index].createdAt,
            nextDateTime:
                widget.loadedSBMessagesState.chatMessages[index + 1].createdAt,
          );
        },
        itemBuilder: (context, index) {
          /// if has next show circular progress indicator at the last index
          if (_isLastIndex(index) && widget.loadedSBMessagesState.hasNext) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(),
              ),
            );
          }

          /// else return the message widget
          CustomMessage message =
              widget.loadedSBMessagesState.chatMessages[index];
          return MessageWidgetBuilder(
            key: ValueKey(message.messageId),
            customMessage: message,
          );
        },
      ),
    );
  }

  _scrollListener() {
    if (sbMessagesBloc.state is LoadedSBMessagesState) {
      if (_scrollController.offset >=
              _scrollController.position.maxScrollExtent &&
          !_scrollController.position.outOfRange) {
        sbMessagesBloc.add(LoadMoreMessagesEvent(
          loadMessagesParams: LoadMessagesParams(
            timeStamp: (sbMessagesBloc.state as LoadedSBMessagesState)
                .chatMessages
                .last
                .createdAt,
          ),
        ));
      }
    }
  }

  /// get the count of the the list to show in the listView.builder
  /// it will increase by 1 is has next so last item will be the circularProgressIndicator
  int get _getItemsCount => widget.loadedSBMessagesState.hasNext
      ? widget.loadedSBMessagesState.chatMessages.length + 1
      : widget.loadedSBMessagesState.chatMessages.length;

  bool _isLastIndex(int index) => index == _getItemsCount - 1;
}
