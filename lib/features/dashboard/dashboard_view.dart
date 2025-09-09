import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/dashboard/dashboard_controller.dart';
import 'package:listing_app/features/dashboard/widgets/banner_carousel.dart';
import 'package:listing_app/features/dashboard/widgets/category_item_data.dart';
import 'package:listing_app/features/dashboard/widgets/category_wiget.dart';
import 'package:listing_app/features/dashboard/widgets/listing_widgets.dart';
import 'package:listing_app/features/more/more_view.dart';
import 'package:listing_app/features/search/search_view.dart';
import 'package:listing_app/routes/app_pages.dart';
import 'package:listing_app/theme/theme_service.dart';
import 'package:listing_app/widgets/app_bar/app_header.dart';
import 'package:listing_app/widgets/app_search_bar_button.dart';

class DashboardView extends StatelessWidget {
  final DashboardController c = Get.find<DashboardController>();

  DashboardView({super.key});

  final List<Widget> _pages = [const _HomeSection(), SearchView(), MoreView()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Scaffold(
        appBar: AppHeader(
          titleKey: c.titles[c.selectedIndex.value],
          onProfileTap: () => Get.toNamed(AppRoutes.profile),
        ),
        body: _pages[c.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: c.selectedIndex.value,
          onTap: c.changeTab,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: theme.colorScheme.primary,
          unselectedItemColor: theme.unselectedWidgetColor,
          items: [
            BottomNavigationBarItem(
              icon: const Icon(Icons.home),
              label: "home".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.search),
              label: "search".tr,
            ),
            BottomNavigationBarItem(
              icon: const Icon(Icons.list),
              label: "more".tr,
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeSection extends StatelessWidget {
  const _HomeSection();

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: AppSearchBarButton(
            hint: "Search for products",
            onTap: () {
              Get.toNamed(AppRoutes.search);
            },
          ),
        ),
        CategoryGrid(),
        BannerCarousel(
          banners: [
            BannerItem(
              imageUrl: "https://picsum.photos/800/400?1",
              title: "Fast Delivery",
              subtitle: "Get your items quickly",
            ),
            BannerItem(
              imageUrl: "https://picsum.photos/800/400?2",
              title: "Best Discounts",
              subtitle: "Save more on every purchase",
            ),
            BannerItem(
              imageUrl: "https://picsum.photos/800/400?3",
              title: "24/7 Support",
              subtitle: "We are here for you anytime",
            ),
          ],
        ),
        const SizedBox(height: 20),
        SectionTitle(title: "featured_products".tr),
        HorizontalProductList(products: products),

        const SizedBox(height: 20),
        SectionTitle(title: "categories".tr),
        GridCategoryList(
          categories: [
            CategoryItemData(
              title: getCategoryLabel(context, "Food"),
              image:
                  "https://images.unsplash.com/photo-1504674900247-0877df9cc836?w=600", // burger
            ),
            CategoryItemData(
              title: getCategoryLabel(context, "Travel"),
              image:
                  "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?w=600", // beach
            ),
            CategoryItemData(
              title: getCategoryLabel(context, "Music"),
              image:
                  "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4?w=600", // concert
            ),
            CategoryItemData(
              title: getCategoryLabel(context, "Shopping"),
              image:
                  "https://images.unsplash.com/photo-1542831371-d531d36971e6?w=600", // mall
            ),
            CategoryItemData(
              title: getCategoryLabel(context, "Pets"),
              image:
                  "https://images.unsplash.com/photo-1517849845537-4d257902454a?w=600", // dog
            ),
            CategoryItemData(
              title: getCategoryLabel(context, "Movies"),
              image:
                  "https://images.unsplash.com/photo-1524985069026-dd778a71c7b4?w=600", // cinema
            ),
            CategoryItemData(
              title: getCategoryLabel(context, "Books"),
              image:
                  "https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?w=600", // library
            ),
            CategoryItemData(
              title: getCategoryLabel(context, "Sports"),
              image:
                  "https://images.unsplash.com/photo-1508609349937-5ec4ae374ebf?w=600", // football
            ),
          ],
        ),
      ],
    );
  }
}

final products = [
  ProductItemData(
    title: getProductTitle(Get.context!, "Running Shoes"),
    price: "\$89",
    image:
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600", // shoes
  ),
  ProductItemData(
    title: getProductTitle(Get.context!, "Gaming Laptop"),
    price: "\$999",
    image:
        "https://images.unsplash.com/photo-1517336714731-489689fd1ca8?w=600", // laptop
  ),
  ProductItemData(
    title: getProductTitle(Get.context!, "Bluetooth Speaker"),
    price: "\$49",
    image:
        "https://images.unsplash.com/photo-1519677100203-a0e668c92439?w=600", // speaker
  ),

  ProductItemData(
    title: getProductTitle(Get.context!, "Smartphone"),
    price: "\$799",
    image:
        "https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=600", // phone
  ),
  ProductItemData(
    title: getProductTitle(Get.context!, "Sunglasses"),
    price: "\$29",
    image:
        "https://images.unsplash.com/photo-1526170375885-4d8ecf77b99f?w=600", // glasses
  ),
  ProductItemData(
    title: getProductTitle(Get.context!, "Backpack"),
    price: "\$45",
    image:
        "https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=600", // backpack
  ),
  ProductItemData(
    title: getProductTitle(Get.context!, "Tablet Pro"),
    price: "\$499",
    image:
        "https://images.unsplash.com/photo-1587825140708-dfaf72ae4b04?w=600", // tablet
  ),
  ProductItemData(
    title: getProductTitle(Get.context!, "Coffee Maker"),
    price: "\$99",
    image:
        "https://images.unsplash.com/photo-1509460913899-515f1df34fea?w=600", // coffee machine
  ),

  ProductItemData(
    title: getProductTitle(Get.context!, "Desk Lamp"),
    price: "\$45",
    image:
        "https://images.unsplash.com/photo-1582719478250-c89cae4dc85b?w=600", // lamp
  ),

  ProductItemData(
    title: getProductTitle(Get.context!, "Travel Backpack"),
    price: "\$79",
    image:
        "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee?w=600", // backpack
  ),
];
final Map<String, Map<String, String>> categoryTranslations = {
  "Food": {"en": "Food", "ar": "طعام"},
  "Travel": {"en": "Travel", "ar": "سفر"},
  "Music": {"en": "Music", "ar": "موسيقى"},
  "Shopping": {"en": "Shopping", "ar": "تسوق"},
  "Pets": {"en": "Pets", "ar": "حيوانات أليفة"},
  "Movies": {"en": "Movies", "ar": "أفلام"},
  "Books": {"en": "Books", "ar": "كتب"},
  "Sports": {"en": "Sports", "ar": "رياضة"},
};

String getCategoryLabel(BuildContext context, String key) {
  final ThemeService _themeService = Get.find();
  final locale = _themeService.locale.languageCode;
  return categoryTranslations[key]?[locale] ?? key;
}


final Map<String, Map<String, String>> productTranslations = {
  "Running Shoes": {"en": "Running Shoes", "ar": "أحذية جري"},
  "Gaming Laptop": {"en": "Gaming Laptop", "ar": "حاسوب محمول للألعاب"},
  "Bluetooth Speaker": {"en": "Bluetooth Speaker", "ar": "مكبر صوت بلوتوث"},
  "Smartphone": {"en": "Smartphone", "ar": "هاتف ذكي"},
  "Sunglasses": {"en": "Sunglasses", "ar": "نظارات شمسية"},
  "Backpack": {"en": "Backpack", "ar": "حقيبة ظهر"},
  "Tablet Pro": {"en": "Tablet Pro", "ar": "جهاز لوحي برو"},
  "Coffee Maker": {"en": "Coffee Maker", "ar": "آلة صنع القهوة"},
  "Desk Lamp": {"en": "Desk Lamp", "ar": "مصباح مكتب"},
  "Travel Backpack": {"en": "Travel Backpack", "ar": "حقيبة سفر"},
};

String getProductTitle(BuildContext context, String key) {
  final ThemeService _themeService = Get.find();
  final locale = _themeService.locale.languageCode;
  return productTranslations[key]?[locale] ?? key;
}