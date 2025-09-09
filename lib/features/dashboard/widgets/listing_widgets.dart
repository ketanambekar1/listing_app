import 'package:flutter/material.dart';

/// Section Title
class SectionTitle extends StatelessWidget {
  final String title;
  const SectionTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Banner Carousel (simple horizontal scroll)
class BannerCarousel extends StatelessWidget {
  final List<String> banners;
  const BannerCarousel({super.key, required this.banners});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: PageView.builder(
        controller: PageController(viewportFraction: 0.9),
        itemCount: banners.length,
        itemBuilder: (_, i) => Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            image: DecorationImage(
              image: NetworkImage(banners[i]),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

/// Product Item Data
class ProductItemData {
  final String title;
  final String price;
  final String image;

  ProductItemData({required this.title, required this.price, required this.image});
}

/// Horizontal Product List
class HorizontalProductList extends StatelessWidget {
  final List<ProductItemData> products;
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
          return Container(
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
                )
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(p.image, fit: BoxFit.cover, width: double.infinity),
                  ),
                ),
                const SizedBox(height: 8),
                Text(p.title, style: Theme.of(context).textTheme.bodyMedium),
                Text(p.price,
                    style: Theme.of(context)
                        .textTheme
                        .bodyMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Category Item Data
class CategoryItemData {
  final String title;
  final String image;

  CategoryItemData({required this.title, required this.image});
}

/// Grid Category List
class GridCategoryList extends StatelessWidget {
  final List<CategoryItemData> categories;
  const GridCategoryList({super.key, required this.categories});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 1,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (_, i) {
        final cat = categories[i];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Theme.of(context).cardColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(2, 2),
              )
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(cat.image, height: 60, width: 60, fit: BoxFit.cover),
              ),
              const SizedBox(height: 8),
              Text(cat.title, style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        );
      },
    );
  }
}
