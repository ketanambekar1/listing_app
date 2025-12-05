import 'package:get/get.dart';
import 'package:listing_app/features/dashboard/dashboard_binding.dart';
import 'package:listing_app/features/dashboard/dashboard_view.dart';
import 'package:listing_app/features/listing_services/listing_services.dart';
import 'package:listing_app/features/more/more_binding.dart';
import 'package:listing_app/features/more/more_view.dart';
import 'package:listing_app/features/profile/profile_view.dart';
import 'package:listing_app/features/search/search_view.dart';
import 'package:listing_app/features/service_details/product_detail_view.dart';

class AppRoutes {
  static const dashboard = '/dashboard';
  static const more = '/more';
  static const profile = '/profile';
  static const search = '/search';
  static const serviceListPage = '/service-list-page';
  static const productDetailPage = '/product-detail-page';
}

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.dashboard,
      page: () => DashboardView(),
      binding: DashboardBinding(),
    ),
    GetPage(
      name: AppRoutes.more,
      page: () => MoreView(),
      binding: MoreBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => ProfileView(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.search,
      page: () => SearchView(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.serviceListPage,
      page: () => ServiceListPage(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.productDetailPage,
      page: () => ProductDetailPage(),
      transition: Transition.downToUp,
      transitionDuration: const Duration(milliseconds: 300),
    ),
  ];
}
