import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/base/base_api_manager.dart';
import 'package:o7therapy/api/errors/network_exceptions.dart';
import 'package:o7therapy/api/models/ewp/ewp_remaining_cap_no_wrapper.dart';
import 'package:o7therapy/prefs/pref_manager.dart';

class EwpApiManager {
  static Future<void> getRemainingCapNoForEwpApi({
    required void Function(EwpRemainingCapNoWrapper) success,
    required void Function(NetworkExceptions) fail,
  }) async {
    try {
      await BaseApi.updateHeader();
      var companyCode = await PrefManager.getCompanyCode();
      var remainingCapUrl = ApiKeys.getRemainingCapNoForEwpUrl;
      if (companyCode != null && companyCode.isNotEmpty) {
        remainingCapUrl += "/$companyCode";
      }
      final response = await BaseApi.dio.get(remainingCapUrl);
      EwpRemainingCapNoWrapper wrapper =
          EwpRemainingCapNoWrapper.fromJson(response.data);
      if (wrapper.errorCode == 0) {
        success(wrapper);
      } else {
        NetworkExceptions details = NetworkExceptions.fromJson(response.data);
        fail(details);
      }
    } catch (onError) {
      fail(NetworkExceptions.getDioException(onError));
    }
  }
}
