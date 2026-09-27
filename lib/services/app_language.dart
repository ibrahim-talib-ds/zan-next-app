import 'package:flutter/material.dart';

/// Global, reactive language state.
///
/// Any widget can:
///   - read the current locale: `AppLanguage.current`
///   - change it: `AppLanguage.set('sw')`
///   - listen: `ValueListenableBuilder(valueListenable: AppLanguage.locale, ...)`
///
/// `main.dart` listens to this notifier and rebuilds MaterialApp
/// so the entire tree picks up the new locale instantly.
class AppLanguage {
  AppLanguage._();

  /// Current locale code ('en' or 'sw').
  static final ValueNotifier<String> locale = ValueNotifier<String>('en');

  /// Human label for the current language (used in UI).
  static String get label {
    return locale.value == 'sw' ? 'Kiswahili' : 'English';
  }

  /// Change language. Notifies all listeners.
  /// Does NOT persist — `main.dart` handles persistence.
  static void set(String code) {
    if (locale.value == code) return;
    locale.value = code;
    debugPrint('🌐 AppLanguage.set → $code');
  }
}
