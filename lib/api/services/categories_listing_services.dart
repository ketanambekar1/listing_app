import 'package:listing_app/api/api_constants.dart';
import 'package:listing_app/api/dio_client.dart';
import 'package:listing_app/data/models/categories_listing.dart';

class ProductService {
  static Future<List<CategoriesListingItem>> getProductsByCategory(
    int categoryId,
  ) async {
    try {
      final response = await DioClient.dio.get(
        "${ApiConstants.productsByCategory}$categoryId&limit=-1&fields=*",
      );

      final List data = response.data["data"];
      return data.map((e) => CategoriesListingItem.fromJson(e)).toList();
    } catch (e) {
      print("Product Service Error: $e");
      return [];
    }
  }
}
