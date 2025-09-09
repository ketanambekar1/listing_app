import 'package:get/get.dart';

class AppTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en': {
      'home': 'Home',
      'search': 'Search',
      'cart': 'Cart',
      'profile': 'Profile',
      'more': 'More',
      'theme': 'Theme',
      'language': 'Language',
      'featured_products': 'Featured Products',
      'categories': 'Categories',
      'account_settings': 'Account Settings',
      'phone': 'Phone',
      'email': 'Email',
    },
    'ar': {
      'home': 'الرئيسية',
      'search': 'بحث',
      'cart': 'عربة التسوق',
      'profile': 'الملف الشخصي',
      'more': 'المزيد',
      'theme': 'الوضع',
      'language': 'اللغة',
      'featured_products': 'منتجات مميزة',
      'categories': 'الفئات',
      'account_settings': 'إعدادات الحساب',
      'phone': 'الهاتف',
      'email': 'البريد الإلكتروني',
    }
  };
}
