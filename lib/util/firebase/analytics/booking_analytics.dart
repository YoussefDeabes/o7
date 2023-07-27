import 'package:firebase_analytics/firebase_analytics.dart';

import 'package:o7therapy/util/firebase/analytics/keys/analytics_event_name.dart';
import 'package:o7therapy/util/firebase/analytics/keys/analytics_param_name.dart';

final class BookingAnalytics {
  const BookingAnalytics._();
  static BookingAnalytics? _instance;
  static BookingAnalytics get i => _instance ??= const BookingAnalytics._();
  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  // Future<void> therapistViewItem({
  //   required int indexInTheList,
  //   required String? therapistName,
  //   required String? therapistId,
  //   required String? currency,
  //   required double? price,
  // }) async {
  //   await _analytics.logViewItem(
  //     items: [
  //       AnalyticsEventItem(
  //         itemId: therapistId,
  //         itemName: therapistName,
  //         index: indexInTheList,
  //         currency: _getCurrency(currency),
  //         price: price,
  //       )
  //     ],
  //   );
  // }

  Future<void> therapistCardClick({
    required String? therapistName,
    required String? therapistId,
  }) async {
    _analytics.logSelectItem(
      itemListId: therapistId,
      itemListName: therapistName,
    );
    _analytics.logEvent(
      name: AnalyticsEventName.therapistCardClick,
      parameters: {
        AnalyticsParamName.therapistId: therapistId,
        AnalyticsParamName.therapistName: therapistName,
      },
    );
  }

  Future<void> bookASessionInBioClick({
    required String? therapistName,
    required String? therapistId,
  }) async {
    _analytics.logEvent(
      name: AnalyticsEventName.bookASessionInBioClick,
      parameters: {
        AnalyticsParamName.therapistId: therapistId,
        AnalyticsParamName.therapistName: therapistName,
      },
    );
  }

  Future<void> nextButtonInScheduleClicked({
    required String? therapistName,
    required String? sessionDateAndTimeInUTC,
    required double? price,
    required String? currency,
  }) async {
    _analytics.logEvent(
      name: AnalyticsEventName.nextButtonInScheduleClicked,
      parameters: {
        AnalyticsParamName.therapistName: therapistName,
        AnalyticsParamName.sessionDateAndTimeInUTC: sessionDateAndTimeInUTC,
        AnalyticsParamName.price: price,
        AnalyticsParamName.currency: _getCurrency(currency),
      },
    );
  }

  Future<void> promoCodeApply({
    required String? promoCode,
    required String? promoCodeStatus,
  }) async {
    _analytics.logEvent(
      name: AnalyticsEventName.promoCodeApply,
      parameters: {
        AnalyticsParamName.promoCode: promoCode,
        AnalyticsParamName.promoCodeStatus: promoCodeStatus,
      },
    );
  }

  Future<void> proceedToPayment({
    required String? promoCode,
    required double? originalPrice,
    required double? totalPrice,
    required String? currency,
    required String? sessionDateAndTimeInUTC,
    required String? therapistID,
    required String? therapistName,
  }) async {
    _analytics.logBeginCheckout(
      value: totalPrice,
      coupon: promoCode,
      currency: _getCurrency(currency),
      items: [
        AnalyticsEventItem(
          itemId: therapistID,
          itemName: therapistName,
          price: totalPrice,
          coupon: promoCode,
          currency: _getCurrency(currency),
          discount:
              totalPrice == null ? 0 : (originalPrice ?? 0) - (totalPrice),
        )
      ],
    );
    _analytics.logEvent(
      name: AnalyticsEventName.proceedToPaymentClick,
      parameters: {
        AnalyticsParamName.promoCode: promoCode,
        AnalyticsParamName.originalPrice: originalPrice,
        AnalyticsParamName.totalPrice: totalPrice,
        AnalyticsParamName.currency: _getCurrency(currency),
        AnalyticsParamName.sessionDateAndTimeInUTC: sessionDateAndTimeInUTC,
      },
    );
  }

  Future<void> successfulBooking({
    required String? sessionId,
    required String? promoCode,
    required double? originalPrice,
    required String? corporateName,
    required double? actualPaidPrice,
    required String? currency,
    required String? therapistID,
    required String? therapistName,
  }) async {
    _analytics.logPurchase(
      value: actualPaidPrice,
      coupon: promoCode,
      currency: _getCurrency(currency),
      items: [
        AnalyticsEventItem(
          itemId: therapistID,
          itemName: therapistName,
          price: actualPaidPrice,
          coupon: promoCode,
          currency: _getCurrency(currency),
          discount: actualPaidPrice == null
              ? 0
              : (originalPrice ?? 0) - (actualPaidPrice),
        )
      ],
    );

    _analytics.logEvent(
      name: AnalyticsEventName.successfulBooking,
      parameters: {
        AnalyticsParamName.sessionId: sessionId,
        AnalyticsParamName.promoCode: promoCode,
        AnalyticsParamName.originalPrice: originalPrice,
        AnalyticsParamName.corporateName: corporateName,
        AnalyticsParamName.totalPrice: actualPaidPrice,
      },
    );
  }

