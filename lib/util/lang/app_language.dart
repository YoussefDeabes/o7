import 'package:flutter/material.dart';
import 'package:o7therapy/prefs/pref_manager.dart';

class AppLanguage extends ChangeNotifier {
  Locale _appLocale = const Locale('ar');

  Locale get appLocal => _appLocale;

  fetchLocale() async {
    _appLocale = Locale(await PrefManager.getLang() ?? "ar");
    return _appLocale;
  }

  void changeLanguage(Locale type) async {
    if (_appLocale == type) {
      return;
    }
    if (type == const Locale("ar")) {
      _appLocale = const Locale("ar");
      PrefManager.setLang('ar');
    } else {
      _appLocale = const Locale("en");
      PrefManager.setLang('en');
    }
    notifyListeners();
  }
}
