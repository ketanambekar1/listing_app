import 'package:get/get.dart';
import 'package:listing_app/features/more/more_controller.dart';

class MoreBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(MoreController());
  }
}
