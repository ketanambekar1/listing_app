// app_search_bar_button.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/routes/app_pages.dart';

class AppSearchBarButton extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;

  const AppSearchBarButton({super.key, this.hint = "Search...", this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap ??
              () {
                Get.toNamed(AppRoutes.search);
          },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
          // subtle shadow like a raised search chip
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hint,
                style: const TextStyle(color: Colors.grey, fontSize: 15),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 6),
            // optional mic / filter icon to match pro UI
            Icon(Icons.mic, color: Colors.grey.shade500, size: 18),
          ],
        ),
      ),
    );
  }
}
