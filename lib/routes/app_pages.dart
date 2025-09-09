import 'package:get/get.dart';
import 'package:listing_app/features/dashboard/dashboard_binding.dart';
import 'package:listing_app/features/dashboard/dashboard_view.dart';
import 'package:listing_app/features/more/more_binding.dart';
import 'package:listing_app/features/more/more_view.dart';
import 'package:listing_app/features/profile/profile_view.dart';
import 'package:listing_app/features/search/search_view.dart';

class AppRoutes {
  static const dashboard = '/dashboard';
  static const more = '/more';
  static const profile = '/profile';
  static const search = '/search';

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
  ];
}
