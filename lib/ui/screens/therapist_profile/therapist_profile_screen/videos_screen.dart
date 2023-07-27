import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/mental_health_video.dart';
import 'package:o7therapy/ui/widgets/video_player/video_player.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class VideosScreen extends StatefulWidget {
  final List<VideosModel> videos;
  final double width;

  const VideosScreen({Key? key, required this.videos, required this.width})
      : super(key: key);

  @override
  State<VideosScreen> createState() => _VideosScreenState();
}

class _VideosScreenState extends State<VideosScreen> with Translator {
  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_getVideosList()]));
  }

  Widget _getVideosList() {
    return ListView.builder(
        padding: const EdgeInsets.only(bottom: 13),
        primary: false,
        shrinkWrap: true,
        itemCount: widget.videos.length,
        itemBuilder: (context, index) => _getCardItem(index));
  }

  Widget _getCardItem(int index) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(16)),
            side: BorderSide(color: ConstColors.disabled)),
        child: Column(children: [
          _getHeaderImage(index),
          _getItemDetails(index),
        ]),
      ),
    );
  }

  Widget _getHeaderImage(int index) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
          bottomLeft: Radius.zero,
          bottomRight: Radius.circular(16)),
      child: VideoPlayer(
        url: widget.videos[index].videoLink,
      ),
    );
  }

  Widget _getItemDetails(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _getTitle(index),
        _getAuthorDateRow(index),
      ]),
    );
  }

  Widget _getTitle(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 11.5),
      child: Text(
        widget.videos[index].title,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: ConstColors.text),
      ),
    );
  }

  Widget _getAuthorDateRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.5, bottom: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text(
                translate(LangKeys.published) + " ",
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.textDisabled),
              ),
              Text(
                DateFormat("d-MM-yyyy")
                    .format(widget.videos[index].publishedDate),
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.textDisabled),
              ),
            ],
          ),
          SvgPicture.asset(
            AssPath.bookmarkIcon,
            width: 2,
            // scale: 2,
          )
        ],
      ),
    );
  }
}
