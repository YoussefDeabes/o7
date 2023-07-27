import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/api/send_bird_manager.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/booking/bloc/therapists_booked_before_bloc/therapists_booked_before_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/model/fresh_chat_helper.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/firebase/analytics/auth_analytics.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

/// when log out >> no end point
/// just clear the token and navigate to login screen
class LogoutWidget extends StatelessWidget {
  const LogoutWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () async {
        /// reset the therapist booked before
        TherapistsBookedBeforeBloc.bloc(context)
            .add(const ResetTherapistsBookedBeforeEvent());

        /// when logout also stop notifications of send bird and close connection
        SendBirdManager.logout();

        AuthAnalytics.i.logout();

        /// Should be used when user logs out of the application
        FreshChatHelper.instance.reset();

        /// when log out >> no end point
        /// just clear the token and navigate to login screen
        await SecureStorage.setLoggedIn(value: false);
        await PrefManager.setLoggedIn(value: false).then((value) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              LoginScreen.routeName, (Route<dynamic> route) => false);
        });
      },
      minLeadingWidth: 10,
      contentPadding: EdgeInsets.zero,
      leading: SvgPicture.asset(AssPath.logoutIcon),
      title: Text(context.translate(LangKeys.logout)),
    );
  }
}
