import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String titleKey; // key for translation
  final VoidCallback? onProfileTap;
  final VoidCallback? onNotificationTap;

  const AppHeader({
    super.key,
    required this.titleKey,
    this.onProfileTap,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      centerTitle: true,
      leading: IconButton(
        icon: Icon(Icons.person, color: theme.iconTheme.color),
        onPressed: onProfileTap,
      ),
      title:
      Text(
        titleKey.tr, // 🔑 translated title
        style: GoogleFonts.pacifico(
          textStyle: theme.textTheme.titleLarge?.copyWith(
            fontSize: 24,
            color: theme.textTheme.titleLarge?.color,
          ),
        ),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.notifications, color: theme.iconTheme.color),
          onPressed: onNotificationTap,
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
