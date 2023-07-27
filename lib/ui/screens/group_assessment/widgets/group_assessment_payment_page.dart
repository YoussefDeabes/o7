import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:o7therapy/_base/screen_sizer.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/api/fort_constants.dart';
import 'package:o7therapy/api/models/card_pay/card_pay_send_model.dart';
import 'package:o7therapy/api/models/credit_card/Data.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_bloc.dart';
import 'package:o7therapy/ui/screens/checkout/fail_payment_screen/fail_payment_screen.dart';
import 'package:o7therapy/ui/screens/checkout/success_payment_screen/success_payment_screen.dart';
import 'package:o7therapy/ui/screens/checkout/widgets/add_card_widget.dart';
import 'package:o7therapy/ui/screens/checkout/widgets/payfort_payment_widget.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/pay_with_adding_new_card_section.dart';
import 'package:o7therapy/ui/screens/group_assessment/widgets/pay_with_saved_cards_section.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/payment_card.dart';

import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';

class GroupAssessmentPaymentPage extends StatefulWidget {
  const GroupAssessmentPaymentPage({super.key});

  @override
  State<GroupAssessmentPaymentPage> createState() =>
      _GroupAssessmentPaymentPageState();
}

class _GroupAssessmentPaymentPageState extends State<GroupAssessmentPaymentPage>
    with Translator, ScreenSizer {
  TextEditingController creditCardController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  bool savedCard = false;
  // TextEditingController numberController = TextEditingController();
  final PaymentCard _paymentCard = PaymentCard();

  double sessionFees = 0.0;
  String currency = "";
  String slotId = "";
  String promoCode = "";
  bool isWallet = false;
  String expiryDate = "";
  bool rememberMe = false;
  String code = "";
  String therapistName = "";
  String sessionDate = "";
  CardPaySendModel cardModel = CardPaySendModel();
  List<CreditCardData> cards = [];
  // late TherapistData therapistData;

  @override
  void initState() {
    super.initState();
    InsuranceStatusBloc.bloc(context).add(const GetInsuranceStatusEvent());
    _paymentCard.type = CardType.Others;

    /// get cards form back end
    // context.read<CheckoutBloc>().add(CheckoutCreditCardEvent());
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero).then((_) {
      // context.read<CheckoutBloc>().add(CheckoutCreditCardEvent());
      // final args =
      //     ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      // sessionFees = args['sessionFees'] as double;
      // currency = args['currency'] as String;
      // slotId = args['slotId'] as String;
      // promoCode = args['promoCode'] as String;
      // therapistName = args['therapistName'] as String;
      // sessionDate = args['sessionDate'] as String;
      // therapistData = args['therapistData'] as TherapistData;
      // context.read<CheckoutBloc>().add(CheckoutCreditCardEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    initScreenSizer(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: BlocConsumer<CheckoutBloc, CheckoutState>(
        listener: (context, state) {
          if (state is NetworkError) {
            showToast(state.message);
          }
          if (state is ErrorState) {
            showToast(state.message);
          }
          if (state is BookSessionWithSavedCardSuccess) {
            cardModel.customerIp = state.ip;
            cardModel.sessionId = state.bookSession.data!.sessionId!.toString();
            cardModel.returnUrl = FortConstants.returnUrl;
            cardModel.operationName = FortConstants.merchantExtra;
            context
                .read<CheckoutBloc>()
                .add(PayNowWithSavedCardEvent(cardModel));
          }
          if (state is PayWithSavedCardSuccess) {
            Navigator.of(context).pushReplacementNamed(
                SuccessPaymentScreen.routeName,
                arguments: {
                  "therapistName": therapistName,
                  "sessionDate": sessionDate,
                });
          }
          if (state is PayWithSavedCardFailed) {
            showToast(state.message);
            Navigator.of(context)
                .pushReplacementNamed(FailPaymentScreen.routeName);
          }
          if (state is DeleteCardSuccess) {
            showToast(translate(LangKeys.cardDeletedSuccessfully));
            context.read<CheckoutBloc>().add(CheckoutCreditCardEvent());
          }
        },
        builder: (context, state) {
          if (state is CheckoutLoadingState) {
            return const CircularProgressIndicator();
          } else if (state is CreditCardsSuccess) {
            if (state.creditCardsList.data?.isNotEmpty ?? false) {
              /// show all the Cards
              return PayWithSavedCardsSection(
                cardsList: state.creditCardsList.data!,
                currency: currency,
                sessionFees: sessionFees,
                selectedCard: ValueNotifier(null),
              );
            } else {
              /// add new card section
              return PayWithAddingNewCardSection(
                currency: currency,
                sessionFees: sessionFees,
              );
            }
          } else if (state is FailedCreditCards ||
              state is ErrorState ||
              state is NetworkError) {
            return PayWithAddingNewCardSection(
              currency: currency,
              sessionFees: sessionFees,
            );
          } else if (state is BookSessionSuccess) {
            return PayfortPaymentWidget(
              callback: (value) {
                if (value == 'success') {
                  Navigator.of(context).pushReplacementNamed(
                      SuccessPaymentScreen.routeName,
                      arguments: {
                        "therapistName": therapistName,
                        "sessionDate": sessionDate
                      });
                } else if (value == 'fail') {
                  Navigator.of(context)
                      .pushReplacementNamed(FailPaymentScreen.routeName);
                }
              },
              cardHolderName: '',
              cvv: cvvController.text,
              expiryDate: expirationController.text.replaceAll('/', ''),
              rememberMe: savedCard,
              debuggingEnabled: true,
              sessionId: state.bookSession.data!.sessionId!.toString(),
              token: state.token,
              ip: state.ip,
              cardNum: creditCardController.text,
            );
          } else if (state is AddCardState) {
            return AddCardWidget(
                cardNum: creditCardController.text,
                cvv: cvvController.text,
                expiryDate: expirationController.text,
                callback: (callback) {},
                userId: state.userId,
                countryCode: state.countryCode,
                ip: state.userIp,
                token: state.userToken);
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
