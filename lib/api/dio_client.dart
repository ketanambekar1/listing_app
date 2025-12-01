import 'package:dio/dio.dart';
import 'api_constants.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      headers: {"Authorization": "Bearer ${ApiConstants.authToken}"},
    ),
  )..interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
}
