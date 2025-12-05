import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/search/search_controller.dart';
import 'package:listing_app/routes/app_pages.dart';
import 'package:listing_app/widgets/app_no_data_widget.dart';

class SearchView extends StatelessWidget {
  SearchView({super.key});
  final SearchWidgetController controller = Get.put(SearchWidgetController());


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(context),
      body: Column(
        children: [
          const SizedBox(height: 8),
          _suggestionBar(),
          const SizedBox(height: 10),
          Expanded(child: _resultsSection()),
        ],
      ),
    );
  }

  // 🔥 CUSTOM APP BAR
  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      leading: GestureDetector(
        onTap: () => Get.offAllNamed(AppRoutes.dashboard),
        child: const Icon(Icons.arrow_back, color: Colors.black87),
      ),
      title: _searchField(),
    );
  }

  Widget _searchField() {
    return Container(
      height: 44,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Colors.grey),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              autofocus: true,
              onChanged: (v) => controller.query.value = v,
              decoration: const InputDecoration(
                hintText: "Search products...",
                border: InputBorder.none,
              ),
            ),
          ),
          Obx(() {
            return controller.query.value.isEmpty
                ? const SizedBox()
                : GestureDetector(
                    onTap: () => controller.query.value = "",
                    child: const Icon(Icons.close, size: 18),
                  );
          }),
        ],
      ),
    );
  }

  // 🔥 TRENDING SEARCHES
  Widget _suggestionBar() {
    return Obx(() {
      if (controller.query.value.isNotEmpty) return const SizedBox.shrink();

      return SizedBox(
        height: 36,
        child: ListView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            _chip("Samsung"),
            _chip("iPhone"),
            _chip("Laptop"),
            _chip("AC"),
            _chip("Shoes"),
          ],
        ),
      );
    });
  }

  Widget _chip(String label) {
    return GestureDetector(
      onTap: () => controller.query.value = label,
      child: Container(
        margin: const EdgeInsets.only(right: 10),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.blueAccent.withOpacity(0.12),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: const TextStyle(color: Colors.blueAccent)),
      ),
    );
  }

  // 🔥 MAIN RESULT AREA
  Widget _resultsSection() {
    return Obx(() {
      if (controller.query.value.isEmpty) {
        return const NoDataWidget(message: "Start typing to search...");
      }

      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.results.isEmpty) {
        return NoDataWidget(message: "No results found!");
      }

      return ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: controller.results.length,
        itemBuilder: (_, i) => _productTile(controller.results[i]),
      );
    });
  }

  // 🔥 BEAUTIFUL PRODUCT RESULT TILE
  Widget _productTile(dynamic p) {
    return GestureDetector(
      onTap: () => Get.toNamed(
        AppRoutes.productDetailPage,
        arguments: {"productId": p.id},
      ),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 3),
              color: Colors.black.withOpacity(0.05),
            ),
          ],
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                p.mainImage,
                width: 80,
                height: 80,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 4),

                  Text(
                    "${p.price} ${p.currency}",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Row(
                    children: List.generate(
                      5,
                      (i) => Icon(
                        i < p.ratingAvg.round()
                            ? Icons.star
                            : Icons.star_border,
                        size: 16,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
