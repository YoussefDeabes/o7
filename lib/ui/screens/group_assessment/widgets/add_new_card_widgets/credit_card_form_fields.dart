import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/card_number_input_formatter.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/payment_card.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'dart:ui' as ui;

class CreditCardFormFields extends StatefulWidget {
  const CreditCardFormFields({
    super.key,
    required this.formKey,
    required this.paymentCard,
    required this.cvvController,
    required this.expirationController,
    required this.numberController,
  });

  final GlobalKey<FormState> formKey;
  final PaymentCard paymentCard;
  final TextEditingController cvvController;
  final TextEditingController expirationController;
  final TextEditingController numberController;

  @override
  State<CreditCardFormFields> createState() => _CreditCardFormFieldsState();
}

class _CreditCardFormFieldsState extends State<CreditCardFormFields>
    with Translator, ScreenSizer {
  @override
  void initState() {
    super.initState();
    widget.numberController.addListener(_getCardTypeFrmNumber);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    widget.numberController.removeListener(_getCardTypeFrmNumber);
    widget.paymentCard.type = CardType.Others;
    widget.numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    return Form(
      key: widget.formKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            keyboardType: TextInputType.number,
            textDirection: ui.TextDirection.ltr,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(16),
              CardNumberInputFormatter()
            ],
            controller: widget.numberController,
            decoration: InputDecoration(
                labelText: translate(LangKeys.bankCardNumber),
                labelStyle: const TextStyle(
                    color: ConstColors.textGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                alignLabelWithHint: true),
            onSaved: (String? value) {
              widget.paymentCard.number = CardUtils.getCleanedNumber(value!);
              widget.numberController.text = CardUtils.getCleanedNumber(value);
            },
            validator: (value) => CardUtils.validateCardNum(value, translate),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: width / 2.8,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                    CardMonthInputFormatter()
                  ],
                  decoration: InputDecoration(
                      hintText: 'MM/YY',
                      labelText: translate(LangKeys.expiryDate),
                      hintStyle: const TextStyle(
                          color: ConstColors.textGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      labelStyle: const TextStyle(
                          color: ConstColors.textGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      alignLabelWithHint: true),
                  validator: (value) =>
                      CardUtils.validateDate(value, translate),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    List<int> expiryDate = CardUtils.getExpiryDate(value!);
                    widget.paymentCard.month = expiryDate[0];
                    widget.paymentCard.year = expiryDate[1];
                    widget.expirationController.text =
                        expiryDate[1].toString().padLeft(2, "0") +
                            expiryDate[0].toString().padLeft(2, "0");
                  },
                ),
              ),
              SizedBox(
                width: width / 2.8,
                child: TextFormField(
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  decoration: InputDecoration(
                      labelText: translate(LangKeys.cvv),
                      labelStyle: const TextStyle(
                          color: ConstColors.textGrey,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      alignLabelWithHint: true),
                  validator: (value) => CardUtils.validateCVV(value, translate),
                  keyboardType: TextInputType.number,
                  onSaved: (value) {
                    widget.paymentCard.cvv = int.parse(value!);
                    widget.cvvController.text = value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(widget.numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      widget.paymentCard.type = cardType;
    });
  }
}
