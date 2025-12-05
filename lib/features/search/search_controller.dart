import 'package:get/get.dart';
import 'package:listing_app/api/services/search_service.dart';
import 'package:listing_app/data/models/product_details_model.dart';

class SearchWidgetController extends GetxController {
  var query = "".obs;
  var isLoading = false.obs;
  var results = <ProductDetailsModel>[].obs;

  @override
  void onInit() {
    super.onInit();

    debounce(query, (_) => _runSearch(), time: const Duration(milliseconds: 400));
  }

  void _runSearch() async {
    if (query.value.trim().isEmpty) {
      results.clear();
      return;
    }

    isLoading.value = true;

    final res = await SearchService.search(query.value);
    results.assignAll(res);

    isLoading.value = false;
  }
}
