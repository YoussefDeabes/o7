import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:o7therapy/api/models/credit_card/Data.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/pay_with_saved_cards_widgets/pay_now_saved_card_button.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/pay_with_saved_cards_widgets/sotred_cards_list_widget.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/payment_details.dart';

class PayWithSavedCardsSection extends StatelessWidget {
  final List<CreditCardData> cardsList;
  final String currency;
  final double sessionFees;
  final ValueNotifier<CreditCardData?> selectedCard;

  const PayWithSavedCardsSection({
    super.key,
    required this.cardsList,
    required this.currency,
    required this.sessionFees,
    required this.selectedCard,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PaymentDetails(),
        StoredCardsListWidget(
          cardsList: cardsList,
          currency: currency,
          sessionFees: sessionFees,
          onDeleteCard: (CreditCardData creditCardData) {},
          selectedCard: selectedCard,
        ),
        // AddInsuranceTextWidget(
        //   therapistData: therapistData,
        //   availableSlotId: slotId,
        //   slotDate: sessionDate,
        // ),
        ValueListenableBuilder<CreditCardData?>(
          valueListenable: selectedCard,
          builder: (_, value, child) {
            return PayNowSavedCardButton(
              onPressed: selectedCard.value == null
                  ? null
                  : () {
                      // context.read<CheckoutBloc>().add(
                      //     BookSessionWithSavedCardEvent(
                      //         promoCode, slotId, sessionFees, isWallet));
                      log(selectedCard.value?.code ?? "");
                    },
            );
          },
        )
      ],
    );
  }
}
