import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/therapist_profile_screen.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:shimmer/shimmer.dart';

class MentalHealthJourneyCard extends BaseStatelessWidget {
  final BuildContext context;
  final List<Map<String, String>> filteredList = [
    {
      "imageUrl": AssPath.filteredListImg,
      "title": 'Couples’ Therapy Explained',
      "author": "Natalie Meleika",
      "date": "01-01-2022",
      "duration": "7"
    },
    {
      "imageUrl": AssPath.filteredListImg,
      "title": 'Couples’ Therapy Explained',
      "author": "Natalie Meleika",
      "date": "01-01-2022",
      "duration": "7"
    },
    {
      "imageUrl": AssPath.filteredListImg,
      "title": 'Couples’ Therapy Explained',
      "author": "Natalie Meleika",
      "date": "01-01-2022",
      "duration": "7"
    },
    {
      "imageUrl": AssPath.filteredListImg,
      "title": 'Couples’ Therapy Explained',
      "author": "Natalie Meleika",
      "date": "01-01-2022",
      "duration": "7"
    },
    {
      "imageUrl": AssPath.filteredListImg,
      "title": 'Couples’ Therapy Explained',
      "author": "Natalie Meleika",
      "date": "01-01-2022",
      "duration": "7"
    }
  ];

  MentalHealthJourneyCard({Key? key,required this.context}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return SizedBox(
        height: height / 2,
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          scrollDirection: Axis.horizontal,
          itemCount: filteredList.length,
          itemBuilder: (context, index) => _getCardItem(index),
        ));
  }

  Widget _getCardItem(int index) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () {},
        child: SizedBox(
          height: height / 2,
          width: width * 0.55,
          child: Card(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: Directionality.of(context) == TextDirection.ltr
                  ? const BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.circular(16),
                      bottomLeft: Radius.zero)
                  : const BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16),
                      bottomRight: Radius.zero,
                      bottomLeft: Radius.circular(16),
                    ),
            ),
            margin: const EdgeInsets.symmetric(vertical: 8.0),
            child: Column(children: [
              _getHeaderImage(index),
              _getItemDetails(index),
            ]),
          ),
        ),
      ),
    );
  }

  Widget _getHeaderImage(int index) {
    return SizedBox(
      height: height * 0.30,
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomRight: Radius.circular(51)),
        child: Image.asset(
          filteredList[index]['imageUrl']!,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  Widget _getItemDetails(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _getTitle(index),
        _getPublishedDate(index),
        _getReadTimeRow(index),
      ]),
    );
  }

  Widget _getPublishedDate(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 11.5),
      child: Text(
        filteredList[index]['date']!,
        style: const TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w400,
            color: ConstColors.textDisabled),
      ),
    );
  }

  Widget _getTitle(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 11.5),
      child: Text(
        filteredList[index]['title']!,
        style: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w600, color: ConstColors.text),
      ),
    );
  }

  Widget _getReadTimeRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.5, bottom: 13),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgPicture.asset(
                AssPath.timerIcon,
                // scale: 3.5,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Text(
                  filteredList[index]['duration']! +
                      " " +
                      translate(LangKeys.minRead),
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: ConstColors.text),
                ),
              ),
            ],
          ),
          SvgPicture.asset(
            AssPath.bookmarkIcon,
            // scale: 3.5,
          )
        ],
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

}
