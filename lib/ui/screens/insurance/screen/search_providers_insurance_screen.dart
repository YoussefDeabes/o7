import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_list_bloc/insurance_list_bloc.dart';
import 'package:o7therapy/ui/screens/insurance/widgets/page_1_search_insurance_provider/page_1_search_insurance_provider.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

// search_providers_insurance_screen
class SearchProvidersInsuranceScreen extends BaseScreenWidget {
  static const routeName = '/search_providers_insurance_screen';
  const SearchProvidersInsuranceScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> screenCreateState() {
    return _SearchProvidersInsuranceScreenState();
  }
}

class _SearchProvidersInsuranceScreenState
    extends BaseScreenState<SearchProvidersInsuranceScreen> {
  @override
  void initState() {
    InsuranceListBloc.getInsuranceListBloc(context)
        .add(const GetInsuranceListEvent());
    super.initState();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        appBar: AppBarForMoreScreens(title: translate(LangKeys.insurance)),
        body: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: const PageOneSearchInsuranceProvider()),
      ),
    );
  }
}
