import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class FilteredGuestScreen extends BaseScreenWidget {
  static const routeName = '/filtered-guest-screen';

  const FilteredGuestScreen({Key? key}) : super(key: key);

  @override
  BaseState<FilteredGuestScreen> screenCreateState() =>
      _FilteredGuestScreenState();
}

class _FilteredGuestScreenState extends BaseScreenState<FilteredGuestScreen> {
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

  @override
  Widget buildScreenWidget(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anxiety'),
      ),
      body: _getBody(),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

//Get the content of home guest screen
  Widget _getBody() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: ListView.builder(
          shrinkWrap: true,
          primary: false,
          itemCount: filteredList.length,
          itemBuilder: (context, index) => _getCardItem(index),
        ));
  }

  Widget _getCardItem(int index) {
    return InkWell(
      onTap: () {},
      child: Card(
        elevation: 0,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16),
                topLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
                bottomLeft: Radius.zero),
            side: BorderSide(color: ConstColors.disabled)),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
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
          bottomRight: Radius.circular(51)),
      child: Image.asset(
        filteredList[index]['imageUrl']!,
        fit: BoxFit.fill,
      ),
    );
  }

  Widget _getItemDetails(int index) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, right: 16.0),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        _getTitle(index),
        _getAuthorDateRow(index),
        _getReadTimeRow(index),
      ]),
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

  Widget _getAuthorDateRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            translate(LangKeys.writtenBy) + filteredList[index]['author']!,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ConstColors.textDisabled),
          ),
          Text(
            translate(LangKeys.published) + " " + filteredList[index]['date']!,
            style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w400,
                color: ConstColors.textDisabled),
          ),
        ],
      ),
    );
  }

  Widget _getReadTimeRow(int index) {
    return Padding(
      padding: const EdgeInsets.only(top: 16.5, bottom: 13),
      child: Row(
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
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

}
