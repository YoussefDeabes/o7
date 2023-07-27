import 'dart:developer';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/api/environments/environment.dart';
import 'package:o7therapy/util/firebase/analytics/keys/analytics_param_name.dart';

class AnalyticsHelper {
  const AnalyticsHelper._();
  static AnalyticsHelper? _instance;
  static AnalyticsHelper get i => _instance ??= const AnalyticsHelper._();

  static final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;
  static final FirebaseAnalyticsObserver _observer =
      FirebaseAnalyticsObserver(analytics: _analytics);

  static bool _isAnalyticsEnabled = false;
  static Future<void> enableAnalytics({
    bool enableAnalytics = false,
  }) async {
    /// if production enable always
    if (kReleaseMode && Environment.envType == EnvType.prod) {
      _isAnalyticsEnabled = true;
      await _setAnalyticsCollectionEnabled();
      await _setEnvAndModeDefaultEventParameters();
    }

    /// Check for enableAnalytics: in true case
    /// and not production or release
    if (enableAnalytics) {
      _isAnalyticsEnabled = true;
      await _setAnalyticsCollectionEnabled();
      await _setEnvAndModeDefaultEventParameters();
    }
    log("_isAnalyticsEnabled: $_isAnalyticsEnabled");
  }

  static Future<void> _setEnvAndModeDefaultEventParameters() async {
    await _analytics.setDefaultEventParameters({
      AnalyticsParamName.env: _getEnvType,
      AnalyticsParamName.mode: _getMode,
    });
  }

  static String get _getEnvType => Environment.envType.analyticsName;
  static String get _getMode => kReleaseMode ? "release_mode" : "debug_mode";

  static Future<void> _setAnalyticsCollectionEnabled() async {
    await _analytics.setAnalyticsCollectionEnabled(_isAnalyticsEnabled);
  }

  static List<NavigatorObserver> get navigatorObserver =>
      _isAnalyticsEnabled ? <NavigatorObserver>[_observer] : [];

  Future<void> changeTab({required String? screenName}) =>
      _analytics.logScreenView(screenName: screenName);
}
