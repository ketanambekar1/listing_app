import 'package:get/get.dart';
import 'package:listing_app/features/dashboard/dashboard_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(DashboardController());
  }
}
