import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// this widget will appear if there is no items in list
/// ignore: must_be_immutable
class NoDataFoundWidget extends BaseStatelessWidget {
  NoDataFoundWidget({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            backgroundColor: ConstColors.disabled,
            foregroundImage: const AssetImage(AssPath.activityBanner),
            radius: width / 4,
          ),
          Padding(
            padding: EdgeInsets.only(top: height / 20),
            child: Text(
              translate(LangKeys.noDataFound),
              style: const TextStyle(
                  color: ConstColors.text,
                  fontSize: 16,
                  fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
