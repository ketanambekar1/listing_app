import 'package:flutter/material.dart';

class AppSearchBarButton extends StatelessWidget {
  final String hint;
  final VoidCallback? onTap;

  const AppSearchBarButton({super.key, this.hint = "Search...", this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.search, color: Colors.grey),
            const SizedBox(width: 8),
            Text(hint, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }
}
