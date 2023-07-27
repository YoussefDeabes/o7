import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/insurance/insurance_providers_list/insurance_providers_list.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/send_verification_code_bloc/send_verification_code_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/models/page_two_insurance_data_model.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/page_two_for_no_insurance_status.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_2_insurance_provider_data/page_two_for_unverified_insurance_status.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// edit_insurance_data_screen
class EditInsuranceDataScreen extends BaseScreenWidget {
  static const routeName = '/edit_insurance_data_screen';
  const EditInsuranceDataScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> screenCreateState() {
    return EditInsuranceDataScreenState();
  }
}

class EditInsuranceDataScreenState
    extends BaseScreenState<EditInsuranceDataScreen> {
  late ProviderData? selectedProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    selectedProvider =
        ModalRoute.of(context)?.settings.arguments as ProviderData?;
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<InsuranceStatusBloc, InsuranceStatusState>(
          listener: (context, state) {
            if (state is LoadingInsuranceStatus) {
              showLoading();
            } else {
              hideLoading();
            }
          },
        ),
        BlocListener<SendVerificationCodeBloc, SendVerificationCodeState>(
          listener: (context, state) {
            if (state is LoadingSendingCodeVerification) {
              showLoading();
            } else {
              hideLoading();
            }
          },
        ),
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: Scaffold(
          appBar: AppBarForMoreScreens(title: translate(LangKeys.insurance)),
          body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),

            /// this screen will only opens in 2 status only
            /// 1. NoInsuranceStatus    2. UnVerifiedInsuranceStatus
            child: BlocBuilder<InsuranceStatusBloc, InsuranceStatusState>(
              buildWhen: (context, state) => false,
              builder: (context, state) {
                if (state is NoInsuranceStatus) {
                  return PageTwoForNoInsuranceStatus(
                    insuranceData: PageTwoInsuranceDataModel(
                      providerData: selectedProvider,
                    ),
                  );
                } else if (state is UnVerifiedInsuranceStatus) {
                  final userInsuranceData = PageTwoInsuranceDataModel(
                    membershipNo:
                        int.tryParse(state.insuranceCard.medicalCardNumber),
                    providerData: ProviderData(
                        providerId: 1,
                        providerName: state.insuranceCard.insuranceProvider),
                    expirationDate: state.insuranceCard.dateOfBirth,
                  );
                  return PageTwoForUnVerifiedInsuranceStatus(
                    cardId: state.insuranceCard.cardId,
                    insuranceData: userInsuranceData,
                  );
                } else if (selectedProvider != null) {
                  return PageTwoForNoInsuranceStatus(
                    insuranceData: PageTwoInsuranceDataModel(
                      providerData: selectedProvider,
                    ),
                  );
                } else {
                  return Container();
                  // return PageTwoForNoInsuranceStatus(
                  //   insuranceData: PageTwoInsuranceDataModel(
                  //     providerData: selectedProvider,
                  //   ),
                  // );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
