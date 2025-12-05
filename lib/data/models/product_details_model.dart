import 'dart:convert';
import 'package:get_storage/get_storage.dart';
import 'package:listing_app/constants/app_constants.dart';

class ProductDetailsModel {
  final int id;
  final int categoryId;

  final String titleEn;
  final String titleAr;

  final String descriptionEn;
  final String descriptionAr;

  final double price;
  final String currency;

  final String mainImage;
  final List<String> images;

  final Map<String, dynamic> attributes;

  final bool isFeatured;

  // NEW FIELDS
  final String? phone;
  final String? website;
  final String? address;
  final double? latitude;
  final double? longitude;

  final double ratingAvg;
  final int ratingCount;

  final String? sellerName;

  ProductDetailsModel({
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

    this.phone,
    this.website,
    this.address,
    this.latitude,
    this.longitude,
    required this.ratingAvg,
    required this.ratingCount,
    this.sellerName,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    return ProductDetailsModel(
      id: json['id'],
      categoryId: json['category_id'],

      titleEn: json['title_en'] ?? "",
      titleAr: json['title_ar'] ?? "",

      descriptionEn: json['description_en'] ?? "",
      descriptionAr: json['description_ar'] ?? "",

      price: json['price'] != null
          ? double.tryParse(json['price'].toString()) ?? 0
          : 0,

      currency: json['currency'] ?? "USD",

      mainImage: json['main_image'] ?? "",

      // Handle both stringified JSON OR real array
      images: json['images'] is String
          ? List<String>.from(jsonDecode(json['images']))
          : List<String>.from(json['images'] ?? []),

      // Handle both stringified JSON OR real map
      attributes: json['attributes'] is String
          ? jsonDecode(json['attributes'])
          : (json['attributes'] ?? {}),

      isFeatured: json['is_featured'] == 1,

      phone: json['phone'],
      website: json['website'],
      address: json['address'],

      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,

      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,

      ratingAvg: json['rating_avg'] != null
          ? double.tryParse(json['rating_avg'].toString()) ?? 0.0
          : 0.0,

      ratingCount: json['rating_count'] ?? 0,

      sellerName: json['seller_name'],
    );
  }

  // ----------------------------------------------------
  // ⭐ ARABIC FALLBACK (if Arabic empty → fallback English)
  // ----------------------------------------------------
  String get title {
    final lang = GetStorage().read(AppConstants.languageCode) ?? "en";

    if (lang == "ar" && titleAr.trim().isNotEmpty) return titleAr;
    return titleEn;
  }

  String get description {
    final lang = GetStorage().read(AppConstants.languageCode) ?? "en";

    if (lang == "ar" && descriptionAr.trim().isNotEmpty) return descriptionAr;
    return descriptionEn;
  }
}
