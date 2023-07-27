import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/adjust_manager.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/fort_constants.dart';
import 'package:o7therapy/api/mixpanel_manager.dart';
import 'package:o7therapy/api/models/card_pay/card_pay_send_model.dart';
import 'package:o7therapy/api/models/credit_card/Data.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_bloc.dart';
import 'package:o7therapy/ui/screens/checkout/fail_payment_screen/fail_payment_screen.dart';
import 'package:o7therapy/ui/screens/checkout/success_payment_screen/success_payment_screen.dart';
import 'package:o7therapy/ui/screens/checkout/widgets/add_card_widget.dart';
import 'package:o7therapy/ui/screens/checkout/widgets/add_insurance_text_widget.dart';
import 'package:o7therapy/ui/screens/checkout/widgets/payfort_payment_widget.dart';
import 'package:o7therapy/ui/screens/insurance/bloc/insurance_status_bloc/insurance_status_bloc.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/card_number_input_formatter.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/payment_card.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'dart:ui' as ui;

class PaymentDetailsScreen extends BaseScreenWidget {
  static const routeName = '/payment-details-screen';

  const PaymentDetailsScreen({Key? key}) : super(key: key);

  @override
  BaseState<PaymentDetailsScreen> screenCreateState() =>
      _PaymentDetailsScreenState();
}

