import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/util/lang/app_localization.dart';

final Locale systemLocale = WidgetsBinding.instance.window.locales.first;

// ignore_for_file: constant_identifier_names
enum SupportLanguage { EN, AR }

class LanguageCubit extends HydratedCubit<Locale> {
  static const String _stateJsonKey = "local";
  LanguageCubit() : super(systemLocale) {
    PrefManager.setLang(state.languageCode);
  }

  void switchLanguage() {
    String languageCode = state.languageCode;
    switch (languageCode) {
      case 'ar':
        _changeToEnglish();
        break;
      case 'en':
        _changeToArabic();
        break;
      default:
        _changeToEnglish();
        break;
    }
  }

  void changeLanguage(SupportLanguage selectedLanguage) {
    if (selectedLanguage == SupportLanguage.AR) {
      _changeToArabic();
    } else if (selectedLanguage == SupportLanguage.EN) {
      _changeToEnglish();
    }
  }

  _changeToEnglish() async {
    await PrefManager.setLang(codeEn);
    emit(enUsLocale);
  }

  _changeToArabic() async {
    await PrefManager.setLang(codeAr);
    emit(arEgLocale);
  }

  @override
  Locale fromJson(Map<String, dynamic> json) {
    if (json.isEmpty) {
      /// if json is empty then get the current device local
      return AppLocalizations.localeResolutionCallback(
        systemLocale,
        AppLocalizations.supportLocales,
      )!;
    }
    String languageCode =
        ((json[_stateJsonKey]) as String).toLowerCase().trim();
    if (languageCode == SupportLanguage.AR.name.toLowerCase()) {
      return arEgLocale;
    } else {
      return enUsLocale;
    }
  }

  @override
  Map<String, dynamic>? toJson(Locale state) {
    return {
      _stateJsonKey: state.languageCode,
    };
  }
}
