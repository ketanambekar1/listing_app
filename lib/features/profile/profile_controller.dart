import 'package:get/get.dart';

class ProfileController extends GetxController {
  // Hardcoded data for now (later you’ll fetch from API / GetStorage)
  final userName = "John Doe".obs;
  final userEmail = "john.doe@example.com".obs;
  final userPhone = "+1 987 654 3210".obs;
  final userImage = "https://i.pravatar.cc/150?img=3".obs; // dummy avatar
}
