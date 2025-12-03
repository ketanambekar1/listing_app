import 'package:get/get.dart';
import 'package:listing_app/api/services/categories_listing_services.dart';
import 'package:listing_app/data/models/categories_listing.dart';


class ServiceController extends GetxController {
  // Observables
  var services = <CategoriesListingItem>[].obs;
  var filtered = <CategoriesListingItem>[].obs;

  var selectedTag = "All".obs;
  var sortBy = "Recommended".obs;
  var searchQuery = "".obs;

  final int categoryId;

  ServiceController(this.categoryId);

  @override
  void onInit() {
    super.onInit();
    loadServices();
  }

  Future<void> loadServices() async {
    final data = await ProductService.getProductsByCategory(categoryId);
    services.assignAll(data);
    filtered.assignAll(data);
    applyFilters();
  }

  void applyFilters() {
    List<CategoriesListingItem> tmp = List.from(services);

    // TAG filters
    if (selectedTag.value == "Verified") {
      tmp = tmp.where((s) => s.attributes["verified"] == true).toList();
    }
    if (selectedTag.value == "Top Rated") {
      tmp = tmp.where((s) => (s.attributes["top_rated"] ?? false) == true).toList();
    }
    if (selectedTag.value == "Trusted") {
      tmp = tmp.where((s) => (s.attributes["trusted"] ?? false) == true).toList();
    }

    // SEARCH filter
    if (searchQuery.value.isNotEmpty) {
      tmp = tmp
          .where((s) =>
      s.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
          s.descriptionEn.toLowerCase().contains(searchQuery.value.toLowerCase()))
          .toList();
    }

    // SORTING
    switch (sortBy.value) {
      case "Rating":
        tmp.sort((a, b) => (b.attributes["rating"] ?? 0)
            .compareTo(a.attributes["rating"] ?? 0));
        break;

      case "Reviews":
        tmp.sort((a, b) => (b.attributes["reviews"] ?? 0)
            .compareTo(a.attributes["reviews"] ?? 0));
        break;

      case "Experience":
        tmp.sort((a, b) => (b.attributes["experience"] ?? 0)
            .compareTo(a.attributes["experience"] ?? 0));
        break;
    }

    filtered.assignAll(tmp);
  }

  void updateTag(String tag) {
    selectedTag.value = tag;
    applyFilters();
  }

  void updateSort(String sort) {
    sortBy.value = sort;
    applyFilters();
  }

  void updateSearch(String q) {
    searchQuery.value = q;
    applyFilters();
  }
}
