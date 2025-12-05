import 'package:get/get.dart';
import 'package:listing_app/api/services/banner_service.dart';
import 'package:listing_app/api/services/categories_services.dart';
import 'package:listing_app/api/services/feature_products_service.dart';
import 'package:listing_app/data/models/banner_model.dart';
import 'package:listing_app/data/models/categories_model.dart';
import 'package:listing_app/data/models/feature_product_items.dart';

class DashboardController extends GetxController {
  var selectedIndex = 0.obs;
  var banners = <BannerItem>[].obs;
  RxList<FeatureProductItemData> products = <FeatureProductItemData>[].obs;
  var categories = <CategoryItem>[].obs;
  var isLoading = false.obs;

  final titles = ["Classified App", "Search", "More"];

  @override
  void onInit() {
    fetchBanners();
    fetchFeatureProducts();
    loadCategories();
    super.onInit();
  }

  void changeTab(int index) {
    selectedIndex.value = index;
  }

  Future<void> refreshAll() async {
    await fetchBanners();
    await fetchFeatureProducts();
    await loadCategories();
  }

  Future<void> fetchBanners() async {
    isLoading(true);
    banners.value = await BannerService.getBanners();
    isLoading(false);
  }

  Future<void> fetchFeatureProducts() async {
    isLoading(true);
    products.value = await FeatureProductService.getFeatureProducts();
    isLoading(false);
  }

  Future<void> loadCategories() async {
    isLoading.value = true;
    categories.value = await CategoryService.fetchCategories();
    isLoading.value = false;
  }
}
