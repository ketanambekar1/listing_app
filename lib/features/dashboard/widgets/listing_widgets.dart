import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/data/models/feature_product_items.dart';
import 'package:listing_app/routes/app_pages.dart';

/// Section Title
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.only(left: 16, bottom: 12),
      child: Text(
        title,
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }
}

/// Banner Carousel (simple horizontal scroll)

/// Product Item Data

/// Horizontal Product List
class HorizontalProductList extends StatelessWidget {
  final List<FeatureProductItemData> products;
  const HorizontalProductList({super.key, required this.products});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 220,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: products.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) {
          final p = products[i];
          return GestureDetector(
            onTap: () {
              Get.toNamed(
                AppRoutes.productDetailPage,
                arguments: {'productId': p.id},
              );
            },
            child: Container(
              width: 150,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: Theme.of(context).cardColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(2, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.network(
                        p.image,
                        fit: BoxFit.cover,
                        width: double.infinity,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    p.getTitle(),
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  Text(
                    p.price,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
