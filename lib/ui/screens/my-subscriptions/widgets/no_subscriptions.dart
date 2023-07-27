import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class NoSubscriptionsWidget extends BaseScreenWidget {
  const NoSubscriptionsWidget({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _NoSubscriptionsWidgetState();
}

class _NoSubscriptionsWidgetState
    extends BaseScreenState<NoSubscriptionsWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            foregroundImage: const AssetImage(AssPath.activityBanner),
            backgroundColor: ConstColors.appWhite,
            radius: width / 4,
          ),
          const SizedBox(
            height: 20,
          ),
          Padding(
            padding: EdgeInsets.only(bottom: height / 20),
            child: Text(
              translate(LangKeys.noSubscriptionsYet),
              style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: ConstColors.text),
            ),
          )
        ],
      ),
    );
    ;
  }
}
