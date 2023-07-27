import 'package:bloc/bloc.dart';
import 'package:dart_ipify/dart_ipify.dart';
import 'package:meta/meta.dart';
import 'package:o7therapy/api/fort_constants.dart';
import 'package:o7therapy/api/models/book_session/BookSession.dart';
import 'package:o7therapy/api/models/book_session/book_session_send_model.dart';
import 'package:o7therapy/api/models/card_pay/card_pay_send_model.dart';
import 'package:o7therapy/api/models/card_pay/card_pay_subscribe_send_model.dart';
import 'package:o7therapy/api/models/credit_card/CreditCard.dart';
import 'package:o7therapy/api/models/delete_card/DeleteCard.dart';
import 'package:o7therapy/api/models/promo_code/PromoCode.dart';
import 'package:o7therapy/api/models/reschedule_session/RescheduleSession.dart';
import 'package:o7therapy/api/models/reschedule_session/reschedule_session_send_model.dart';
import 'package:o7therapy/api/models/subscribe/Subscribe.dart';
import 'package:o7therapy/api/models/subscription_send_model/subscribe_send_model.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/checkout/bloc/checkout_repo.dart';

part 'checkout_event.dart';

part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final BaseCheckoutRepo _baseRepo;

  CheckoutBloc(this._baseRepo) : super(CheckoutInitial()) {
    on<CheckoutEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<CheckoutLoadingEvent>(_onCheckoutLoading);
    on<CheckoutSuccessEvent>(_onCheckoutLoaded);
    on<CheckoutPromoCodeEvent>(_onPromoCodePressed);
    on<CheckoutCreditCardEvent>(_onCreditCardsLoading);
    on<PayNowEvent>(_onPayNowPressed);
    on<PayNowRasselSubscribeEvent>(_onPayNowRasselSubscribePressed);
    on<PayNowRescheduleEvent>(_onPayNowReschedulePressed);
    on<ConfirmSessionEvent>(_onConfirmSession);
    on<PayNowWithSavedCardEvent>(_onPayWithSavedCard);
    on<BookSessionWithSavedCardEvent>(_onPayNowWithCardPressed);
    on<SubscribeRasselWithSavedCardEvent>(_onPayNowSubscribeWithCardPressed);
    on<RescheduleSessionWithSavedCardEvent>(_onPayNowRescheduleWithCardPressed);
    on<DeleteCardEvent>(_onDeleteCard);
    on<AddCardEvent>(_onAddCard);
    on<SuccessPaymentScreenEvent>(_onSuccessPaymentScreen);
    on<PayInDebtEvent>(_onPayOnDebt);
    on<PayNowIndebtWithSavedCardEvent>(_onPayIndebtWithSavedCard);
    on<PayNowSubscribeWithSavedCardEvent>(_onPaySubscribeWithSavedCard);
    on<PayNowWithSavedCardRescheduleEvent>(
        _onPayNowWithSavedCardRescheduleSuccess);
  }

  _onCheckoutLoading(CheckoutLoadingEvent event, emit) async {
    emit(CheckoutLoadingState());
  }

  _onCheckoutLoaded(CheckoutSuccessEvent event, emit) async {
    emit(CheckoutSuccessState());
  }

  _onPromoCodePressed(CheckoutPromoCodeEvent event, emit) async {
    // emit( CheckoutLoadingState());
    emit(await _baseRepo.verifyPromoCode(event.promoCode, event.slotId));
  }

  _onCreditCardsLoading(CheckoutCreditCardEvent event, emit) async {
    emit(CheckoutLoadingState());
    emit(await _baseRepo.savedCards());
  }

  _onPayNowPressed(PayNowEvent event, emit) async {
    BookSessionSendModel model = BookSessionSendModel(
        slotId: event.slotId,
        promoCode: event.promoCode,
        isWallet: event.isWallet);
    emit(CheckoutLoadingState());
    emit(await _baseRepo.bookSession(model));
  }

  _onPayNowRasselSubscribePressed(
      PayNowRasselSubscribeEvent event, emit) async {
    SubscribeSendModel model = SubscribeSendModel(
        clientType: event.clientType,
        currency: event.currency,
        subscriptionId: event.clientSubscriptionId);
    emit(CheckoutLoadingState());
    emit(await _baseRepo.subscribeRassel(model));
  }

  _onPayNowSubscribeWithCardPressed(
      SubscribeRasselWithSavedCardEvent event, emit) async {
    emit(CheckoutLoadingState());
    emit(await _baseRepo.subscribeRasselWithSavedCard(event.model));
  }

  _onPayNowReschedulePressed(PayNowRescheduleEvent event, emit) async {
    RescheduleSessionSendModel model =
        RescheduleSessionSendModel(slotId: event.slotId.toString());
    emit(CheckoutLoadingState());
    emit(await _baseRepo.rescheduleSession(int.parse(event.sessionId), model));
  }

  _onConfirmSession(ConfirmSessionEvent event, emit) async {
    BookSessionSendModel model = BookSessionSendModel(
        slotId: event.slotId,
        promoCode: event.promoCode,
        isWallet: event.isWallet);
    emit(CheckoutLoadingState());
    emit(await _baseRepo.confirmSession(model));
  }

  _onPayNowWithCardPressed(BookSessionWithSavedCardEvent event, emit) async {
    BookSessionSendModel model = BookSessionSendModel(
        slotId: event.slotId,
        promoCode: event.promoCode,
        isWallet: event.isWallet);
    emit(CheckoutLoadingState());
    emit(await _baseRepo.bookSessionWithSavedCard(model));
  }



  _onPayNowRescheduleWithCardPressed(
      RescheduleSessionWithSavedCardEvent event, emit) async {
    RescheduleSessionSendModel model =
        RescheduleSessionSendModel(slotId: event.slotId.toString());
    emit(CheckoutLoadingState());
    emit(await _baseRepo.rescheduleSessionWithCard(
        int.parse(event.sessionId), model));
  }

  _onPayNowWithSavedCardRescheduleSuccess(
      PayNowWithSavedCardRescheduleEvent event, emit) async {
    emit(CheckoutLoadingState());
    final ipv4 = await Ipify.ipv4();
    CardPaySendModel model = CardPaySendModel(
        cardCode: event.model.cardCode,
        sessionId: event.model.sessionId,
        customerIp: ipv4,
        returnUrl: FortConstants.returnUrl,
        operationName: FortConstants.merchantExtraReschedule);
    emit(await _baseRepo.payWithCard(model));
  }

  _onPayWithSavedCard(PayNowWithSavedCardEvent event, emit) async {
    emit(CheckoutLoadingState());

    emit(await _baseRepo.payWithCard(event.model));
  }

  _onPayIndebtWithSavedCard(PayNowIndebtWithSavedCardEvent event, emit) async {
    emit(CheckoutLoadingState());
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();

    emit(await _baseRepo.payWithCard(CardPaySendModel(
        cardCode: event.model.cardCode,
        sessionId: "0",
        customerIp: ipv4,
        operationName: FortConstants.merchantExtra,
        returnUrl: FortConstants.cancelSessionReturnUrl)));
  }

  _onPaySubscribeWithSavedCard(
      PayNowSubscribeWithSavedCardEvent event, emit) async {
    emit(CheckoutLoadingState());
    final token = await PrefManager.getToken();
    final ipv4 = await Ipify.ipv4();

    emit(await _baseRepo.paySubscribeWithCard(CardPaySubscribeSendModel(
        cardCode: event.model.cardCode,
        subscriptionId: event.model.subscriptionId,
        customerIp: ipv4)));
  }

  _onDeleteCard(DeleteCardEvent event, emit) async {
    emit(CheckoutLoadingState());
    emit(await _baseRepo.deleteCard(event.code));
  }

  _onAddCard(AddCardEvent event, emit) async {
    emit(CheckoutLoadingState());
    String userIp = await Ipify.ipv4();
    String? token = await PrefManager.getToken();
    String? id = await PrefManager.getId();
    String? countryCode = await PrefManager.getCountryCode();
    emit(AddCardState(
        userIp: userIp,
        userId: id!,
        userToken: token!,
        countryCode: countryCode!));
  }

  _onPayOnDebt(PayInDebtEvent event, emit) async {
    emit(CheckoutLoadingState());
    String userIp = await Ipify.ipv4();
    String? token = await PrefManager.getToken();
    String? id = await PrefManager.getId();
    emit(PayInDebt(userIp: userIp, userId: id!, userToken: token!));
  }

  _onSuccessPaymentScreen(SuccessPaymentScreenEvent event, emit) async {
    emit(CheckoutLoadingState());
    emit(SuccessPaymentScreenState());
  }
}
