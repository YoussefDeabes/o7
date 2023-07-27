import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/remaining_insurance_card_data_bloc/remaining_insurance_card_data_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/screen/search_providers_insurance_screen.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_3_verified_insurance/page_3_verified_insurance.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

import '../../../../api/models/insurance/insurance_providers_list/provider_data.dart';
import '../models/membership_data.dart';
import '../models/page_two_insurance_data_model.dart';
import '../widgets/page_2_insurance_provider_data/page_two_for_terminated_insurance.dart';

// verified_insurance_screen
class VerifiedInsuranceScreen extends BaseScreenWidget {
  static const routeName = '/verified_insurance_screen';
  const VerifiedInsuranceScreen({Key? key}) : super(key: key);

  @override
  BaseScreenState<VerifiedInsuranceScreen> screenCreateState() {
    return _VerifiedInsuranceScreenState();
  }
}

class _VerifiedInsuranceScreenState
    extends BaseScreenState<VerifiedInsuranceScreen> {
  @override
  Widget buildScreenWidget(BuildContext context) {
    return BlocProvider<RemainingInsuranceCardDataBloc>(
      create: (context) => RemainingInsuranceCardDataBloc()
        ..add(const GetRemainingInsuranceCardDataEvent()),
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBarForMoreScreens(title: translate(LangKeys.insurance)),
          body: BlocListener<InsuranceStatusBloc, InsuranceStatusState>(
            listener: (context, state) {
              /// if the user pressed on cancel the insurance
              /// then add(DeleteInsuranceEvent(cardId: widget.verifiedInsuranceData.cardId!));
              /// if the  DeleteInsuranceEvent carefully deleted it will navigate to the page one
              /// else load or show error and no navigation
              if (state is LoadingInsuranceStatus) {
                showLoading();
              } else {
                hideLoading();
              }
              if (state is ExceptionInsuranceStatus) {
                showToast(state.failureMsg);
              } else if (state is NoInsuranceStatus) {
                Navigator.popAndPushNamed(
                  context,
                  SearchProvidersInsuranceScreen.routeName,
                );
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Builder(builder: (context) {
                return BlocConsumer<RemainingInsuranceCardDataBloc,
                    RemainingInsuranceCardDataState>(
                  listener: (context, state) {
                    if (state is LoadingRemainingInsuranceCardData) {
                      showLoading();
                    } else {
                      hideLoading();
                    }
                    if (state is ExceptionRemainingInsuranceCardData) {
                      showToast(state.failureMsg);
                    }
                  },
                  builder: (context, state) {
                    if (state is LoadedRemainingInsuranceCardData) {
                      if (state.verifiedInsuranceData.isTerminated) {
                        return PageTwoForTerminatedInsurance(
                          cardId: state.verifiedInsuranceData.cardId ?? 0,
                          insuranceData: PageTwoInsuranceDataModel(
                              membershipNo:
                                  int.parse(MembershipData().membershipNumber),
                              expirationDate:
                                  state.verifiedInsuranceData.expirationTime,
                              providerData: ProviderData(
                                  providerId: 0,
                                  providerName: state
                                          .verifiedInsuranceData.providerName ??
                                      "")),
                        );
                      }
                      return PageThreeVerifiedInsurance(
                        verifiedInsuranceData: state.verifiedInsuranceData,
                      );
                    } else {
                      return Container();
                    }
                  },
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}
