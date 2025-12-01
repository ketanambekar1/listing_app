import 'package:get_storage/get_storage.dart';
import 'package:listing_app/constants/app_constants.dart';

class BannerItem {
  final int id;
  final String imageUrl;
  final String titleEn;
  final String titleAr;
  final String subtitleEn;
  final String subtitleAr;
  final int sortOrder;

  BannerItem({
    required this.id,
    required this.imageUrl,
    required this.titleEn,
    required this.titleAr,
    required this.subtitleEn,
    required this.subtitleAr,
    required this.sortOrder,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'],
      imageUrl: json['image_url'] ?? "",
      titleEn: json['title_en'] ?? "",
      titleAr: json['title_ar'] ?? "",
      subtitleEn: json['subtitle_en'] ?? "",
      subtitleAr: json['subtitle_ar'] ?? "",
      sortOrder: json['sort_order'] ?? 0,
    );
  }

  // 🔥 AUTO LOCALIZED TITLE
  String get title {
    final lang = GetStorage().read(AppConstants.languageCode) ?? "en";
    return lang == "ar" ? titleAr : titleEn;
  }

  // 🔥 AUTO LOCALIZED SUBTITLE
  String get subtitle {
    final lang = GetStorage().read(AppConstants.languageCode) ?? "en";
    return lang == "ar" ? subtitleAr : subtitleEn;
  }
}
