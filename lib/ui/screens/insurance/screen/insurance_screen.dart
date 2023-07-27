import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/screen/edit_insurance_data_screen.dart';
import 'package:o7therapy/ui/screens/insurance/screen/search_providers_insurance_screen.dart';
import 'package:o7therapy/ui/screens/insurance/screen/verified_insurance_screen.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class InsuranceScreen extends BaseStatefulWidget {
  static const routeName = '/insurance_screen';
  const InsuranceScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> baseCreateState() {
    return InsuranceDataSnState();
  }
}

class InsuranceDataSnState extends BaseState<InsuranceScreen> {
  @override
  void initState() {
    super.initState();
    InsuranceStatusBloc.bloc(context).add(const GetInsuranceStatusEvent());
  }

  @override
  Widget baseBuild(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        body: BlocConsumer<InsuranceStatusBloc, InsuranceStatusState>(
          buildWhen: (previous, current) {
            if (previous is LoadingInsuranceStatus &&
                current is ExceptionInsuranceStatus) {
              InsuranceStatusBloc.bloc(context)
                  .add(const GetInsuranceStatusEvent());
              return true;
            }
            return current is LoadingInsuranceStatus ||
                current is NoInsuranceStatus ||
                current is VerifiedInsuranceStatus ||
                current is UnVerifiedInsuranceStatus;
          },
          builder: (context, state) {
            if (state is NoInsuranceStatus) {
              return const SearchProvidersInsuranceScreen();
            } else if (state is VerifiedInsuranceStatus) {
              return const VerifiedInsuranceScreen();
            } else if (state is UnVerifiedInsuranceStatus) {
              return const EditInsuranceDataScreen();
            }
            return const SizedBox.shrink();
          },
          listener: (context, state) {
            log(" Insurance status is: ${state.toString()}");
            if (state is LoadingInsuranceStatus) {
              showLoading();
            } else {
              hideLoading();
            }
            if (state is ExceptionInsuranceStatus) {
              if (state.failureMsg == "Session expired") {
                clearData();
                Navigator.of(context).pushNamedAndRemoveUntil(
                    LoginScreen.routeName, (Route<dynamic> route) => false);
              }
              showToast(state.failureMsg);
            }
          },
        ),
      ),
    );
  }
}
