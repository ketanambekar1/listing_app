import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/service_details/product_details_controller.dart';

class ProductDetailPage extends StatelessWidget {
  final controller = Get.put(ProductDetailController());

  ProductDetailPage({super.key}) {
    final id = Get.arguments['productId'];
    controller.loadProduct(id);
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isLoading.value) {
        return const Scaffold(body: Center(child: CircularProgressIndicator()));
      }

      final p = controller.product.value!;

      return DefaultTabController(
        length: 4,
        child: Scaffold(
          backgroundColor: Colors.white,
          bottomNavigationBar: _bottomBar(p),

          body: NestedScrollView(
            headerSliverBuilder: (_, __) => [_heroAppBar(p), _tabBar()],
            body: TabBarView(
              children: [
                _overviewTab(p),
                _detailsTab(p),
                _reviewsTab(p),
                _locationTab(p),
              ],
            ),
          ),
        ),
      );
    });
  }

  // ======================================================
  // 🔥 HERO SECTION
  // ======================================================
  Widget _heroAppBar(dynamic p) {
    return SliverAppBar(
      expandedHeight: 350,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            PageView(
              children: [
                Image.network(p.mainImage, fit: BoxFit.cover),
                ...p.images
                    .map<Widget>((e) => Image.network(e, fit: BoxFit.cover))
                    .toList(),
              ],
            ),

            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 180,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [Colors.black.withOpacity(0.6), Colors.transparent],
                  ),
                ),
              ),
            ),

            // ⭐ DYNAMIC FEATURED TAG
            if (p.isFeatured)
              Positioned(
                bottom: 20,
                left: 20,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.yellow,
                            size: 18,
                          ),
                          const SizedBox(width: 5),
                          Text(
                            "Featured",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // 🔥 TAB BAR
  // ======================================================
  Widget _tabBar() {
    return SliverPersistentHeader(
      pinned: true,
      delegate: _SliverTabDelegate(
        const TabBar(
          labelColor: Colors.blueAccent,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blueAccent,
          tabs: [
            Tab(text: "Overview"),
            Tab(text: "Details"),
            Tab(text: "Reviews"),
            Tab(text: "Location"),
          ],
        ),
      ),
    );
  }

  // ======================================================
  // 🔥 TAB 1 — OVERVIEW (DYNAMIC)
  // ======================================================
  Widget _overviewTab(dynamic p) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _titlePriceRating(p),
        const SizedBox(height: 20),
        _contactSection(p),
        const SizedBox(height: 20),
        _sellerCard(p),
        const SizedBox(height: 20),
        _gallery(p),
        const SizedBox(height: 100),
      ],
    );
  }

  // ⭐ TITLE / PRICE / RATING — DYNAMIC
  Widget _titlePriceRating(dynamic p) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          p.title,
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            height: 1.3,
          ),
        ),
        const SizedBox(height: 10),

        Text(
          "${p.price} ${p.currency}",
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.green,
          ),
        ),

        const SizedBox(height: 12),

        Row(
          children: [
            ...List.generate(
              5,
              (i) => Icon(
                i < p.ratingAvg.round() ? Icons.star : Icons.star_border,
                color: Colors.amber,
                size: 21,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "${p.ratingAvg} (${p.ratingCount} reviews)",
              style: TextStyle(color: Colors.grey.shade600),
            ),
          ],
        ),
      ],
    );
  }

  // ======================================================
  // 🔥 CONTACT SECTION — DYNAMIC
  // ======================================================
  Widget _contactSection(dynamic p) {
    return _section(
      title: "Contact",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (p.phone != null)
            Row(
              children: [
                Icon(Icons.phone, color: Colors.blue.shade700),
                const SizedBox(width: 8),
                Text(
                  p.phone!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),

          const SizedBox(height: 10),

          if (p.website != null)
            Row(
              children: [
                Icon(Icons.language, color: Colors.purple.shade700),
                const SizedBox(width: 8),
                Text(
                  p.website!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.purple.shade700,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // ======================================================
  // 🔥 SELLER CARD — DYNAMIC
  // ======================================================
  Widget _sellerCard(dynamic p) {
    return _section(
      title: "Seller",
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.blue.shade50,
            child: const Icon(Icons.store, size: 32, color: Colors.blue),
          ),
          const SizedBox(width: 14),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.sellerName ?? "Unknown Seller",
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              // Text(
              //   "Since ${p.createdAtString ?? "N/A"}",
              //   style: TextStyle(color: Colors.grey.shade600),
              // ),
            ],
          ),
        ],
      ),
    );
  }

  // ======================================================
  // 🔥 GALLERY — DYNAMIC
  // ======================================================
  Widget _gallery(dynamic p) {
    return _section(
      title: "Gallery",
      child: SizedBox(
        height: 120,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: p.images
              .map<Widget>(
                (e) => Container(
                  margin: const EdgeInsets.only(right: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(e),
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  // ======================================================
  // 🔥 TAB 2 — DETAILS (DYNAMIC)
  // ======================================================
  Widget _detailsTab(dynamic p) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: p.attributes.entries
          .map<Widget>(
            (e) => Card(
              elevation: 1,
              child: ListTile(
                title: Text(
                  e.key,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(e.value.toString()),
              ),
            ),
          )
          .toList(),
    );
  }

  // ======================================================
  // 🔥 TAB 3 — REVIEWS (DYNAMIC)
  // ======================================================
  Widget _reviewsTab(dynamic p) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(
          "Customer Reviews (${p.ratingCount})",
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        if (p.ratingCount == 0) const Text("No reviews yet."),

        if (p.ratingCount > 0)
          const _ReviewItem(
            name: "Dynamic User",
            rating: 5,
            text: "Dynamic review... (You will add API later)",
          ),
      ],
    );
  }

  // ======================================================
  // 🔥 TAB 4 — LOCATION (DYNAMIC)
  // ======================================================
  Widget _locationTab(dynamic p) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text(
          "Store Location",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        Container(
          height: 250,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.grey.shade200,
            image: p.latitude != null && p.longitude != null
                ? DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://maps.googleapis.com/maps/api/staticmap?center=${p.latitude},${p.longitude}&zoom=15&size=600x300&markers=color:red%7C${p.latitude},${p.longitude}",
                    ),
                  )
                : const DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                      "https://developers.google.com/static/maps/images/landing/hero_maps_static_api.png",
                    ),
                  ),
          ),
        ),

        const SizedBox(height: 12),

        if (p.address != null)
          Text(p.address!, style: const TextStyle(fontSize: 16)),

        const SizedBox(height: 100),
      ],
    );
  }

  // ======================================================
  // 🔥 BOTTOM BAR (DYNAMIC CALL BUTTON)
  // ======================================================
  Widget _bottomBar(dynamic p) {
    return Container(
      height: 80,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: const Offset(0, -2),
            color: Colors.black.withOpacity(0.12),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: p.phone != null
                  ? () {
                      // YOU WILL ADD Call plugin later
                    }
                  : null,
              child: const Text("Call Now", style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: OutlinedButton(
              onPressed: () {},
              child: const Text("Message", style: TextStyle(fontSize: 18)),
            ),
          ),
        ],
      ),
    );
  }

  // ======================================================
  // GENERAL SECTION WRAPPER
  // ======================================================
  Widget _section({required String title, required Widget child}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            blurRadius: 8,
            color: Colors.black.withOpacity(0.08),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          child,
        ],
      ),
    );
  }
}

class _SliverTabDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tab;

  _SliverTabDelegate(this.tab);

  @override
  Widget build(context, shrinkOffset, overlapsContent) {
    return Container(color: Colors.white, child: tab);
  }

  @override
  double get maxExtent => tab.preferredSize.height;

  @override
  double get minExtent => tab.preferredSize.height;

  @override
  bool shouldRebuild(_) => false;
}

class _ReviewItem extends StatelessWidget {
  final String name;
  final String text;
  final int rating;

  const _ReviewItem({
    super.key,
    required this.name,
    required this.text,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            blurRadius: 6,
            color: Colors.black.withOpacity(0.06),
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < rating ? Icons.star : Icons.star_border,
                    color: Colors.amber,
                    size: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(text),
        ],
      ),
    );
  }
}
