import 'package:flutter/material.dart';
import 'package:o7therapy/ui/screens/messages/blocs/current_opened_chat_bloc/current_opened_chat_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/contact_item.dart';
import 'package:o7therapy/ui/screens/messages/screens/chatting_screen.dart';
import 'package:o7therapy/ui/screens/messages/widgets/contacts_screen_widgets/contact_item_widget/contact_item_widget.dart';
import 'package:o7therapy/ui/screens/messages/widgets/custom_material_page_route.dart';

class ContactItemWidget extends StatelessWidget {
  const ContactItemWidget({super.key, required this.contactItem});
  final ContactItem contactItem;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        CurrentOpenedChatBloc.bloc(context)
            .add(OpenChatEvent(contactItem.channelUrl));
        Navigator.push(
          context,
          CustomMaterialPageRoute(
            builder: (_) => const ChattingScreen(),
            settings: RouteSettings(arguments: contactItem),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: <Widget>[
            ContactTherapistPhoto(
              key: super.key,
              imageUrl: contactItem.groupChannelImage ?? "",
              width: MediaQuery.of(context).size.width,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ContactTherapistName(
                            name: contactItem.groupChannelName ?? ""),
                        ContactTherapistLastMessageTime(
                          lastMessageDateTime: contactItem.lastMessageTime,
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ContactTherapistLastMessage(
                          lastMessage: contactItem.lastMessage ?? "",
                          width: MediaQuery.of(context).size.width,
                        ),
                        ContactTherapistNumberOfMessages(
                          noOfMessage: contactItem.noOfUnreadMessage ?? 0,
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
