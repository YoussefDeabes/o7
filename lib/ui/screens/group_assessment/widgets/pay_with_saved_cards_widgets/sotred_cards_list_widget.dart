import 'package:flutter/material.dart';
import 'package:o7therapy/api/models/credit_card/Data.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/add_new_payment_card_button.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/pay_with_saved_cards_widgets/payment_card_widget.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/upper_total_fees_row.dart';
import 'package:o7therapy/ui/widgets/pay_with_logos_row.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';

class StoredCardsListWidget extends StatefulWidget {
  final List<CreditCardData> cardsList;
  final String currency;
  final double sessionFees;
  final Function(CreditCardData) onDeleteCard;

  final ValueNotifier<CreditCardData?> selectedCard;

  const StoredCardsListWidget({
    super.key,
    required this.cardsList,
    required this.currency,
    required this.sessionFees,
    required this.onDeleteCard,
    required this.selectedCard,
  });

  @override
  State<StoredCardsListWidget> createState() => _StoredCardsListWidgetState();
}

class _StoredCardsListWidgetState extends State<StoredCardsListWidget> {
  final List<CreditCardData> cardsList = [];
  int selectedGroupValue = 1;

  @override
  void initState() {
    widget.selectedCard.value = widget.cardsList[0];
    for (var element in widget.cardsList) {
      if (element.isDeleted == true) {
      } else {
        cardsList.add(element);
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
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
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: cardsList.length,
                  itemBuilder: (context, index) {
                    return PaymentCardWidget(
                      index: index,
                      onDeleteCard: widget.onDeleteCard,
                      creditCardData: cardsList[index],
                      onChanged: (int? value) {
                        setState(() {
                          selectedGroupValue = value!;
                          widget.selectedCard.value = cardsList[index];
                        });
                      },
                      selectedGroupValue: selectedGroupValue,
                    );
                  }),
              AddNewPaymentCardButton(),
              payWithLogosRow(),
            ],
          ),
        ),
      ),
    );
  }
}
