import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/get_started/get_started_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main/home_main_screen.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/home_logged_in/home_logged_in/home_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/splash/bloc/splash_bloc.dart';
import 'package:o7therapy/ui/screens/splash/cubit/refresh_token_cubit.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:o7therapy/util/ui/screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../res/const_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SplashScreen extends BaseStatefulWidget {
  static const routeName = '/splash';

  const SplashScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> baseCreateState() => _SplashScreenState();
}

class _SplashScreenState extends BaseState<SplashScreen> {
  SplashBloc get currentBloc => BlocProvider.of<SplashBloc>(context);
  PackageInfo _packageInfo = PackageInfo(
    appName: 'Unknown',
    packageName: 'Unknown',
    version: 'Unknown',
    buildNumber: 'Unknown',
    buildSignature: 'Unknown',
  );

  @override
  void initState() {
    /// to make full screen
    enterFullScreen();

    /// to start time to switch to another screen
    _startTime();
    _initPackageInfo();
    super.initState();
  }

  @override
  Widget baseBuild(BuildContext context) {
    return BlocListener<SplashBloc, SplashState>(
      listener: (context, state) {
        if (state is EnforceUpdateSuccess) {
          PrefManager.setEnforceUpdate(value: state.enforce.data!.forceUpdate!);
          PrefManager.setStoreLink(state.enforce.data!.storeUrl!);
        }
        if (state is NetworkError) {
          PrefManager.setEnforceUpdate(value: false);
        }
      },
      child: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            FutureBuilder(
                future: PrefManager.getLang(),
                builder:
                    (BuildContext context, AsyncSnapshot<String?> snapshot) {
                  return SizedBox(
                    height: height,
                    width: width,
                    child: SvgPicture.asset(
                      snapshot.data == 'en'
                          ? AssPath.splashBg
                          : AssPath.splashBgAr,
                      fit: BoxFit.cover,
                    ),
                  );
                }),
            // SizedBox(
            //   height: height,
            //   width: width,
            //   child: SvgPicture.asset(
            //     AssPath.splashBg,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            // Column(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Image.asset(
            //       AssPath.appLogo,
            //       scale: 1.5,
            //     ),
            //     Padding(
            //       padding: const EdgeInsets.only(top: 21.85),
            //       child: Text(
            //         translate(LangKeys.slogan),
            //         style: const TextStyle(color: Colors.white, fontSize: 15),
            //       ),
            //     ),
            //   ],
            // ),
          ],
        ),
      ),
    );
  }

  void _startTime() async {
    var _duration = const Duration(milliseconds: 3000);
    bool isLoggedIn = await PrefManager.isLoggedIn();
    bool isFirstLoggedIn = await PrefManager.isFirstLogin();
    Timer(_duration, () => _goToNextScreen(isLoggedIn, isFirstLoggedIn));
  }

  Future _goToNextScreen(bool isLoggedIn, bool isFirstLoggedIn) async {
    if (isFirstLoggedIn) {
      Navigator.of(context).pushReplacementNamed(
        GetStartedScreen.routeName,
      );
    }

    RefreshTokenState state = RefreshTokenCubit.cubit(context).state;
    if (state is FalseRefreshToken) {
      clearData();
      RefreshTokenCubit.cubit(context).reset();
      Navigator.of(context).pushNamedAndRemoveUntil(
        LoginScreen.routeName,
        (Route<dynamic> route) => false,
      );
    }
    await Navigator.of(context).pushReplacementNamed(
      isLoggedIn
          ? HomeMainLoggedInScreen.routeName
          : GetStartedScreen.routeName,
    );
  }

  Future<void> _initPackageInfo() async {
    final info = await PackageInfo.fromPlatform();
    setState(() {
      _packageInfo = info;
    });
    if (_packageInfo.version != ApiKeys.nextAppVersion) {
      currentBloc.add(CheckEnforceUpdate(_packageInfo.version));
    }
  }
}
