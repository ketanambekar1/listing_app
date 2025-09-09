import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/dashboard/dashboard_controller.dart';
import 'package:listing_app/features/dashboard/widgets/listing_widgets.dart';
import 'package:listing_app/features/more/more_view.dart';
import 'package:listing_app/features/search/search_view.dart';
import 'package:listing_app/routes/app_pages.dart';
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
      padding: const EdgeInsets.all(16),
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
        BannerCarousel(
          banners: [
            "https://tse4.mm.bing.net/th/id/OIP.adIP514wWZo-M_odEJ8vrAHaE8?cb=thfc1&rs=1&pid=ImgDetMain&o=7&rm=3",
            "https://tse2.mm.bing.net/th/id/OIP.mw7dj-4eLLBAK11cTAznAwHaE6?cb=thfc1&rs=1&pid=ImgDetMain&o=7&rm=3",
          ],
        ),
        const SizedBox(height: 20),
        SectionTitle(title: "featured_products".tr),
        HorizontalProductList(
          products: List.generate(
            10,
            (i) => ProductItemData(
              title: "Product $i",
              price: "\$${(i + 1) * 10}",
              image:
                  "https://tse3.mm.bing.net/th/id/OIP.ZHIPM-cqX1-Z5VUsuH4f3QHaFF?cb=thfc1&rs=1&pid=ImgDetMain&o=7&rm=3",
            ),
          ),
        ),
        const SizedBox(height: 20),
        SectionTitle(title: "categories".tr),
        GridCategoryList(
          categories: List.generate(
            6,
            (i) => CategoryItemData(
              title: "Category $i",
              image:
                  "https://thf.bing.com/th/id/OIP.vFIsxbbHX6RPRIEHU1H_pwHaEs?o=7&cb=thfc1rm=3&rs=1&pid=ImgDetMain&o=7&rm=3",
            ),
          ),
        ),
      ],
    );
  }
}

class _SearchSection extends StatelessWidget {
  const _SearchSection();

  @override
  Widget build(BuildContext context) {
    return Center(child: Text("Search functionality coming soon".tr));
  }
}
