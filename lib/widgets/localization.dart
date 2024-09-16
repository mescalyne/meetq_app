import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

extension BuildContextExt on BuildContext {
  String localize(
    String text, {
    Map<String, String>? params,
    int? pluralValue,
  }) {
    if (pluralValue != null) {
      return FlutterI18n.plural(this, text, pluralValue).toString();
    } else {
      return FlutterI18n.translate(
        this,
        text,
        translationParams: params,
      ).toString();
    }
  }
}

class LocaleManager {
  static const String _localeKey = 'APP_LOCALE';

  static Future<LocaleType> getCurrent({
    required BuildContext context,
  }) async {
    const flutterSecureStorage = FlutterSecureStorage();
    LocaleType locale = LocaleType.fromString(
        await flutterSecureStorage.read(key: _localeKey) ?? 'en');
    return locale;
  }

  static Future<bool> setLocale({
    required LocaleType localeType,
    required BuildContext context,
  }) async {
    try {
      const flutterSecureStorage = FlutterSecureStorage();
      await flutterSecureStorage.write(
          key: _localeKey, value: localeType.toString());
      // ignore: use_build_context_synchronously
      await FlutterI18n.refresh(context, localeType.toLocale());

      return true;
    } on Exception catch (_) {
      return false;
    }
  }
}

enum LocaleType {
  en,
  ar,
  es,
  zh,
  bn,
  hi,
  pt,
  ja,
  uk,
  ru;

  static List<Locale> getLocales() {
    return LocaleType.values.map((e) => e.toLocale()).toList();
  }

  @override
  String toString() {
    switch (this) {
      case LocaleType.en:
        return 'en';
      case LocaleType.ar:
        return 'ar';
      case LocaleType.ru:
        return 'ru';
      case LocaleType.es:
        return 'es';
      case LocaleType.zh:
        return 'zh';
      case LocaleType.bn:
        return 'bn';
      case LocaleType.hi:
        return 'hi';
      case LocaleType.uk:
        return 'uk';
      case LocaleType.ja:
        return 'ja';
      case LocaleType.pt:
        return 'pt';
    }
  }

  String getTitle() {
    switch (this) {
      case LocaleType.en:
        return 'English';
      case LocaleType.uk:
        return 'Українська';
      case LocaleType.ru:
        return 'Русский';
      case LocaleType.ar:
        return 'عربي';
      case LocaleType.es:
        return 'Español';
      case LocaleType.zh:
        return '中国人';
      case LocaleType.hi:
        return 'हिंदी';
      case LocaleType.bn:
        return 'বাংলা';
      case LocaleType.ja:
        return '日本語';
      case LocaleType.pt:
        return 'Português';
    }
  }

  Locale toLocale() {
    switch (this) {
      case LocaleType.en:
        return const Locale('en');
      case LocaleType.uk:
        return const Locale('uk');
      case LocaleType.ru:
        return const Locale('ru');
      case LocaleType.ar:
        return const Locale('ar');
      case LocaleType.es:
        return const Locale('es');
      case LocaleType.zh:
        return const Locale('zh');
      case LocaleType.hi:
        return const Locale('hi');
      case LocaleType.bn:
        return const Locale('bn');
      case LocaleType.pt:
        return const Locale('pt');
      case LocaleType.ja:
        return const Locale('ja');
    }
  }

  factory LocaleType.fromString(String key) {
    switch (key) {
      case 'ar':
        return LocaleType.ar;
      case 'en':
        return LocaleType.en;
      case 'es':
        return LocaleType.es;
      case 'ru':
        return LocaleType.ru;
      case 'zh':
        return LocaleType.zh;
      case 'hi':
        return LocaleType.hi;
      case 'bn':
        return LocaleType.bn;
      case 'uk':
        return LocaleType.uk;
      case 'ja':
        return LocaleType.ja;
      case 'pt':
        return LocaleType.pt;
      default:
        return LocaleType.en;
    }
  }
}
