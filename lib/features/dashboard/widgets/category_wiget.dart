import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/listing_services/listing_services.dart';
import 'package:listing_app/theme/theme_service.dart';

class CategoryGrid extends StatelessWidget {
  const CategoryGrid({super.key});

  // small built-in translations (expandable). keys must match categories below.
  static const Map<String, Map<String, String>> _i18n = {
    "home": {"en": "Home", "ar": "الرئيسية"},
    "shop": {"en": "Shop", "ar": "تسوق"},
    "food": {"en": "Food", "ar": "طعام"},
    "travel": {"en": "Travel", "ar": "سفر"},
    "movies": {"en": "Movies", "ar": "أفلام"},
    "sports": {"en": "Sports", "ar": "رياضة"},
    "books": {"en": "Books", "ar": "كتب"},
    "tech": {"en": "Tech", "ar": "تقنية"},
    "music": {"en": "Music", "ar": "موسيقى"},
    "cycle": {"en": "Cycle", "ar": "دراجة"},
    "pets": {"en": "Pets", "ar": "حيوانات أليفة"},
    "art": {"en": "Art", "ar": "فن"},
    "nature": {"en": "Nature", "ar": "طبيعة"},
    "work": {"en": "Work", "ar": "عمل"},
    "fitness": {"en": "Fitness", "ar": "لياقة"},
    "view_more": {"en": "View More", "ar": "عرض المزيد"},
    // generic messages
    "view_more_clicked": {"en": "View more clicked", "ar": "تم الضغط على عرض المزيد"},
    "category_tapped": {"en": "{} tapped", "ar": "تم الضغط على {}"},
  };

  String _t(BuildContext context, String key, [List<String>? params]) {
    final ThemeService _themeService = Get.find();
    final locale = _themeService.locale.languageCode;
    final map = _i18n[key] ?? {};
    final text = (map[locale] ?? map['en'] ?? key);
    if (params != null && params.isNotEmpty) {
      var out = text;
      for (var p in params) {
        out = out.replaceFirst('{}', p);
      }
      return out;
    }
    return text;
  }

  @override
  Widget build(BuildContext context) {
    // Example categories (15) - last slot becomes "View More"
    final categories = <_CategoryData>[
      _CategoryData(key: "home", icon: Icons.home, color: Colors.blue),
      _CategoryData(key: "shop", icon: Icons.shopping_cart, color: Colors.deepOrange),
      _CategoryData(key: "food", icon: Icons.fastfood, color: Colors.green),
      _CategoryData(key: "travel", icon: Icons.flight, color: Colors.indigo),
      _CategoryData(key: "movies", icon: Icons.movie, color: Colors.redAccent),
      _CategoryData(key: "sports", icon: Icons.sports_soccer, color: Colors.teal),
      _CategoryData(key: "books", icon: Icons.book, color: Colors.deepPurple),
      _CategoryData(key: "tech", icon: Icons.computer, color: Colors.cyan),
      _CategoryData(key: "music", icon: Icons.music_note, color: Colors.pink),
      _CategoryData(key: "cycle", icon: Icons.pedal_bike, color: Colors.orange),
      _CategoryData(key: "fitness", icon: Icons.fitness_center, color: Colors.lime),
      _CategoryData(key: "pets", icon: Icons.pets, color: Colors.brown),
      _CategoryData(key: "art", icon: Icons.brush, color: Colors.purple),
      _CategoryData(key: "nature", icon: Icons.nature, color: Colors.lightGreen),
      _CategoryData(key: "work", icon: Icons.work, color: Colors.blueGrey),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        const columns = 4;
        const outerPadding = 12.0;
        const spacing = 12.0;

        final totalHorizontal = outerPadding * 2 + spacing * (columns - 1);
        final itemWidth = (width - totalHorizontal) / columns;

        final iconBoxSize = (itemWidth * 0.6).clamp(50.0, 72.0);
        final fontSize = _adaptiveFontSize(width);

        // Theme-aware colors
        final theme = Theme.of(context);
        final textColor = theme.textTheme.bodyMedium?.color ?? Colors.black87;
        final shadowColor = theme.shadowColor.withOpacity(0.06);

        return Padding(
          padding: const EdgeInsetsDirectional.symmetric(horizontal: outerPadding, vertical: 8),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 16, // 4x4
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: columns,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: (itemWidth / (itemWidth * 1.05)),
            ),
            itemBuilder: (context, index) {
              if (index == 15) {
                return _GridItem(
                  label: _t(context, "view_more"),
                  icon: Icons.more_horiz,
                  size: iconBoxSize,
                  bgColor: theme.brightness == Brightness.dark ? Colors.grey.shade700 : Colors.grey.shade300,
                  fontSize: fontSize,
                  textColor: textColor,
                  shadowColor: shadowColor,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(_t(context, "view_more_clicked"))),
                    );
                    Get.to(() => ServiceListPage(category: _t(context, "view_more")));
                  },
                );
              }

              final data = categories[index];
              final label = _t(context, data.key);

              // Use a color palette that adapts a bit for dark mode (increase luminance)
              final bg = _adaptiveBgColor(context, data.color);

              return _GridItem(
                label: label,
                icon: data.icon,
                size: iconBoxSize,
                bgColor: bg,
                fontSize: fontSize,
                textColor: textColor,
                shadowColor: shadowColor,
                onTap: () {
                  final msgTemplate = _t(context, "category_tapped");
                  // replace placeholder
                  final msg = msgTemplate.replaceFirst('{}', label);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
                  Get.to(() => ServiceListPage(category: label));
                },
              );
            },
          ),
        );
      },
    );
  }

  // simple dark-mode friendly bg color tweak
  Color _adaptiveBgColor(BuildContext context, Color color) {
    final brightness = Theme.of(context).brightness;
    if (brightness == Brightness.dark) {
      // In dark mode, make it slightly desaturated and darker for contrast
      return Color.alphaBlend(Colors.black.withOpacity(0.22), color).withOpacity(0.95);
    }
    return color;
  }

  static double _adaptiveFontSize(double width) {
    if (width < 360) return 11.0;
    if (width < 420) return 12.0;
    return 13.0;
  }
}

class _CategoryData {
  final String key; // key used for translation lookup
  final IconData icon;
  final Color color;
  const _CategoryData({required this.key, required this.icon, required this.color});
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
          // colorful rounded rectangle box (no circular border) with full-color icon
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(14),
              boxShadow: [
                BoxShadow(
                  color: shadowColor,
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(
                icon,
                size: size * 0.55,
                color: Colors.white,
              ),
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
