import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class PaymentHistoryCard extends BaseStatelessWidget {
  final PaymentHistoryModel paymentModel;
  PaymentHistoryCard({
    required this.paymentModel,
    Key? key,
  }) : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: height * 0.01),
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        border: Border.all(color: ConstColors.disabled),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _getSessionType(),
              _getSessionPriceWithCurrency(),
            ],
          ),
          _getSessionWithWhom(),
          const SizedBox(height: 10),
          _getSessionDate(),
          _getCardPaidWithEndNumber(),
        ],
      ),
    );
  }

  /// get session type
  Widget _getSessionType() {
    return Text(
      paymentModel.sessionType,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: ConstColors.app,
      ),
    );
  }

  /// get what the user paid for the session price and currency
  Widget _getSessionPriceWithCurrency() {
    return Text(
      "${paymentModel.sessionPrice} ${translateCurrency(paymentModel.currency)}",
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: ConstColors.app,
      ),
    );
  }

  /// get the therapist name By whom was with this session
  Widget _getSessionWithWhom() {
    return Text(
      "${translate(LangKeys.withWord)} ${paymentModel.therapistName}",
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: ConstColors.textSecondary,
      ),
    );
  }

  /// get the session date time
  Widget _getSessionDate() {
    return Text(
      "${translate(LangKeys.onWord)} ${DateFormat("d/M/y").format(paymentModel.date)}",
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: ConstColors.text,
      ),
    );
  }

  /// get last part of the
  _getCardPaidWithEndNumber() {
    return RichText(
      text: TextSpan(
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 11,
            color: ConstColors.textDisabled,
          ),
          children: [
            TextSpan(text: translate(LangKeys.cardEndingWith)),
            TextSpan(
              locale: AppLocalizations.supportLocales.first,
              text:
                  "${translate(LangKeys.hashedCreditCardNum)}${paymentModel.lastTreeNumbersOfCard}",
            ),
          ]),
    );
  }
}
