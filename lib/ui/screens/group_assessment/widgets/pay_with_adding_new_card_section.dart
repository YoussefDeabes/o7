import 'package:flutter/material.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_card_widgets/credit_card_form_fields.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_card_widgets/pay_now_button.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_card_widgets/save_card_button.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/colored_text.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/payment_details.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/upper_total_fees_row.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/payment_card.dart';
import 'package:o7therapy/ui/widgets/pay_with_logos_row.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class PayWithAddingNewCardSection extends StatefulWidget {
  final String currency;
  final double sessionFees;

  const PayWithAddingNewCardSection({
    super.key,
    required this.currency,
    required this.sessionFees,
  });

  @override
  State<PayWithAddingNewCardSection> createState() =>
      _PayWithAddingNewCardSectionState();
}

class _PayWithAddingNewCardSectionState
    extends State<PayWithAddingNewCardSection> with Translator {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final PaymentCard paymentCard = PaymentCard();
  final TextEditingController creditCardController = TextEditingController();
  final TextEditingController cvvController = TextEditingController();
  final TextEditingController expirationController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  bool isCardSaved = false;

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        children: [
          PaymentDetails(),
          Card(
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  UpperTotalFessRow(
                    currency: widget.currency,
                    sessionFees: widget.sessionFees,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: lineDivider(),
                  ),
                  ColoredText(
                    translate(LangKeys.cardDetails),
                    FontWeight.w500,
                    14,
                    ConstColors.app,
                  ),
                  CreditCardFormFields(
                    formKey: _formKey,
                    paymentCard: paymentCard,
                    cvvController: cvvController,
                    expirationController: expirationController,
                    numberController: numberController,
                  ),
                  SaveCardButton(
                    isCardSaved: isCardSaved,
                    onSaveChanged: (value) {
                      setState(() => isCardSaved = value);
                    },
                  ),
                  payWithLogosRow(),
                ],
              ),
            ),
          ),
          // AddInsuranceTextWidget(
          //   therapistData: therapistData,
          //   availableSlotId: slotId,
          //   slotDate: sessionDate,
          // ),
          PayNowButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              } else {
                _formKey.currentState!.save();
                // context
                //     .read<CheckoutBloc>()
                //     .add(PayNowEvent(promoCode, slotId, sessionFees, isWallet));
              }
            },
          ),
        ],
      ),
    );
  }
}
