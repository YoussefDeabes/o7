import 'dart:async';
import 'dart:developer';

import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/min_max/min_max.dart';
import 'package:o7therapy/api/therapist_list_api_manager.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/ui/screens/booking/bloc/booking_screen_filter_bloc/models/filter_enums.dart';

class FilterMinMaxValues {
  const FilterMinMaxValues._();
  static const _internal = FilterMinMaxValues._();
  factory FilterMinMaxValues() => _internal;

  static FilterPriceData? _filterPriceData;
  static FilterPriceData get filterPriceData =>
      _filterPriceData ?? FilterPriceData.init;

  FutureOr<FilterPriceData> getFilterPriceData() async {
    log("getFilterPriceData");

    _filterPriceData = await _getMinMaxFilterValuesFromEndPoint();
    if (_filterPriceData != null) {
      return _filterPriceData!;
    }
    return FilterPriceData.init;
  }

  Future<FilterPriceData?> _getMinMaxFilterValuesFromEndPoint() async {
    FilterPriceData? filterPriceData;
    String? currency;
    try {
      await TherapistListApiManager.getMinMax((MinMaxWrapper minMaxWrapper) {
        filterPriceData = FilterPriceData(
          initialMaxPrice: minMaxWrapper.data.maxValue,
          initialMinPrice: minMaxWrapper.data.minValue,
          maxPrice: minMaxWrapper.data.maxValue,
          minPrice: minMaxWrapper.data.minValue,
          currency: minMaxWrapper.data.currency,
        );
        currency = minMaxWrapper.data.currency;
        log("Fetched min max");
      }, (NetworkExceptions details) {
        log(details.toString());
      });
    } catch (error) {
      log(error.toString());
    }
    await PrefManager.setCurrency(currency);
    log("currency updated in the pref manager: $currency");
    log("_getMinMaxFilterValuesFromEndPoint: $filterPriceData");
    return filterPriceData;
  }
}
