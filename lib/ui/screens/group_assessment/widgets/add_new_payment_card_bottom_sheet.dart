import 'package:flutter/material.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_card_widgets/add_card_button.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_card_widgets/cancel_button.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_card_widgets/credit_card_form_fields.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_card_widgets/save_card_button.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/payment_card.dart';
import 'package:o7therapy/ui/widgets/pay_with_logos_row.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class AddNewPaymentCardBottomSheetWidget extends StatefulWidget {
  const AddNewPaymentCardBottomSheetWidget({super.key});

  @override
  State<AddNewPaymentCardBottomSheetWidget> createState() =>
      _AddNewPaymentCardBottomSheetWidgetState();
}

class _AddNewPaymentCardBottomSheetWidgetState
    extends State<AddNewPaymentCardBottomSheetWidget> with Translator {
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
      padding: EdgeInsets.only(
          left: 24.0,
          right: 24.0,
          top: 24.0,
          bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            translate(LangKeys.addNewCard),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18,
              color: ConstColors.app,
            ),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const CancelButton(),
              const SizedBox(width: 10),
              AddCardButton(
                onAddCard: () {
                  if (!_formKey.currentState!.validate()) {
                    return;
                  } else {
                    _formKey.currentState!.save();
                    // context
                    //     .read<CheckoutBloc>()
                    //     .add(PayNowEvent(promoCode, slotId, sessionFees, isWallet));
                    Navigator.of(context).pop();
                  }
                },
              ),
            ],
          )
        ],
      ),
    );
  }
}
