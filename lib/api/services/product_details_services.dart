import 'package:listing_app/api/api_constants.dart';
import 'package:listing_app/api/dio_client.dart';
import 'package:listing_app/constants/app_constants.dart';
import 'package:listing_app/data/models/product_details_model.dart';

class ProductDetailsServices {
  static Future<ProductDetailsModel?> getProductById(int id) async {
    try {
      final response = await DioClient.dio.get(
        "${ApiConstants.productsDetailsById}$id",
      );

      return ProductDetailsModel.fromJson(response.data["data"]);
    } catch (e) {
      print("ProductService Error: $e");
      return null;
    }
  }
}
