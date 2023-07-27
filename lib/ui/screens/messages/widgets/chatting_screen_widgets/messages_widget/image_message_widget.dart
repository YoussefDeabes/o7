import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_values.dart';
import 'package:o7therapy/ui/screens/messages/models/messages_models/image_message.dart';
import 'package:o7therapy/ui/screens/messages/widgets/chatting_screen_widgets/messages_widget/message_time_and_status.dart';

class ImageMessageWidget extends StatelessWidget {
  const ImageMessageWidget({
    super.key,
    required this.imageMessage,
    required this.alignment,
    required this.messageTimeAndStatusWidget,
  });
  final ImageMessage imageMessage;
  final MessageTimeAndStatus messageTimeAndStatusWidget;
  final Alignment alignment;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _ImageMessage(alignment: alignment, imageMessage: imageMessage),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: messageTimeAndStatusWidget,
        ),
      ],
    );
  }
}

class _ImageMessage extends StatelessWidget {
  const _ImageMessage({
    required this.imageMessage,
    required this.alignment,
  });

  final ImageMessage imageMessage;
  final Alignment alignment;
  static const _radiusShape = ConstValues.messageWidgetRadiusShape;
  static const _noRadius = ConstValues.messageWidgetNoRadius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
        bottomLeft: alignment == Alignment.topLeft ? _noRadius : _radiusShape,
        bottomRight: alignment == Alignment.topRight ? _noRadius : _radiusShape,
        topRight: _radiusShape,
        topLeft: _radiusShape,
      ),
      child: (imageMessage.file != null && kIsWeb == false)
          ? Image.file(imageMessage.file!, fit: BoxFit.cover)
          : CachedNetworkImage(
              fit: BoxFit.cover,
              imageUrl: imageMessage.fileUrl,
              placeholder: (context, url) => const Center(
                  child: Padding(
                padding: EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
    );
  }
}
