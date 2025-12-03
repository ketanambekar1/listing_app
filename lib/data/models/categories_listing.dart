import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:listing_app/constants/app_constants.dart';

class CategoriesListingItem {
  final int id;
  final int categoryId;
  final String titleEn;
  final String titleAr;
  final String descriptionEn;
  final String descriptionAr;
  final String price;
  final String currency;
  final String mainImage;
  final List<String> images;
  final Map<String, dynamic> attributes;
  final int isFeatured;
  final DateTime createdAt;

  CategoriesListingItem({
    required this.id,
    required this.categoryId,
    required this.titleEn,
    required this.titleAr,
    required this.descriptionEn,
    required this.descriptionAr,
    required this.price,
    required this.currency,
    required this.mainImage,
    required this.images,
    required this.attributes,
    required this.isFeatured,
    required this.createdAt,
  });

  factory CategoriesListingItem.fromJson(Map<String, dynamic> json) {
    return CategoriesListingItem(
      id: json['id'],
      categoryId: json['category_id'] ?? 0,
      titleEn: json['title_en'] ?? "",
      titleAr: json['title_ar'] ?? "",
      descriptionEn: json['description_en'] ?? "",
      descriptionAr: json['description_ar'] ?? "",
      price: json['price'] ?? "",
      currency: json['currency'] ?? "",
      mainImage: json['main_image'] ?? "",

      // 🔥 Directus returns images as *stringified JSON*, decode safely
      images: _decodeImages(json['images']),

      // 🔥 Directus returns attributes as *stringified JSON*, decode safely
      attributes: _decodeAttributes(json['attributes']),

      isFeatured: json['is_featured'] ?? 0,
      createdAt: DateTime.tryParse(json['created_at'] ?? "") ?? DateTime.now(),
    );
  }

  // -------------------------
  // 🔥 AUTO-LOCALIZED TITLE
  // -------------------------
  String get title {
    final lang = GetStorage().read(AppConstants.languageCode) ?? "en";
    return lang == "ar" ? titleAr : titleEn;
  }

  // -------------------------
  // 🔥 AUTO-LOCALIZED SUBTITLE
  // (using description as subtitle)
  // -------------------------
  String get subtitle {
    final lang = GetStorage().read(AppConstants.languageCode) ?? "en";
    return lang == "ar" ? descriptionAr : descriptionEn;
  }

  // -------------------------
  // INTERNAL HELPERS
  // -------------------------

  static List<String> _decodeImages(dynamic raw) {
    if (raw == null) return [];

    try {
      if (raw is String) {
        return List<String>.from(jsonDecode(raw));
      }
      if (raw is List) {
        return List<String>.from(raw);
      }
    } catch (_) {}

    return [];
  }

  static Map<String, dynamic> _decodeAttributes(dynamic raw) {
    if (raw == null) return {};

    try {
      if (raw is String) {
        return jsonDecode(raw);
      }
      if (raw is Map<String, dynamic>) {
        return raw;
      }
    } catch (_) {}

    return {};
  }
}
