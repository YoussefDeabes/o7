import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

// ignore: must_be_immutable
class PresentationCard extends BaseStatelessWidget {
  final String title;
  final String description;
  final String image;

  PresentationCard({
    Key? key,
    required this.title,
    required this.description,
    required this.image,
  }) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      margin: EdgeInsets.symmetric(vertical: height * 0.015),
      padding: EdgeInsets.only(top: 0.006 * height, left: 24, right: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        border: Border.all(color: ConstColors.disabled),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [_getTitleAndImageRow(), _getServiceDescription()],
      ),
    );
  }

  _getTitleAndImageRow() {
    return Padding(
      padding: const EdgeInsets.only(top: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width / 2.5,
            child: Text(
              title,
              style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: ConstColors.app),
            ),
          ),
          SvgPicture.asset(
            image,
            width: width * 0.14,
            height: height * .14,
          ),
        ],
      ),
    );
  }

  _getServiceDescription() {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 24),
      child: Text(
        description,
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 14, color: ConstColors.text),
      ),
    );
  }
}