class _PaymentDetailsScreenState extends BaseScreenState<PaymentDetailsScreen>
    with WidgetsBindingObserver {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController creditCardController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  bool savedCard = false;
  TextEditingController numberController = TextEditingController();
  final PaymentCard _paymentCard = PaymentCard();
  late final Mixpanel _mixpanel;

  // bool storedCards = true;
  int val = 1;
  int selectedPaymentMethod = -1;
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
  late TherapistData therapistData;

  @override
  void initState() {
    super.initState();
    InsuranceStatusBloc.bloc(context).add(const GetInsuranceStatusEvent());

    /// Track with event-name
    _initMixpanel();
    WidgetsBinding.instance.addObserver(this);
    AdjustManager.initPlatformState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    context.read<CheckoutBloc>().add(CheckoutCreditCardEvent());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.inactive:
        break;
      case AppLifecycleState.resumed:
        Adjust.onResume();
        break;
      case AppLifecycleState.paused:
        Adjust.onPause();
        break;
      case AppLifecycleState.detached:
        break;
    }
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is removed from the Widget tree
    numberController.removeListener(_getCardTypeFrmNumber);
    numberController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Future.delayed(Duration.zero).then((_) {
      // context.read<CheckoutBloc>().add(CheckoutCreditCardEvent());
      final args =
          ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
      sessionFees = args['sessionFees'] as double;
      currency = args['currency'] as String;
      slotId = args['slotId'] as String;
      promoCode = args['promoCode'] as String;
      therapistName = args['therapistName'] as String;
      sessionDate = args['sessionDate'] as String;
      therapistData = args['therapistData'] as TherapistData;
      // context.read<CheckoutBloc>().add(CheckoutCreditCardEvent());
    });
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: Scaffold(
          appBar: AppBarForMoreScreens(
            title: translate(LangKeys.bookingConfirmation),
          ),
          resizeToAvoidBottomInset: false,
          body: _getBody(),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocConsumer<CheckoutBloc, CheckoutState>(
      listener: (context, state) {
        if (state is CheckoutLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
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
          context.read<CheckoutBloc>().add(PayNowWithSavedCardEvent(cardModel));
        }
        if (state is PayWithSavedCardSuccess) {
          if (promoCode != "") {
            do {
              Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                  eventToken: ApiKeys.thankYouPageWithPromoEventToken));
            } while (false);
          } else {
            do {
              Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                  eventToken: ApiKeys.thankYouPageWithoutPromoEventToken));
            } while (false);
          }

          /// Success Booking with saved card
          MixpanelBookingBloc.bloc(context).add(
            SuccessfulBookingEvent(
              sessionId: cardModel.sessionId??"",
            ),
          );
          Navigator.of(context)
              .pushReplacementNamed(SuccessPaymentScreen.routeName, arguments: {
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
        List<CreditCardData> cardsList = [];
        if (state is CreditCardsSuccess) {
          for (var element in state.creditCardsList.data!) {
            if (element.isDeleted == true) {
            } else {
              cardsList.add(element);
            }
          }
          cards = cardsList;
          if (cardsList.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: ListView(
                children: [
                  _stepsSlide(),
                  _bookingHeader(),
                  _getStoredCardsCard(state),
                  AddInsuranceTextWidget(
                    therapistData: therapistData,
                    availableSlotId: slotId,
                    slotDate: sessionDate,
                  ),
                  _payNowSavedCardButton(),
                ],
              ),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Column(
                  children: [
                    _stepsSlide(),
                    _bookingHeader(),
                    _getDetailsCard(),
                    AddInsuranceTextWidget(
                      therapistData: therapistData,
                      availableSlotId: slotId,
                      slotDate: sessionDate,
                    ),
                    _payNowButton(),
                  ],
                ),
              ),
            );
          }
        }
        else if (state is FailedCreditCards || state is ErrorState
            // ||
            // state is NetworkError
            ) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Column(
              children: [
                _stepsSlide(),
                _bookingHeader(),
                _getDetailsCard(),
                AddInsuranceTextWidget(
                  therapistData: therapistData,
                  availableSlotId: slotId,
                  slotDate: sessionDate,
                ),
                _payNowButton(),
              ],
            ),
          );
        } else if (state is BookSessionSuccess) {
          return PayfortPaymentWidget(
            callback: (value) {
              if (value == 'success') {
                int i = 0;
                if (promoCode != "") {
                  do {
                    Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                        eventToken: ApiKeys.thankYouPageWithPromoEventToken));
                  } while (false);
                } else {
                  do {
                    Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                        eventToken:
                            ApiKeys.thankYouPageWithoutPromoEventToken));
                  } while (false);
                }

                /// Success Booking with new card
                MixpanelBookingBloc.bloc(context).add(
                  SuccessfulBookingEvent(
                    sessionId:
                        state.bookSession.data?.sessionId?.toString() ?? "",
                  ),
                );

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
        }
        else if (state is AddCardState) {
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
    );
  }

  Widget _stepsSlide() {
    return Padding(
      padding: EdgeInsets.only(top: height / 40, bottom: height / 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                  color: ConstColors.accentColor,
                  width: width / 3,
                  height: 3.5),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              child: Container(
                  color: ConstColors.accentColor,
                  width: width / 3,
                  height: 3.5),
            ),
          ),
        ],
      ),
    );
  }

  //Header for what you will book for
  Widget _bookingHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 24.0),
      child: Text(
        translate(LangKeys.paymentDetails),
        style: const TextStyle(
            color: ConstColors.app, fontSize: 14, fontWeight: FontWeight.w500),
      ),
    );
  }

  //Details card
  Widget _getDetailsCard() {
    return SizedBox(
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _totalFees(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: lineDivider(),
              ),
              _text(translate(LangKeys.cardDetails), FontWeight.w500, 14,
                  ConstColors.app),
              _getCreditCardFormFields(),
              _saveCard(setState),
              _payWithLogosRow(),
            ],
          ),
        ),
      ),
    );
  }

  //Get stored cards data
  Widget _getStoredCardsCard(CreditCardsSuccess state) {
    List<CreditCardData> cardsList = [];
    cardModel.cardCode = state.creditCardsList.data![0].code;
    for (var element in state.creditCardsList.data!) {
      if (element.isDeleted == true) {
      } else {
        cardsList.add(element);
      }
    }
    return SizedBox(
      width: width,
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _totalFees(),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 17.0),
                child: lineDivider(),
              ),
              ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: cardsList.length,
                  itemBuilder: (context, index) => Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Radio<int>(
                                      activeColor: ConstColors.accentColor,
                                      focusColor: ConstColors.accentColor,
                                      value: index + 1,
                                      groupValue: val,
                                      onChanged: (int? value) {
                                        setState(() {
                                          val = value!;
                                          selectedPaymentMethod = index;
                                          cardModel.cardCode = state
                                              .creditCardsList
                                              .data![index]
                                              .code;
                                        });
                                      }),
                                  Text(
                                    translate(LangKeys.endingWith) +
                                        translate(
                                            LangKeys.hashedCreditCardNum) +
                                        cardsList[index].lastFourDigits!,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: ConstColors.app),
                                  )
                                ],
                              ),
                              cardsList[index].brand == 1
                                  ? SvgPicture.asset(AssPath.visaLogo,
                                      height: 10, width: 10)
                                  : cardsList[index].brand == 2
                                      ? Image.asset(AssPath.mastercardLogo,
                                          scale: 40)
                                      : cardsList[index].brand == 3
                                          ? Image.asset(AssPath.amex, scale: 20)
                                          : const SizedBox()
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              cardsList[index].isPreferred! == true
                                  ? AbsorbPointer(
                                      child: TextButton(
                                          onPressed: () {}, child: Container()),
                                    )
                                  : TextButton(
                                      onPressed: () {
                                        _getRemoveModalBottomSheet(
                                            context, index);
                                      },
                                      child: Text(
                                        translate(LangKeys.delete),
                                        style: const TextStyle(
                                            color: ConstColors.error,
                                            fontSize: 12,
                                            fontWeight: FontWeight.w400),
                                      )),
                              cardsList[index].isPreferred! == true
                                  ? Text(
                                      translate(LangKeys.primary),
                                      style: const TextStyle(
                                          color: ConstColors.textDisabled,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    )
                                  : Text(
                                      translate(LangKeys.secondary),
                                      style: const TextStyle(
                                          color: ConstColors.textDisabled,
                                          fontWeight: FontWeight.w400,
                                          fontSize: 12),
                                    )
                            ],
                          ),
                          lineDivider(),
                        ],
                      )),
              _addNewCardButton(),
              _payWithLogosRow(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _addNewCardButton() {
    return Container(
      alignment: AlignmentDirectional.centerStart,
      padding: const EdgeInsets.only(top: 20.0, bottom: 20),
      child: SizedBox(
        width: width * 0.30,
        height: 30,
        child: ElevatedButton(
          onPressed: () {
            _getAddNewCardModalBottomSheet(context);
          },
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: FittedBox(child: Text(translate(LangKeys.addNew))),
        ),
      ),
    );
  }

  //total fees section
  Widget _totalFees() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _text(translate(LangKeys.total), FontWeight.w500, 14, ConstColors.app),
        _text('${sessionFees.toInt()} ${translateCurrency(currency)}',
            FontWeight.w600, 16, ConstColors.text),
      ],
    );
  }

  //Colored Text
  Widget _text(
      String text, FontWeight fontWeight, double fontSize, Color color) {
    return Text(
      text,
      style:
          TextStyle(fontWeight: fontWeight, fontSize: fontSize, color: color),
    );
  }

  //credit card form fields
  Widget _getCreditCardFormFields() {
    return Form(
      key: _formKey,
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
            controller: numberController,
            decoration: InputDecoration(
                labelText: translate(LangKeys.bankCardNumber),
                labelStyle: const TextStyle(
                    color: ConstColors.textGrey,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
                alignLabelWithHint: true),
            onSaved: (String? value) {
              _paymentCard.number = CardUtils.getCleanedNumber(value!);
              creditCardController.text = CardUtils.getCleanedNumber(value);
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
                    _paymentCard.month = expiryDate[0];
                    _paymentCard.year = expiryDate[1];

                    expirationController.text =
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
                    _paymentCard.cvv = int.parse(value!);
                    cvvController.text = value;
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

  //Save card switch
  Widget _saveCard(StateSetter setState) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: width / 14,
          child: Transform.scale(
            scale: 0.6,
            child: CupertinoSwitch(
                value: savedCard,
                activeColor: ConstColors.app,
                onChanged: (value) {
                  setState(() {
                    savedCard = value;
                    rememberMe = value;
                  });
                }),
          ),
        ),
        const SizedBox(width: 10),
        _text(translate(LangKeys.saveCard), FontWeight.w500, 14,
            ConstColors.textSecondary)
      ],
    );
  }

  //Pay with logos row
  Widget _payWithLogosRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            _text(translate(LangKeys.payWith), FontWeight.w400, 12,
                ConstColors.text),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: SvgPicture.asset(
                AssPath.visaLogo,
                height: 10,
                width: 10,
                // scale: 2.5,
              ),
            ),
            Image.asset(
              AssPath.mastercardLogo,
              scale: 40,
            ),
          ],
        ),
        Image.asset(
          AssPath.payfortLogo,
          scale: 3,
        )
      ],
    );
  }

  //Pay now button
  Widget _payNowButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: 20.0, left: width / 10, right: width / 10, bottom: 20),
        child: SizedBox(
          width: width,
          height: 45,
          child: ElevatedButton(
            onPressed: () {
              if (!_formKey.currentState!.validate()) {
                return;
              } else {
                _mixpanel.track("Pay now");
                Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                    eventToken: ApiKeys.payNowEventToken));
                _formKey.currentState!.save();
                context
                    .read<CheckoutBloc>()
                    .add(PayNowEvent(promoCode, slotId, sessionFees, isWallet));
              }
            },
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ))),
            child: Text(translate(LangKeys.payNow)),
          ),
        ),
      ),
    );
  }

  //Pay now button
  Widget _payNowSavedCardButton() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        // alignment: Alignment.center,
        padding: EdgeInsets.only(
            top: 20.0, left: width / 10, right: width / 10, bottom: 20),
        child: SizedBox(
          width: width,
          height: 45,
          child: ElevatedButton(
            onPressed: val != -1
                ? () {
                    _mixpanel.track("Pay now");
                    Adjust.trackEvent(AdjustManager.buildSimpleEvent(
                        eventToken: ApiKeys.payNowEventToken));
                    context.read<CheckoutBloc>().add(
                        BookSessionWithSavedCardEvent(
                            promoCode, slotId, sessionFees, isWallet));
                  }
                : () {},
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ))),
            child: Text(translate(LangKeys.payNow)),
          ),
        ),
      ),
    );
  }

  _getRemoveModalBottomSheet(BuildContext context, int index) {
    return showModalBottomSheet<void>(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                translate(LangKeys.deleteCard),
                style: const TextStyle(
                    color: ConstColors.app,
                    fontSize: 18,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                translate(LangKeys.areYouSureYouWantToDeleteThisCard),
                style: const TextStyle(
                    color: ConstColors.text,
                    fontSize: 14,
                    fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _cancelButton(),
                  const SizedBox(
                    width: 10,
                  ),
                  _removeButton(index),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  Widget _cancelButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Chip(
        backgroundColor: ConstColors.appWhite,
        side: const BorderSide(color: ConstColors.app),
        label: Text(
          translate(LangKeys.cancel),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.app,
          ),
        ),
      ),
    );
  }

  Widget _removeButton(int index) {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
        context.read<CheckoutBloc>().add(DeleteCardEvent(cards[index].code!));
      },
      child: Chip(
        backgroundColor: ConstColors.app,
        label: Text(
          translate(LangKeys.remove),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.appWhite,
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return InkWell(
      onTap: () {
        if (!_formKey.currentState!.validate()) {
          return;
        } else {
          _formKey.currentState!.save();
          context
              .read<CheckoutBloc>()
              .add(PayNowEvent(promoCode, slotId, sessionFees, isWallet));
          Navigator.of(context).pop();
        }
      },
      child: Chip(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        backgroundColor: ConstColors.app,
        label: Text(
          translate(LangKeys.add),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.appWhite,
          ),
        ),
      ),
    );
  }

  _getAddNewCardModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, StateSetter setState) {
          return Padding(
            padding: EdgeInsets.only(
                left: 20.0,
                right: 20.0,
                top: 20.0,
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                _text(translate(LangKeys.addNewCard), FontWeight.w700, 18,
                    ConstColors.app),
                _getCreditCardFormFields(),
                _saveCard(setState),
                _payWithLogosRow(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    _cancelButton(),
                    const SizedBox(
                      width: 10,
                    ),
                    _addButton(),
                  ],
                )
              ],
            ),
          );
        });
      },
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////
  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }

  Future<void> _initMixpanel() async {
    _mixpanel = await MixpanelManager.init();
  }
}
