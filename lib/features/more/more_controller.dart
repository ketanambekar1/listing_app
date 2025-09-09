import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/theme/theme_service.dart';

class MoreController extends GetxController {
  final ThemeService _themeService = Get.find();

  /// Observe theme
  RxBool isDarkMode = false.obs;

  /// Observe current language
  RxString currentLang = 'en'.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = _themeService.themeMode == ThemeMode.dark;
    currentLang.value = _themeService.locale.languageCode;
  }

  /// Toggle dark / light theme
  void toggleTheme() {
    _themeService.switchTheme();
    isDarkMode.value = !isDarkMode.value;
  }

  /// Change language
  void changeLanguage(String code) {
    _themeService.switchLanguage(code);
    currentLang.value = code;
  }
}
