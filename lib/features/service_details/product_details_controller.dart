import 'package:get/get.dart';
import 'package:listing_app/api/services/product_details_services.dart';
import 'package:listing_app/data/models/product_details_model.dart';

class ProductDetailController extends GetxController {
  RxBool isLoading = true.obs;
  Rx<ProductDetailsModel?> product = Rx<ProductDetailsModel?>(null);

  Future<void> loadProduct(int id) async {
    isLoading.value = true;
    product.value = await ProductDetailsServices.getProductById(id);
    isLoading.value = false;
  }
}
