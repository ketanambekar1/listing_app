import 'package:listing_app/api/dio_client.dart';
import 'package:listing_app/api/api_constants.dart';
import 'package:listing_app/data/models/product_details_model.dart';

class SearchService {
  static Future<List<ProductDetailsModel>> search(String query) async {
    try {
      // hard-coded category ID 3 as requested
      final response = await DioClient.dio.get(
        "${ApiConstants.productsByCategory}3&limit=-1&fields=*",
      );

      final List data = response.data["data"];

      // Convert JSON to model
      final products = data.map((e) => ProductDetailsModel.fromJson(e)).toList();

      // Local filtering
      final q = query.toLowerCase();

      return products.where((p) {
        return p.title.toLowerCase().contains(q) ||
            p.description.toLowerCase().contains(q) ||
            p.attributes.toString().toLowerCase().contains(q);
      }).toList();
    } catch (e) {
      print("SearchService Error: $e");
      return [];
    }
  }
}
