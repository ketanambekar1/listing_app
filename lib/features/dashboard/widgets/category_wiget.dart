import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/dashboard/dashboard_controller.dart';
import 'package:listing_app/features/listing_services/listing_services.dart';
import 'package:listing_app/routes/app_pages.dart';
import 'package:listing_app/theme/theme_service.dart';
import 'package:listing_app/utils/random_ui.dart';
import 'package:listing_app/widgets/shimmer_widgets/category_shimmer.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<DashboardController>();
    final themeService = Get.find<ThemeService>();

    return Obx(() {
      if (controller.isLoading.value) {
        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemCount: 16,
          itemBuilder: (_, __) => const CategoryShimmer(),
        );
        ;
      }

      final categories = controller.categories;

      return GridView.builder(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemCount: categories.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: .85,
        ),
        itemBuilder: (context, index) {
          final cat = categories[index];

          // Pick correct language based on ThemeService.locale
          final isArabic =
              themeService.locale.languageCode.toLowerCase() == "ar";

          final label = isArabic ? cat.nameAr : cat.nameEn;

          return _GridItem(
            label: label,
            icon: RandomUI.randomIcon(),
            size: 58,
            bgColor: RandomUI.randomColor(),
            fontSize: 12,
            textColor:
                Theme.of(context).textTheme.bodyMedium?.color ?? Colors.black87,
            shadowColor: Colors.black12,
            onTap: () {
              Get.toNamed(
                AppRoutes.serviceListPage,
                arguments: {'categoryName': label, 'categoryId': cat.id},
              );
            },
          );
        },
      );
    });
  }
}

class _GridItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final double size;
  final Color bgColor;
  final double fontSize;
  final Color textColor;
  final Color shadowColor;
  final VoidCallback? onTap;

  const _GridItem({
    required this.icon,
    required this.label,
    required this.size,
    required this.bgColor,
    required this.fontSize,
    this.textColor = Colors.black87,
    this.shadowColor = const Color(0x15000000),
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Respect text direction for label alignment
    final isRtl = Directionality.of(context) == TextDirection.rtl;

    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, size: size * 0.55, color: Colors.white),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
