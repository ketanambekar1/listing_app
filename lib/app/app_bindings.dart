import 'package:get/get.dart';
import 'package:listing_app/app/app_controller.dart';
import 'package:listing_app/theme/theme_service.dart';

class AppBindings extends Bindings {
  @override
  void dependencies() {
    Get.put(AppController());
  }
}
