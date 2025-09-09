import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:listing_app/app/app.dart';
import 'package:listing_app/theme/theme_service.dart';
import 'routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  Get.put(ThemeService());

  // await Get.putAsync(() => DataService().init());
  runApp(MyApp());
}
