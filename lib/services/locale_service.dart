import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:flutter/material.dart';
import 'package:listing_app/constants/app_constants.dart';

class LocaleService {
  static final LocaleService _instance = LocaleService._internal();
  factory LocaleService() => _instance;

  final GetStorage _storage = GetStorage();

  LocaleService._internal();

  String get currentLang =>
      _storage.read(AppConstants.languageCode) ?? 'en';

  Locale get currentLocale => Locale(currentLang);

  void setLanguage(String lang) {
    _storage.write(AppConstants.languageCode, lang);
    Get.updateLocale(Locale(lang));
  }
}