  Future<void> successfulCancelBooking({
    required String? sessionDateAndTimeInUTC,
    required String? currency,
    required String? therapistName,
    required String? sessionId,
  }) async {
    _analytics.logEvent(
      name: AnalyticsEventName.successfulCancelBooking,
      parameters: {
        AnalyticsParamName.sessionId: sessionId,
        AnalyticsParamName.therapistName: therapistName,
        AnalyticsParamName.currency: _getCurrency(currency),
        AnalyticsParamName.sessionDateAndTimeInUTC: sessionDateAndTimeInUTC,
      },
    );
  }

  Future<void> successfulSessionReschedule({
    required String? oldSessionDateAndTimeInUTC,
    required String? oldSessionID,
    required String? newSessionDateAndTimeInUTC,
    required String? newSessionID,
    required String? therapistName,
  }) async {
    _analytics.logEvent(
      name: AnalyticsEventName.successfulSessionReschedule,
      parameters: {
        AnalyticsParamName.oldSessionDateAndTimeInUTC:
            oldSessionDateAndTimeInUTC,
        AnalyticsParamName.oldSessionID: oldSessionID,
        AnalyticsParamName.newSessionDateAndTimeInUTC:
            newSessionDateAndTimeInUTC,
        AnalyticsParamName.newSessionID: newSessionID,
        AnalyticsParamName.therapistName: therapistName,
      },
    );
  }

  Future<void> joinSessionActionEvent({
    required String? sessionDateAndTimeInUTC,
    required String? sessionId,
    required String? therapistName,
  }) async {
    _analytics.logEvent(
      name: AnalyticsEventName.joinSessionActionEvent,
      parameters: {
        AnalyticsParamName.sessionDateAndTimeInUTC: sessionDateAndTimeInUTC,
        AnalyticsParamName.sessionId: sessionId,
        AnalyticsParamName.therapistName: therapistName,
      },
    );
  }

  Future<void> therapistListSort({required String sortType}) async {
    await _analytics.logEvent(
      name: AnalyticsEventName.therapistListSort,
      parameters: {AnalyticsParamName.sortType: sortType},
    );
  }

  /// {filter_by_language: [Arabic, English, Frensh, German],
  /// filter_by_gender: [Male],
  /// accept_new_client: [true],
  /// filter_by_medication: [true],
  /// from_price: 2060,
  /// to_price: 6725}
  Future<void> therapistListFilter({
    bool isSelectFrench = false,
    bool isSelectGerman = false,
    bool isSelectArabic = false,
    bool isSelectEnglish = false,
    String? filterByGender = "not_selected",
    bool isAcceptNewClient = false,
    bool isFilterByMedication = false,
    required int fromPrice,
    required int toPrice,
    required String currency,
  }) async {
    await _analytics.logEvent(
      name: AnalyticsEventName.therapistListFilter,
      parameters: {
        AnalyticsParamName.isSelectFrenchLanguage: isSelectFrench.toString(),
        AnalyticsParamName.isSelectGermanLanguage: isSelectGerman.toString(),
        AnalyticsParamName.isSelectArabicLanguage: isSelectArabic.toString(),
        AnalyticsParamName.isSelectEnglishLanguage: isSelectEnglish.toString(),
        AnalyticsParamName.filterByGender: filterByGender,
        AnalyticsParamName.acceptNewClient: isAcceptNewClient.toString(),
        AnalyticsParamName.filterByMedication: isFilterByMedication.toString(),
        AnalyticsParamName.fromPrice: fromPrice,
        AnalyticsParamName.toPrice: toPrice,
        AnalyticsParamName.currency: _getCurrency(currency),
      },
    );
  }

  Future<void> therapistListSearch({required String searchTerm}) async {
    await _analytics.logSearch(searchTerm: searchTerm);
  }

  String? _getCurrency(String? currency) {
    if (currency == null) {
      return null;
    }
    if (currency.contains('ج.م')) {
      return 'EGP';
    } else if (currency.contains('دولار')) {
      return "USD";
    }
    final String currencyName = currency.toLowerCase().trim();
    if (currencyName == "egp") {
      return "EGP";
    } else if (currencyName == "usd") {
      return "USD";
    } else if (currencyName == "kwd") {
      return "KWD";
    } else {
      return currency;
    }
  }
}
