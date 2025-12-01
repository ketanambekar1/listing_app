import 'package:listing_app/api/api_constants.dart';
import 'package:listing_app/data/models/feature_product_items.dart';
import 'package:listing_app/api/dio_client.dart';

class FeatureProductService {
  static Future<List<FeatureProductItemData>> getFeatureProducts() async {
    try {
      final response = await DioClient.dio.get(ApiConstants.featureProducts);

      final List data = response.data['data'];
      return data.map((e) => FeatureProductItemData.fromJson(e)).toList();
    } catch (e) {
      print("Product Service Error: $e");
      return [];
    }
  }
}

