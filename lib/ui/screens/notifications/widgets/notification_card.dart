import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/api/models/notifications/notification_model.dart';
import 'package:o7therapy/api/pdf_api.dart';

import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/notifications/bloc/notifications_bloc.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:open_filex/open_filex.dart';

class NotificationCard extends StatefulWidget {
  final NotificationModel notification;
  final List<NotificationModel> allNotifications;
  final BuildContext context;

  const NotificationCard(
      {required this.notification,
      required this.allNotifications,
      required this.context,
      Key? key})
      : super(key: key);

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard>
    with Translator, ScreenSizer {
  bool hasUrl = false;
  String text = "";
  String firstTextPart = "";
  String url = "";
  String lastTextPart = "";
  String? filePath = "";

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    return Container(
      margin: EdgeInsets.only(top: height * 0.01),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(
        horizontal: 14,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        border: Border.all(color: ConstColors.disabled),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getNotificationTitle(),
              _getRedDotIfNewNotification(),
            ],
          ),
          const SizedBox(height: 10),
          _getNotificationContent(),
          const SizedBox(height: 10),
          _getNotificationDate(),
        ],
      ),
    );
  }

  /// get Notification Title
  Widget _getNotificationTitle() {
    return Wrap(
      children: [
        SizedBox(
          width: width * 0.75,
          child: Text(
            widget.notification.title,
            maxLines: 2,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: ConstColors.app,
            ),
          ),
        ),
      ],
    );
  }

  /// detect url from text of notification body
  getTextAndUrlFromNotification() {
    text = widget.notification.body;
    RegExp exp = RegExp(r'(?:(?:https?|ftp):\/\/)?[\w/\-?=%.]+\.[\w/\-?=%.]+');
    Iterable<RegExpMatch> matches = exp.allMatches(text);

    if (matches.isNotEmpty) {
      hasUrl = true;
      dynamic match = matches.elementAt(0);
      firstTextPart =
          match.start != 0 ? text.substring(0, match.start - 1) : "";
      lastTextPart = (match.end != text.length)
          ? text.substring(match.end + 1, text.length)
          : "";
      url = text.substring(match.start, match.end);
    }
  }

  /// get Notification Content
  Widget _getNotificationContent() {
    getTextAndUrlFromNotification();
    return hasUrl
        ? RichText(
            text: TextSpan(children: [
              WidgetSpan(
                  child: SelectableText(
                firstTextPart,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: ConstColors.text,
                ),
              )),
              TextSpan(
                  text: url,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    color: ConstColors.secondary,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () async {
                      if (await canLaunchUrl(Uri.parse(url))) {
                        _launchUrl(context);
                      } else {
                        throw 'Could not launch $url';
                      }
                    }),
              WidgetSpan(
                  child: SelectableText(
                lastTextPart,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: ConstColors.text,
                ),
              )),
            ]),
          )
        : SelectableText(
            widget.notification.body,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w400,
              color: ConstColors.text,
            ),
          );
  }

  /// get Notification Date time
  Widget _getNotificationDate() {
    return Text(
      _getSentDate(),
      style: const TextStyle(
        fontSize: 10,
        fontWeight: FontWeight.w300,
        color: ConstColors.textSecondary,
      ),
    );
  }

  /// get this dot if the user did not read the notification yet
  Widget _getRedDotIfNewNotification() {
    return widget.notification.status == 3
        ? const SizedBox.shrink()
        : const CircleAvatar(
            backgroundColor: ConstColors.other,
            radius: 5,
          );
  }

  //// helper Methods /////
  /// get Sent Date
  String _getSentDate() {
    // "${translate(LangKeys.onWord)} ${DateFormat("d/M/y").format(notification.sentDate)}"
    String dateWithT = widget.notification.sentDate.substring(0, 8) +
        'T' +
        widget.notification.sentDate.substring(8);
    DateTime dateTime = DateTime.parse(dateWithT);
    return "${translate(LangKeys.onWord)} ${DateFormat("d/M/y").format(dateTime.toLocal())}";
  }

  Future _launchUrl(BuildContext context) async {
    if (url.contains(".pdf")) {
      await PDFAPI.loadNetwork(url).then((value) => filePath = value.path);
      await OpenFilex.open(filePath);
    } else {
      if (Platform.isIOS) {
        await launchUrl(
          Uri.parse(url),
        );
              } else {
        await launchUrl(
          Uri.parse(url),
          mode: LaunchMode.externalNonBrowserApplication,
        );
      }
    }
   }

  void changeState() {
    setState(() {});
  }

  @override
  void runChangeState() {
    changeState();
  }

  @override
  State provideTranslate() {
    return this;
  }
}
