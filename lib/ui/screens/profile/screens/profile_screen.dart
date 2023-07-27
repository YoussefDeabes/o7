import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/profile/bloc/profile_bloc.dart';
import 'package:o7therapy/ui/widgets/custom_error_widget.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../../../../_base/widgets/base_screen_widget.dart';
import '../../../../_base/widgets/base_stateful_widget.dart';
import '../../../../res/const_colors.dart';
import '../../../../util/lang/app_localization_keys.dart';
import '../../../widgets/app_bar_more_screens/app_bar_more_screens.dart';
import '../widgets/contact_info_widget.dart';
import '../widgets/personal_info_widget.dart';

class ProfileScreen extends BaseScreenWidget {
  static const routeName = '/profile-screen';

  const ProfileScreen({Key? key}) : super(key: key);

  @override
  BaseState screenCreateState() => _ProfileScreenState();
}

class _ProfileScreenState extends BaseScreenState<ProfileScreen> {
  int tabIndex = 0;

  @override
  void initState() {
    context.read<ProfileBloc>().add(const GetProfileInfoEvent());

    super.initState();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBarForMoreScreens(
        title: translate(
          LangKeys.profile,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14.0),
        child: Column(
          children: [
            SizedBox(
              height: height / 70,
            ),
            BlocBuilder<ProfileBloc, ProfileState>(
              builder: (context, state) {
                if (state is LoadingProfileState) {
                  return Center(
                    child: AbsorbPointer(
                      child: ToggleSwitch(
                        initialLabelIndex: tabIndex,
                        textDirectionRTL: true,
                        totalSwitches: 2,
                        cornerRadius: 30.0,
                        minWidth: width / 2,
                        inactiveBgColor: ConstColors.appWhite,
                        inactiveFgColor: ConstColors.textSecondary,
                        activeFgColor: ConstColors.appWhite,
                        radiusStyle: true,
                        borderWidth: 1,
                        labels: [
                          translate(LangKeys.personalInfo),
                          translate(LangKeys.contactInfo)
                        ],
                        onToggle: (index) {},
                      ),
                    ),
                  );
                } else {
                  return Center(
                    child: ToggleSwitch(
                      initialLabelIndex: tabIndex,
                      textDirectionRTL: true,
                      totalSwitches: 2,
                      cornerRadius: 30.0,
                      minWidth: width / 2,
                      inactiveBgColor: ConstColors.appWhite,
                      inactiveFgColor: ConstColors.textSecondary,
                      activeFgColor: ConstColors.appWhite,
                      radiusStyle: true,
                      borderColor: const [ConstColors.disabled],
                      borderWidth: 1,
                      labels: [
                        translate(LangKeys.personalInfo),
                        translate(LangKeys.contactInfo)
                      ],
                      onToggle: (index) {
                        tabIndex = index!;
                        if (index == 0) {
                          setState(() {
                            tabIndex = index;
                          });
                        } else if (index == 1) {
                          setState(() {
                            tabIndex = index;
                          });
                        }
                      },
                    ),
                  );
                }
              },
            ),
            Expanded(
                child: BlocConsumer<ProfileBloc, ProfileState>(
                    listener: (context, state) {
              if (state is LoadingProfileState) {
                showLoading();
              } else {
                hideLoading();
              }
            }, builder: (context, state) {
              if (tabIndex == 0 && state is LoadedProfileState) {
                return PersonalInfoWidget(
                    myProfileWrapper: state.myProfileWrapper);
              } else if (tabIndex == 1 && state is LoadedProfileState) {
                return ContactInfoWidget(
                    myProfileWrapper: state.myProfileWrapper);
              } else if (state is ExceptionProfileState) {
                if (state.exception == "Session expired") {
                  clearData();
                  Navigator.of(context).pushNamedAndRemoveUntil(
                      LoginScreen.routeName, (Route<dynamic> route) => false);
                  showToast(state.exception);
                } else {
                  return CustomErrorWidget(state.exception);
                }
              }
              return const SizedBox();
            }))
          ],
        ),
      ),
    ));
  }
}
