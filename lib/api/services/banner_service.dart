import 'package:listing_app/api/api_constants.dart';
import 'package:listing_app/api/dio_client.dart';
import 'package:listing_app/data/models/banner_model.dart';

class BannerService {
  static Future<List<BannerItem>> getBanners() async {
    try {
      final response = await DioClient.dio.get(ApiConstants.banners);

      final List data = response.data["data"];
      return data.map((e) => BannerItem.fromJson(e)).toList();
    } catch (e) {
      print("Banner Service Error: $e");
      return [];
    }
  }
}
