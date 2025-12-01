import 'package:get/get.dart';

class FeatureProductItemData {
  final int id;
  final String titleEn;
  final String titleAr;
  final String image;
  final String price;

  FeatureProductItemData({
    required this.id,
    required this.titleEn,
    required this.titleAr,
    required this.image,
    required this.price,
  });

  factory FeatureProductItemData.fromJson(Map<String, dynamic> json) {
    return FeatureProductItemData(
      id: json['id'],
      titleEn: json['title_en'] ?? "",
      titleAr: json['title_ar'] ?? "",
      image: json['image_url'] ?? "",
      price: json['price'] ?? "",
    );
  }

  /// Returns correct title based on current locale
  String getTitle() {
    final code = Get.locale?.languageCode ?? "en";
    return code == "ar" ? titleAr : titleEn;
  }
}
