import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:listing_app/constants/app_constants.dart';

class ThemeService extends GetxService {
  final _storage = GetStorage();

  ThemeMode get themeMode =>
      _loadThemeFromStorage() ? ThemeMode.dark : ThemeMode.light;

  Locale get locale => _loadLocaleFromStorage();

  void switchTheme() {
    final isDark = !_loadThemeFromStorage();
    Get.changeThemeMode(isDark ? ThemeMode.dark : ThemeMode.light);
    _saveThemeToStorage(isDark);
  }

  void switchLanguage(String langCode) {
    final locale = Locale(langCode);
    Get.updateLocale(locale);
    _saveLocaleToStorage(langCode);
  }

  bool _loadThemeFromStorage() =>
      _storage.read(AppConstants.isDarkMode) ?? false;

  void _saveThemeToStorage(bool isDarkMode) =>
      _storage.write(AppConstants.isDarkMode, isDarkMode);

  Locale _loadLocaleFromStorage() {
    final code = _storage.read(AppConstants.languageCode) ?? 'en';
    return Locale(code);
  }

  void _saveLocaleToStorage(String code) =>
      _storage.write(AppConstants.languageCode, code);
}
