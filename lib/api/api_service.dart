import 'package:dio/dio.dart';
import 'package:listing_app/api/dio_client.dart';

import 'api_constants.dart';

class ApiService {
  final Dio _dio = DioClient().dio;

  Future<Response> getCategoryTranslations({required String language}) async {
    try {
      return await _dio.get(ApiConstants.categoryTranslations, queryParameters: {"filter[language][_eq]": language});
    } catch (e) {
      rethrow;
    }
  }
}
