import 'package:listing_app/api/dio_client.dart';
import 'package:listing_app/api/api_constants.dart';
import 'package:listing_app/data/models/categories_model.dart';

class CategoryService {
  static Future<List<CategoryItem>> fetchCategories() async {
    try {
      final response =
      await DioClient.dio.get(ApiConstants.categories);

      final List data = response.data["data"];

      return data.map((e) => CategoryItem.fromJson(e)).toList();
    } catch (e) {
      print("CategoryService ERROR: $e");
      return [];
    }
  }
}
