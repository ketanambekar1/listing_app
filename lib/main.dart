import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:listing_app/api/api_service.dart';
import 'package:listing_app/app/app.dart';
import 'package:listing_app/services/app_info_service.dart';
import 'package:listing_app/theme/theme_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  await Get.putAsync<AppInfoService>(() => AppInfoService().init());
  Get.put(ApiService(), permanent: true);
  Get.put(ThemeService());
  runApp(MyApp());
}
