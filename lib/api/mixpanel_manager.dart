import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:o7therapy/api/api_keys.dart';

class MixpanelManager {
  static Mixpanel? _instance;

  static Future<Mixpanel> init() async {
    _instance ??= await Mixpanel.init(ApiKeys.mixpanelToken,
          optOutTrackingDefault: false, trackAutomaticEvents: true);
    return _instance!;
  }
}