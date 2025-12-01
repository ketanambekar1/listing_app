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
import 'package:listing_app/widgets/shimmer_widgets/banner_shimmer.dart';
import 'package:listing_app/widgets/shimmer_widgets/product_shimmer.dart';

class DashboardView extends StatelessWidget {
  final DashboardController controller = Get.find<DashboardController>();

  DashboardView({super.key});

  final List<Widget> _pages = [_HomeSection(), SearchView(), MoreView()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Obx(
      () => Scaffold(
        appBar: AppHeader(
          titleKey: controller.titles[controller.selectedIndex.value],
          onProfileTap: () => Get.toNamed(AppRoutes.profile),
        ),
        body: _pages[controller.selectedIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.selectedIndex.value,
          onTap: controller.changeTab,
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
  _HomeSection();
  final DashboardController controller = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.refreshAll,   // <–– IMPORTANT
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(), // needed!
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AppSearchBarButton(
              hint: "Search for products",
              onTap: () => Get.toNamed(AppRoutes.search),
            ),
          ),
          const SizedBox(height: 20),

          // Banners
          GetX<DashboardController>(
            builder: (controller) {
              if (controller.isLoading.value) {
                return const BannerShimmer();
              }

              return BannerCarousel(
                banners: controller.banners.map((b) {
                  return BannerItem(
                    imageUrl: b.imageUrl,
                    title: b.title,
                    subtitle: b.subtitle,
                  );
                }).toList(),
              );
            },
          ),

          const SizedBox(height: 20),

          // Featured Products
          SectionTitle(title: "featured_products".tr),
          Obx(() {
            if (controller.isLoading.value) {
              return SizedBox(
                height: 220,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: 6,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, __) => const ProductShimmer(),
                ),
              );
            }

            return HorizontalProductList(products: controller.products);
          }),

          const SizedBox(height: 20),

          // Categories
          SectionTitle(title: "categories".tr),
          CategoryGrid(),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

