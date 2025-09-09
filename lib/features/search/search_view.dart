// search_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/routes/app_pages.dart';

class SearchView extends StatelessWidget {
  const SearchView({super.key});
  static final query = ''.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Get.offAndToNamed(AppRoutes.dashboard),
        ),
        title:
            _SearchField(), // place the search field inside app bar for pro look
        centerTitle: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // optional: a recent searches / suggestion header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "Recent Searches",
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                // Clear action (example)
                // InkWell(onTap: () {}, child: Text("Clear", style: TextStyle(color: Colors.blue))),
              ],
            ),
            const SizedBox(height: 12),
            // result / live typed preview
            Obx(() {
              final q = query.value;
              if (q.isEmpty) {
                return const Text(
                  "Try searching for products, categories or services.",
                );
              }
              return Text("Searching for: \"$q\"");
            }),
            // rest of UI (search results) goes here
          ],
        ),
      ),
    );
  }
}

/// extracted search field widget so we can reuse the same compact styling
class _SearchField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // visual match to the small search button: rounded, grey background, search icon
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          // TextField without border to match AppSearchBarButton style
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: (v) => SearchView.query.value = v,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                hintText: "Type to search...",
                hintStyle: TextStyle(color: Colors.grey.shade600),
                isDense: true,
                border: InputBorder.none,
                // remove default padding
                contentPadding: const EdgeInsets.symmetric(vertical: 10),
              ),
            ),
          ),
          // clear button (visible only when text not empty)
          Obx(() {
            return SearchView.query.value.isEmpty
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () => SearchView.query.value = '',
                    child: Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.grey.shade600,
                    ),
                  );
          }),
          const SizedBox(width: 6),
        ],
      ),
    );
  }
}
