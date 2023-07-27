import "dart:math" as math;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/res/const_values.dart';
import 'package:o7therapy/ui/screens/messages/blocs/download_file_bloc/download_file_bloc.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/messages_models.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/message_time_and_status.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class DocumentMessageWidget extends StatelessWidget {
  const DocumentMessageWidget({
    super.key,
    required this.documentMessage,
    required this.alignment,
    required this.messageTimeAndStatusWidget,
  });
  final DocumentMessage documentMessage;
  final MessageTimeAndStatus messageTimeAndStatusWidget;
  final Alignment alignment;
  @override
  Widget build(BuildContext context) {
    return BlocProvider<DownloadFileBloc>(
      create: (context) => DownloadFileBloc(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          _DocumentMessage(
              alignment: alignment, documentMessage: documentMessage),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: messageTimeAndStatusWidget,
          ),
        ],
      ),
    );
  }
}

class _DocumentMessage extends StatelessWidget {
  const _DocumentMessage({
    required this.documentMessage,
    required this.alignment,
  });

  final DocumentMessage documentMessage;
  final Alignment alignment;
  static const _radiusShape = ConstValues.messageWidgetRadiusShape;
  static const _noRadius = ConstValues.messageWidgetNoRadius;

  @override
  Widget build(BuildContext context) {
    return BlocListener<DownloadFileBloc, DownloadFileState>(
      listener: (context, state) async {
        if (state is DownloadCompleted) {
          await OpenFilex.open(
            state.file.path,
          );
        }
      },
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          bottomLeft: alignment == Alignment.topLeft ? _noRadius : _radiusShape,
          bottomRight:
              alignment == Alignment.topRight ? _noRadius : _radiusShape,
          topRight: _radiusShape,
          topLeft: _radiusShape,
        ),
        child: (documentMessage.name == null || kIsWeb == true)
            ? const SizedBox.shrink()
            : Container(
                width: MediaQuery.of(context).size.width * 0.6,
                decoration: BoxDecoration(
                  color: Colors.black26.withOpacity(0.5),
                  borderRadius: BorderRadius.only(
                    bottomLeft: alignment == Alignment.topLeft
                        ? _noRadius
                        : _radiusShape,
                    bottomRight: alignment == Alignment.topRight
                        ? _noRadius
                        : _radiusShape,
                    topRight: _radiusShape,
                    topLeft: _radiusShape,
                  ),
                ),
                margin: const EdgeInsets.all(4.0),
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            final Uri documentFileUrl =
                                Uri.parse(documentMessage.fileUrl);
                            if (await canLaunchUrl(documentFileUrl)) {
                              //"https://o7therapy.com/O7bundles.pdf",
                              //"O7bundles.pdf",
                              DownloadFileBloc.bloc(context).add(
                                StartDownloadFileEvent(
                                  url: documentMessage.fileUrl,
                                  fileName: documentMessage.name!,
                                ),
                              );
                            } else {
                              showToast('Oops.. Could not launch link!');
                            }
                          },
                          child: Container(
                            padding: const EdgeInsets.only(bottom: 4),
                            width: MediaQuery.of(context).size.width * 0.5,
                            child: Text(
                              documentMessage.name ?? "----",
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              maxLines: 2,
                              style: const TextStyle(
                                color: ConstColors.secondary,
                                decoration: TextDecoration.underline,
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ),
                        ),
                        BlocBuilder<DownloadFileBloc, DownloadFileState>(
                          builder: (context, state) {
                            if (state is DownloadingPercentage) {
                              return SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(
                                  value: state.percentage.toDouble(),
                                ),
                              );
                            }
                            return const SizedBox.shrink();
                          },
                        )
                      ],
                    ),
                    Text(
                      "${numeric2Bytes(documentMessage.size)}   ${documentMessage.extension ?? ""} ",
                      style: const TextStyle(
                        color: ConstColors.text,
                        fontSize: 11.0,
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  static const List<String> _sizesName = [
    "Bytes",
    "KB",
    "MB",
    "GB",
    "TB",
    "PB",
    "EB",
    "ZB",
    "YB",
  ];

  static const int _bytesNumber = 1000;

  ///  Returns string with binary notation of b bytes,
  ///  rounded to 2 decimal places , eg
  ///  123="123 Bytes", 2345="2.29 KB",
  ///  1234567="1.18 MB", etc
  String numeric2Bytes(int? value) {
    if (value == null || value == 0) {
      return "";
    }
    int indexOfSizeName = (math.log(value) / math.log(_bytesNumber)).floor();
    final int size = value ~/ math.pow(_bytesNumber, indexOfSizeName);
    return '$size ${_sizesName[indexOfSizeName]}';
  }
}
