import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/extensions/string_extensions.dart';
import 'package:intl/intl.dart' show DateFormat;

mixin TherapistCardsMixin {
  late TherapistData _therapistModelData;
  late String Function(String) _translateFunction;
  late AppLocalizations _appLocal;
  therapistCardsMixinInit({
    required TherapistData therapistModel,
    required String Function(String) translate,
    required AppLocalizations appLocal,
  }) {
    _therapistModelData = therapistModel;
    _translateFunction = translate;
    _appLocal = appLocal;
  }

  /// Yesterday : calculateDifference(date) == -1.
  /// Today : calculateDifference(date) == 0.
  /// Tomorrow : calculateDifference(date) == 1.
  int calculateDifferenceInDays(DateTime date) {
    DateTime now = DateTime.now();
    return DateTime(date.year, date.month, date.day)
        .difference(DateTime(now.year, now.month, now.day))
        .inDays;
  }

  /// 1. Therapist has [no slots] and [accepts a new client]
  /// The Availability on the card should be “No Available slots”
  /// 2. Therapist has [no slots] and [does not accept a new client]
  /// The Availability on the card should be Not Available
  /// 3. Therapist has [slots] and [does not accept a new client]
  /// The Availability on the card should be Not Accepting New Clients
  String getTherapistAvailabilityString() {
// the string form "first_available_slot_date": "20220804130000"
    if (!_isThereFirstAvailableSlotDate && _isAcceptNewClient) {
      // return "No Available slots";
      return _translateFunction(LangKeys.noAvailableSlots);
    } else if (!_isThereFirstAvailableSlotDate && !_isAcceptNewClient) {
      // return "Not Available";
      return _translateFunction(LangKeys.notAvailable);
    } else if (_isThereFirstAvailableSlotDate && !_isAcceptNewClient) {
      // return "Not Accepting New Clients";
      return _translateFunction(LangKeys.notAcceptsNewClients);
    } else {
      String dateWithT =
          '${_therapistModelData.firstAvailableSlotDate!.substring(0, 8)}T${_therapistModelData.firstAvailableSlotDate!.substring(8)}Z';

      DateTime dateTime = DateTime.parse(dateWithT).toLocal();

      // log(dateTime.isUtc());

      String hours = DateFormat('h')
          .format(dateTime)
          .translateDigits(languageCode: _appLocal.locale.languageCode);

      String minutes = DateFormat('mm')
          .format(dateTime)
          .translateDigits(languageCode: _appLocal.locale.languageCode);

      String amAndPmAbbreviation =
          DateFormat('a').format(dateTime).toLowerCase();
      String dayAndMonth = DateFormat("MMM d,").format(dateTime);
      if (calculateDifferenceInDays(dateTime) == 1) {
        dayAndMonth = _translateFunction(LangKeys.tomorrow);
      } else if (calculateDifferenceInDays(dateTime) == 0) {
        dayAndMonth = _translateFunction(LangKeys.today);
      }
      return "${_translateFunction(LangKeys.available)} $dayAndMonth ${_translateFunction(LangKeys.at)} $hours:$minutes $amAndPmAbbreviation";
    }
  }

  String getStatusString() {
    // flat rate is false then >> user is not have insurance or ewp >> and show the price
    // if true I need to check if the user is ewp or insurance again to handle the status
    if (_therapistModelData.flatRate == null ||
        _therapistModelData.flatRate == false) {
      return _getPricePerSession();
    } else {
      if (_therapistModelData.clientStatus == ClientStatus.ewpClient) {
        return _translateFunction(LangKeys.coveredByEWP);
      } else {
        return _translateFunction(LangKeys.coveredByInsurance);
      }
      // return _translateFunction(LangKeys.coveredByInsurance);
      // return _translateFunction(LangKeys.coveredByEWP);
      //! will remove next line
      // return _getPricePerSession();
    }
  }

  String _getPricePerSession() {
    String price = _therapistModelData.feesPerSession!
        .toInt()
        .translateStringDigits(languageCode: _appLocal.locale.languageCode);
    String currency = _therapistModelData.currency ?? "";

    return "$price $currency";
  }

  /// get the Therapist Spoken Languages String from list
  String getTherapistSpokenLanguagesString() {
    StringBuffer buffer = StringBuffer();
    if (_therapistModelData.languages != null) {
      final List<String> languages = _therapistModelData.languages!;
      for (int i = 0; i < languages.length; i++) {
        /// the next line to get the first 2 chars of languages only
        final String language = "${languages[i][0]}${languages[i][1]}";
        if (i != languages.length - 1) {
          buffer.write("$language, ");
        } else {
          buffer.write(language);
        }
      }
    }
    return buffer.toString();
  }

  /// get the Therapist Skills String from list
  String getTherapistTagsString() {
    StringBuffer buffer = StringBuffer();
    for (int i = 0; i < _therapistModelData.tags!.length; i++) {
      if (i != _therapistModelData.tags!.length - 1) {
        buffer.write("${_therapistModelData.tags![i]}, ");
      } else {
        buffer.write(_therapistModelData.tags![i]);
      }
    }
    return buffer.toString();
  }

  /// get the calender icon for the availability depend on accept new clients or not available
  String getCalenderIcon() {
    if (_isThereFirstAvailableSlotDate && _isAcceptNewClient) {
      return AssPath.calendarGreenIcon;
    } else {
      return AssPath.calendarGreyIcon;
    }
  }

  Color getTextColor() {
    if (_isThereFirstAvailableSlotDate && _isAcceptNewClient) {
      return ConstColors.secondary;
    } else {
      return ConstColors.textSecondary;
    }
  }

  bool get _isThereFirstAvailableSlotDate =>
      _therapistModelData.firstAvailableSlotDate != null;

  bool get _isAcceptNewClient => _therapistModelData.acceptNewClient ?? false;
}
