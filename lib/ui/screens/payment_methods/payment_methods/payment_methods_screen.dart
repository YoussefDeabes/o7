import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_screen_widget.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/models/credit_card/Data.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/auth/login/login_screen.dart';
import 'package:o7therapy/ui/screens/checkout/widgets/add_card_widget.dart';
import 'package:o7therapy/ui/screens/payment_methods/bloc/payment_methods_bloc.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/card_number_input_formatter.dart';
import 'package:o7therapy/ui/screens/payment_methods/widgets/payment_card.dart';
import 'package:o7therapy/ui/widgets/app_bar_more_screens/app_bar_more_screens.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'dart:ui' as ui;

class PaymentMethodsScreen extends BaseScreenWidget {
  static const routeName = '/payment-methods-screen';

  const PaymentMethodsScreen({Key? key}) : super(key: key);

  @override
  BaseState<BaseStatefulWidget> screenCreateState() {
    return _PaymentMethodsScreenState();
  }
}

class _PaymentMethodsScreenState extends BaseScreenState<PaymentMethodsScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController creditCardController = TextEditingController();
  TextEditingController cvvController = TextEditingController();
  TextEditingController expirationController = TextEditingController();
  int val = -1;
  int selectedPaymentMethod = -1;
  bool savedCards = true;
  TextEditingController numberController = TextEditingController();
  final PaymentCard _paymentCard = PaymentCard();

  List<CreditCardData> cards = [];
  List<CreditCardData> allCards = [];

  @override
  void initState() {
    super.initState();
    _paymentCard.type = CardType.Others;
    numberController.addListener(_getCardTypeFrmNumber);
    context.read<PaymentMethodsBloc>().add(PaymentMethodsSuccessEvent());
  }

  @override
  void dispose() {
    numberController.dispose();
    cvvController.dispose();
    creditCardController.dispose();
    expirationController.dispose();

    super.dispose();
  }

  @override
  Widget buildScreenWidget(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBarForMoreScreens(
        title: translate(LangKeys.paymentMethod),
      ),
      body: _getBody(),
      bottomNavigationBar: allCards.isEmpty
          ? const SizedBox()
          : _getWideButton(
              buttonText: translate(LangKeys.addCard),
              fontWeight: FontWeight.w400,
              fontSize: 12.0,
              buttonColor: ConstColors.app,
              textColor: ConstColors.appWhite,
              onPressed: () {
                _getAddNewCardModalBottomSheet(context);
              }),
    ));
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  Widget _getBody() {
    return BlocConsumer<PaymentMethodsBloc, PaymentMethodsState>(
      listener: (context, state) {
        if (state is PaymentMethodsLoadingState) {
          showLoading();
        } else {
          hideLoading();
        }
        if (state is NetworkError) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }

          showToast(state.message);
          context.read<PaymentMethodsBloc>().add(PaymentMethodsSuccessEvent());
        }
        if (state is ErrorState) {
          if (state.message == "Session expired") {
            clearData();
            Navigator.of(context).pushNamedAndRemoveUntil(
                LoginScreen.routeName, (Route<dynamic> route) => false);
          }
          showToast(state.message);
          context.read<PaymentMethodsBloc>().add(PaymentMethodsSuccessEvent());
        }
        if (state is DeleteCardSuccess) {
          context.read<PaymentMethodsBloc>().add(PaymentMethodsSuccessEvent());
          showToast(translate(LangKeys.cardDeletedSuccessfully));
        }

        if (state is SetAsPreferredSuccess) {
          context.read<PaymentMethodsBloc>().add(PaymentMethodsSuccessEvent());
          showToast(translate(LangKeys.cardSavedAsPrimary));
        }
        if (state is PaymentMethodsSuccess) {
          List<CreditCardData> cardsList = [];
          allCards = [];
          cards = [];

          for (var element in state.creditCardsList.data!) {
            if (element.isDeleted == true) {
            } else {
              cardsList.add(element);
              allCards.add(element);
            }
          }

          for (var element in cardsList) {
            if (element.isPreferred == true) {
            } else {
              cards.add(element);
            }
          }
        }
      },
      builder: (context, state) {
        if (state is PaymentMethodsSuccess) {
          List<CreditCardData> cardsList = [];

          for (var element in state.creditCardsList.data!) {
            if (element.isDeleted == true) {
            } else {
              cardsList.add(element);
            }
          }
          if (cardsList.isNotEmpty) {
            return Container(
                margin: const EdgeInsets.symmetric(horizontal: 24.0),
                child: SingleChildScrollView(
                    child: Stack(
                  children: [
                    Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _paymentMethodsCards(state),
                        ]),
                  ],
                )));
          } else {
            return Column(children: [
              _getHeaderBannerSection(),
              _getNoPaymentMethodYetSection(),
              Padding(
                  padding: EdgeInsets.only(
                      top: height / 20, left: width / 10, right: width / 10),
                  child: _getButton(
                      buttonText: translate(LangKeys.addNewCard),
                      fontSize: 14.0,
                      fontWeight: FontWeight.w400,
                      buttonColor: ConstColors.app,
                      textColor: ConstColors.appWhite,
                      onPressed: () {
                        _getAddNewCardModalBottomSheet(context);
                      }))
            ]);
          }
        }
        else if (state is AddCardState) {
          return AddCardWidget(
            callback: (value) {
              context
                  .read<PaymentMethodsBloc>()
                  .add(PaymentMethodsSuccessEvent());
            },
            cvv: cvvController.text,
            expiryDate: expirationController.text.replaceAll('/', ''),
            debuggingEnabled: true,
            cardNum: creditCardController.text,
            token: state.userToken,
            countryCode: state.countryCode,
            ip: state.userIp,
            userId: state.userId,
          );
        }
        else if (state is PaymentMethodsFail) {
          return Column(children: [
            _getHeaderBannerSection(),
            _getNoPaymentMethodYetSection(),
            Padding(
                padding: EdgeInsets.only(
                    top: height / 20, left: width / 10, right: width / 10),
                child: _getButton(
                    buttonText: translate(LangKeys.addNewCard),
                    fontSize: 14.0,
                    fontWeight: FontWeight.w400,
                    buttonColor: ConstColors.app,
                    textColor: ConstColors.appWhite,
                    onPressed: () {
                      _getAddNewCardModalBottomSheet(context);
                    }))
          ]);
        }
        else {
          return const SizedBox();
        }
      },
    );
  }

  //Empty Screen components

  //Header banner section
  Widget _getHeaderBannerSection() {
    return Center(
        child: Padding(
            padding: EdgeInsets.only(top: height / 7),
            child: CircleAvatar(
                foregroundImage: const AssetImage(AssPath.activityBanner),
                backgroundColor: ConstColors.appWhite,
                radius: width / 4)));
  }

  //No payment methods yet text section
  Widget _getNoPaymentMethodYetSection() {
    return Padding(
        padding: EdgeInsets.only(
            top: height / 20, left: width / 10, right: width / 10),
        child: Center(
            child: Text(translate(LangKeys.noPaymentMethodYet),
                style: const TextStyle(
                    color: ConstColors.text,
                    fontSize: 16,
                    fontWeight: FontWeight.w500),
                textAlign: TextAlign.center)));
  }

  //Colored Text
  Widget _text(
      String text, FontWeight fontWeight, double fontSize, Color color) {
    return Text(text,
        style: TextStyle(
            fontWeight: fontWeight, fontSize: fontSize, color: color));
  }

  //credit card form fields
  Widget _getCreditCardFormFields() {
    return Form(
      key: _formKey,
      child: Column(children: <Widget>[
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
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
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
              validator: (value) => CardUtils.validateDate(value, translate),
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
                LengthLimitingTextInputFormatter(3),
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
          )
        ]),
        const SizedBox(height: 8)
      ]),
    );
  }

  //Payment methods list

  //Payment methods column
  Widget _paymentMethodsCards(PaymentMethodsSuccess state) {
    CreditCardData? primaryCard;
    List<CreditCardData> cardsList = [];

    for (var element in state.creditCardsList.data!) {
      if (element.isPreferred == true) {
        if (element.isDeleted != true) {
          primaryCard = element;
        }
      } else {
        if (element.isDeleted == true) {
        } else {
          cardsList.add(element);
        }
      }
    }

    return Padding(
        padding: const EdgeInsets.only(top: 33.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          primaryCard != null
              ? Text(translate(LangKeys.primaryCard),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: ConstColors.app))
              : Container(),
          primaryCard != null
              ? _paymentMethodPrimaryCard(primaryCard, cardsList)
              : Container(),
          cardsList.isEmpty
              ? Container()
              : Text(translate(LangKeys.secondaryCards),
                  style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: ConstColors.app)),
          cardsList.isEmpty
              ? Container()
              : ListView.builder(
                  shrinkWrap: true,
                  primary: false,
                  itemCount: cardsList.length,
                  itemBuilder: (ctx, index) =>
                      _paymentMethodCard(index, cardsList)),
        ]));
  }

  //get payment method card item
  Widget _paymentMethodCard(int index, List<CreditCardData> cards) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Text(
                      translate(LangKeys.hashedCreditCardNum) +
                          cards[index].lastFourDigits!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: ConstColors.text))
                ]),
                cards[index].brand == 1
                    ? SvgPicture.asset(AssPath.visaLogo, height: 10, width: 10)
                    : cards[index].brand == 2
                        ? Image.asset(AssPath.mastercardLogo, scale: 40)
                        : cards[index].brand == 3
                            ? Image.asset(AssPath.amex, scale: 20)
                            : const SizedBox()
              ]),
              const SizedBox(height: 16),
              Text(translate(LangKeys.expDate),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: ConstColors.textDisabled)),
              const SizedBox(height: 10),
              Text(
                  DateFormat("MM/yy").format(
                      DateTime.parse(_getDate(cards[index].expiryDate!))),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ConstColors.textSecondary)),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        InkWell(
                            onTap: () {
                              _getRemoveModalBottomSheet(context, index, cards);
                            },
                            child: Text(translate(LangKeys.delete),
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: ConstColors.error,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500))),
                        InkWell(
                            onTap: () {
                              context
                                  .read<PaymentMethodsBloc>()
                                  .add(SetAsPreferredEvt(cards[index].code!));
                            },
                            child: Text(translate(LangKeys.setAsPrimary),
                                style: const TextStyle(
                                    decoration: TextDecoration.underline,
                                    color: ConstColors.secondary,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)))
                      ]))
            ])));
  }

  //Get set as primary bottom sheet
  _getSetAsPrimaryBottomSheet(BuildContext context, List<CreditCardData> cards,
      CreditCardData primaryCard) {
    int cardIndex = 0;
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter setModalState) {
            return Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  const SizedBox(height: 20),
                  Text(translate(LangKeys.selectOtherCardToDeleteThisCard),
                      style: const TextStyle(
                          color: ConstColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 30),
                  ListView.separated(
                      shrinkWrap: true,
                      primary: false,
                      itemCount: cards.length,
                      separatorBuilder: (_, __) => lineDivider(),
                      itemBuilder: (context, index) {
                        cardIndex = index;
                        return Column(children: [
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 20.0),
                                    child: Row(children: [
                                      Radio<int>(
                                          activeColor: ConstColors.accentColor,
                                          focusColor: ConstColors.accentColor,
                                          value: index + 1,
                                          groupValue: val,
                                          onChanged: (int? value) {
                                            setModalState(() {
                                              val = value!;
                                              selectedPaymentMethod = index;
                                            });
                                            // _handleRadioValueChange(value!);
                                          }),
                                      Text(
                                          translate(LangKeys.endingWith) +
                                              translate(LangKeys
                                                  .hashedCreditCardNum) +
                                              cards[index].lastFourDigits!,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: ConstColors.app))
                                    ])),
                                cards[index].brand == 1
                                    ? SvgPicture.asset(AssPath.visaLogo,
                                        height: 10, width: 10)
                                    : cards[index].brand == 2
                                        ? Image.asset(AssPath.mastercardLogo,
                                            scale: 40)
                                        : cards[index].brand == 3
                                            ? Image.asset(AssPath.amex,
                                                scale: 20)
                                            : const SizedBox()
                              ])
                        ]);
                      }),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: _getButton(
                                buttonText: translate(LangKeys.cancel),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                buttonColor: ConstColors.appWhite,
                                textColor: ConstColors.app,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  numberController.text = "";
                                })),
                        Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: _getButton(
                                buttonText: translate(LangKeys.save),
                                fontSize: 14.0,
                                fontWeight: FontWeight.w400,
                                buttonColor: ConstColors.app,
                                textColor: ConstColors.appWhite,
                                onPressed: val == -1
                                    ? () => null
                                    : () {
                                        if (cards.isNotEmpty) {
                                      context
                                              .read<PaymentMethodsBloc>()
                                              .add(SetAsPreferredEvt(
                                                  cards[cardIndex].code!));
                                          context
                                              .read<PaymentMethodsBloc>()
                                              .add(DeleteCardEvt(
                                                  primaryCard.code!));
                                        } else {
                                          context
                                              .read<PaymentMethodsBloc>()
                                              .add(DeleteCardEvt(
                                                  primaryCard.code!));
                                        }

                                        Navigator.of(context).pop();
                                        numberController.text = "";
                                      }))
                      ])
                ]));
          });
        });
  }

