import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/app/app_bindings.dart';
import 'package:listing_app/routes/app_pages.dart';
import 'package:listing_app/services/translations_service.dart';
import 'package:listing_app/theme/theme_config.dart';
import 'package:listing_app/theme/theme_service.dart';

class MyApp extends StatelessWidget {
  final ThemeService _themeService = Get.find();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'JD Clone',
      debugShowCheckedModeBanner: false,
      translations: AppTranslations(),
      locale: _themeService.locale,
      fallbackLocale: const Locale('en', 'US'),
      initialBinding: AppBindings(),
      getPages: AppPages.pages,
      theme: ThemeConfig.lightTheme,
      darkTheme: ThemeConfig.darkTheme,
      themeMode: _themeService.themeMode,
      initialRoute: AppRoutes.dashboard,
      builder: (context, child) {
        return Directionality(
          textDirection: _themeService.locale.languageCode == 'ar'
              ? TextDirection.rtl
              : TextDirection.ltr,
          child: child!,
        );
      },
    );
  }
}
