import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/footer_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/widgets/get_started_widget.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class NoActivityWidget extends BaseStatefulWidget {
  const NoActivityWidget({Key? key}) : super(key: key);

  @override
  BaseState<NoActivityWidget> baseCreateState() => _NoActivityScreenState();
}

class _NoActivityScreenState extends BaseState<NoActivityWidget> {
  @override
  Widget baseBuild(BuildContext context) {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HeaderWidget(
                text: translate(LangKeys.activity),
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
              _getHeaderBannerSection(),
              _getNoActivityYetSection(),
              _getStartNowButton(),
              const FooterWidget(),
            ],
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

//Header banner section
  Widget _getHeaderBannerSection() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: height / 7),
        child: CircleAvatar(
          // backgroundImage: const AssetImage(AssPath.activityBanner),
          foregroundImage: const AssetImage(AssPath.activityBanner),
          // child: SvgPicture.asset(AssPath.activityBanner,fit: BoxFit.cover,),
          backgroundColor: ConstColors.appWhite,
          // backgroundImage: AssetImage(AssPath.defaultImg,),
          radius: width / 4,
        ),
      ),
    );
  }

  //No activity yet text section
  Widget _getNoActivityYetSection() {
    return Padding(
      padding: EdgeInsets.only(
          top: height / 20, left: width / 10, right: width / 10),
      child: Text(
        translate(LangKeys.noActivityYet),
        style: const TextStyle(
            color: ConstColors.text, fontSize: 16, fontWeight: FontWeight.w500),
        textAlign: TextAlign.center,
      ),
    );
  }

  //Start now button
  Widget _getStartNowButton() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
          top: height / 20, left: width / 10, right: width / 10),
      child: SizedBox(
        width: width,
        height: 45,
        child: ElevatedButton(
          onPressed: () => showModalBottomSheet<void>(
            backgroundColor: Colors.white,
            context: context,
            isScrollControlled: true,
            clipBehavior: Clip.antiAlias,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
              topLeft: Radius.circular(16.0),
              topRight: Radius.circular(16.0),
            )),
            builder: (BuildContext context) => GetStartedWidget(),
          ),
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          child: Text(translate(LangKeys.startNow)),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////
}
