import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/ewp/widgets/discount_sessions_ewp_page.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/screens/ewp/bloc/ewp_bloc.dart';
import 'package:o7therapy/ui/screens/ewp/widgets/fixed_sessions_number_ewp_page.dart';
import 'package:o7therapy/ui/screens/ewp/widgets/no_ewp_page.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class EwpScreen extends BaseStatelessWidget {
  static const routeName = '/Ewp-screen';

  EwpScreen({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBarForMoreScreens(
        title: translate(LangKeys.employeeWellnessPlan),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: BlocBuilder<EwpBloc, EwpState>(
          builder: (context, state) {
            if (state is LoadingEwpState) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is NoEwpState) {
              return NoEwpPage();
            } else if (state is DiscountSessionsEwpState) {
              return DiscountSessionsEwpPage(ewpViewModel: state.ewpViewModel);
            } else if (state is FixedSessionsNumberEwpState) {
              return FixedSessionsNumberEwpPage(
                  ewpViewModel: state.ewpViewModel);
            } else if (state is ExceptionEwpState) {
              if (state.msg == "Session expired") {
                clearData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false);
              }
              showToast(state.msg);
              return NoEwpPage();
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
