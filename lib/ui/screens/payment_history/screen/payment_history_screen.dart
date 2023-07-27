import 'package:flutter/material.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/payment_history/widgets/no_payment_history_page.dart';
import 'package:o7therapy/ui/screens/payment_history/widgets/payment_history_list_page.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class PaymentHistoryScreen extends BaseStatelessWidget {
  static const routeName = '/Payment-history-screen';

  PaymentHistoryScreen({Key? key}) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Scaffold(
      appBar: AppBarForMoreScreens(title: translate(LangKeys.paymentHistory)),
      body: SafeArea(
        child: Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          // TODO bloc to get the data from b
          // child: NoPaymentHistoryPage(),
          child: PaymentHistoryListPage(),
        ),
      ),
    );
  }
}