//get payment method primary card item
  Widget _paymentMethodPrimaryCard(
      CreditCardData card, List<CreditCardData> cardsList) {
    return Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  Text(
                      translate(LangKeys.hashedCreditCardNum) +
                          card.lastFourDigits!,
                      style: const TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 20,
                          color: ConstColors.accentColor))
                ]),
                card.brand == 1
                    ? SvgPicture.asset(AssPath.visaLogo, height: 10, width: 10)
                    : card.brand == 2
                        ? Image.asset(AssPath.mastercardLogo, scale: 40)
                        : card.brand == 3
                            ? Image.asset(AssPath.amex, scale: 20)
                            : const SizedBox()
              ]),
              const SizedBox(height: 16),
              Text(translate(LangKeys.expDate),
                  style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: ConstColors.textDisabled)),
              const SizedBox(height: 10),
              Text(
                  DateFormat("MM/yy")
                      .format(DateTime.parse(_getDate(card.expiryDate!))),
                  style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: ConstColors.textSecondary)),
              Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: InkWell(
                      onTap: () async{
                       if( cards.isNotEmpty)
                            {
                              _getSetAsPrimaryBottomSheet(context, cards, card);
                            }
                       else {
                         String? hasActiveSubscription=await SecureStorage.getHasActiveRasselSubscription()??"false";
                         bool isCorporate=await PrefManager.isCorporate()??false;
                         if(bool.parse(hasActiveSubscription)&& !isCorporate){
                             _getCanotDeleteCardModalBottomSheet(context);
                         }else {
                           _getRemovePrimaryCardModalBottomSheet(context, card);

                         }
                      }

                      },
                      child: Text(translate(LangKeys.delete),
                          style: const TextStyle(
                              decoration: TextDecoration.underline,
                              color: ConstColors.error,
                              fontSize: 12,
                              fontWeight: FontWeight.w500))))
            ])));
  }

  //Buttons

  //Get Elevated button
  Widget _getButton(
      {required String buttonText,
      required double fontSize,
      required FontWeight fontWeight,
      required Color buttonColor,
      required Color textColor,
        double? height,
      required Function() onPressed}) {
    return Container(
        alignment: Alignment.center,
        width: width / 2.5,
        child: SizedBox(
            width: width,
            height: height??45,
            child: ElevatedButton(
                onPressed: onPressed,
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(0),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(buttonColor),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                            side: const BorderSide(color: ConstColors.app),
                            borderRadius: BorderRadius.circular(30.0)))),
                child: Text(buttonText,
                    style: TextStyle(
                        fontSize: fontSize,
                        fontWeight: fontWeight,
                        color: textColor)))));
  }

  //Get elevated wide button
  Widget _getWideButton(
      {required String buttonText,
      required double fontSize,
      required FontWeight fontWeight,
      required Color buttonColor,
      required Color textColor,
      required Function() onPressed}) {
    return BlocConsumer<PaymentMethodsBloc, PaymentMethodsState>(
      listener: (context, state) {},
      builder: (context, state) {
        if (state is PaymentMethodsSuccess) {
          return Container(
              padding:
                  EdgeInsets.symmetric(vertical: 20.0, horizontal: width / 6),
              width: width,
              child: SizedBox(
                  width: width / 1.3,
                  height: 45,
                  child: ElevatedButton(
                      onPressed: onPressed,
                      style: ButtonStyle(
                          elevation: MaterialStateProperty.all(0),
                          backgroundColor:
                              MaterialStateProperty.all<Color>(buttonColor),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(30.0)))),
                      child: Text(buttonText,
                          style: TextStyle(
                              fontSize: fontSize,
                              fontWeight: fontWeight,
                              color: textColor)))));
        } else {
          return const SizedBox();
        }
      },
    );
  }

  // Get chip button
  Widget _getChipButton(
      {required String buttonText,
      required double fontSize,
      required FontWeight fontWeight,
      required Color buttonColor,
      required Color textColor,
      required Function() onPressed}) {
    return InkWell(
        onTap: onPressed,
        child: Chip(
            backgroundColor: buttonColor,
            side: const BorderSide(color: ConstColors.app),
            label: Text(buttonText,
                style: TextStyle(
                    fontSize: fontSize,
                    fontWeight: fontWeight,
                    color: textColor))));
  }

  //Modal Bottom sheets

  //Deleting primary card
  _getRemovePrimaryModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16), topLeft: Radius.circular(16)),
        ),
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                const SizedBox(height: 20),
                Text(translate(LangKeys.thisCardCannotBeDeleted),
                    style: const TextStyle(
                        color: ConstColors.text,
                        fontSize: 14,
                        fontWeight: FontWeight.w400),
                    textAlign: TextAlign.center),
                const SizedBox(height: 20),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10.0),
                          child: _getButton(
                              buttonText: translate(LangKeys.cancel),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              buttonColor: ConstColors.appWhite,
                              textColor: ConstColors.app,
                              onPressed: () {
                                Navigator.of(context).pop();
                                numberController.text = "";
                              })),
                      const SizedBox(width: 10),
                      _getButton(
                          buttonText: translate(LangKeys.addCard),
                          fontWeight: FontWeight.w400,
                          fontSize: 12.0,
                          buttonColor: ConstColors.app,
                          textColor: ConstColors.appWhite,
                          onPressed: () {
                            Navigator.of(context).pop();
                            _getAddNewCardModalBottomSheet(context);
                          })
                    ])
              ]));
        });
  }

  _getRemoveModalBottomSheet(
      BuildContext context, int index, List<CreditCardData> cards) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter modalState) {
            return Padding(
                padding: EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(translate(LangKeys.deleteCard),
                      style: const TextStyle(
                          color: ConstColors.app,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Text(translate(LangKeys.deleteCardPermanently),
                      style: const TextStyle(
                          color: ConstColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _getButton(
                              buttonText: translate(LangKeys.cancel),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              buttonColor: ConstColors.appWhite,
                              textColor: ConstColors.app,
                              onPressed: () {
                                Navigator.of(context).pop();
                                numberController.text = "";
                              }),
                          const SizedBox(width: 10),
                          _getButton(
                              buttonText: translate(LangKeys.yesDelete),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              buttonColor: ConstColors.app,
                              textColor: ConstColors.appWhite,
                              onPressed: () {
                                context
                                    .read<PaymentMethodsBloc>()
                                    .add(DeleteCardEvt(cards[index].code!));
                                Navigator.of(context).pop();
                                numberController.text = "";
                              })
                        ]),
                  )
                ]));
          });
        });
  }
  _getRemovePrimaryCardModalBottomSheet(
      BuildContext context, CreditCardData card) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter modalState) {
            return Padding(
                padding: EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child:
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(translate(LangKeys.deleteCard),
                      style: const TextStyle(
                          color: ConstColors.app,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Text(translate(LangKeys.deleteCardPermanently),
                      style: const TextStyle(
                          color: ConstColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _getButton(
                              buttonText: translate(LangKeys.cancel),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              buttonColor: ConstColors.appWhite,
                              textColor: ConstColors.app,
                              onPressed: () {
                                Navigator.of(context).pop();
                                numberController.text = "";
                              }),
                          const SizedBox(width: 10),
                          _getButton(
                              buttonText: translate(LangKeys.yesDelete),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              buttonColor: ConstColors.app,
                              textColor: ConstColors.appWhite,
                              onPressed: () {
                                context
                                    .read<PaymentMethodsBloc>()
                                    .add(DeleteCardEvt(card.code!));
                                Navigator.of(context).pop();
                                numberController.text = "";
                              })
                        ]),
                  )
                ]));
          });
        });
  }

  _getCanotDeleteCardModalBottomSheet(
      BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, StateSetter modalState) {
            return Padding(
                padding: EdgeInsets.only(
                    top: 20.0,
                    left: 20.0,
                    right: 20.0,
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child:
                Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  Text(translate(LangKeys.deleteCard),
                      style: const TextStyle(
                          color: ConstColors.app,
                          fontSize: 18,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 20),
                  Text(translate(LangKeys.thisCardCannotBeDeletedHaveActiveSubscription),
                      style: const TextStyle(
                          color: ConstColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 20),
                  _getButton(
                      buttonText: translate(LangKeys.ok),
                      fontSize: 14,
                      height: 40,
                      fontWeight: FontWeight.w400,
                      buttonColor: ConstColors.app,
                      textColor: ConstColors.appWhite,
                      onPressed: () {
                        Navigator.of(context).pop();
                      }),
                  const SizedBox(height: 20),

                ]));
          });
        });
  }

  //Adding new credit card modal bottom sheet
  _getAddNewCardModalBottomSheet(BuildContext context) {
    return showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(16), topLeft: Radius.circular(16))),
        builder: (BuildContext context) {
          return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                _text(translate(LangKeys.addNewCard), FontWeight.w700, 18,
                    ConstColors.app),
                _getCreditCardFormFields(),
                Padding(
                    // padding: const EdgeInsets.only(top: 15.0),
                    padding: EdgeInsets.only(
                        top: 20.0,
                        left: 20.0,
                        right: 20.0,
                        bottom: MediaQuery.of(context).viewInsets.bottom),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          _getChipButton(
                              buttonText: translate(LangKeys.cancel),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              buttonColor: ConstColors.appWhite,
                              textColor: ConstColors.app,
                              onPressed: () {
                                Navigator.of(context).pop();
                                numberController.text = "";
                              }),
                          const SizedBox(width: 10),
                          _getChipButton(
                              buttonText: translate(LangKeys.add),
                              fontSize: 14.0,
                              fontWeight: FontWeight.w400,
                              buttonColor: ConstColors.app,
                              textColor: ConstColors.appWhite,
                              onPressed: () {
                                if (!_formKey.currentState!.validate()) {
                                  return;
                                } else {
                                  Navigator.of(context).pop();
                                  _formKey.currentState!.save();
                                  context
                                      .read<PaymentMethodsBloc>()
                                      .add(AddCardEvt());
                                  numberController.text = "";
                                }
                              })
                        ]))
              ]));
        });
  }

  String _getDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    String hour = date.substring(8, 10);
    String minute = date.substring(10, 12);
    String second = date.substring(12, 14);
    String formattedDate = "$year-$month-${day}T$hour:$minute:${second}Z";
    return formattedDate;
  }

  void _getCardTypeFrmNumber() {
    String input = CardUtils.getCleanedNumber(numberController.text);
    CardType cardType = CardUtils.getCardTypeFrmNumber(input);
    setState(() {
      _paymentCard.type = cardType;
    });
  }
}
