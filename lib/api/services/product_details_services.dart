import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/api/api_constants.dart';
import 'package:listing_app/api/dio_client.dart';
import 'package:listing_app/data/models/product_details_model.dart';

class ProductDetailsServices {
  static Future<ProductDetailsModel?> getProductById(int id) async {
    try {
      final response = await DioClient.dio.get(
        "${ApiConstants.productsDetailsById}$id",
      );

      // Validate Directus-style response
      if (response.data == null || response.data["data"] == null) {
        Get.snackbar(
          "Error",
          "No product data found.",
          snackPosition: SnackPosition.BOTTOM,
        );
        return null;
      }

      return ProductDetailsModel.fromJson(response.data["data"]);
    } catch (e) {
      print("ProductService Error: $e");
      Get.back();
      Get.snackbar(
        "Oops!",
        "Unable to load product details.",
        snackPosition: SnackPosition.BOTTOM,
        margin: const EdgeInsets.all(16),
        borderRadius: 12,
        backgroundColor: const Color(0xFFff4444),
        colorText: const Color(0xFFFFFFFF),
      );

      return null;
    }
  }
}
