import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/data/models/categories_listing.dart';
import 'package:listing_app/features/listing_services/listing_service_controller.dart';


class ServiceListPage extends StatelessWidget {
  final String categoryName;
  final int categoryId;

  const ServiceListPage({
    super.key,
    required this.categoryName,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ServiceController(categoryId));
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(categoryName, style: theme.textTheme.titleLarge),
            Text("${c.filtered.length} providers",
                style: theme.textTheme.bodySmall),
          ],
        )),
        leading: BackButton(),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list_rounded),
            onPressed: () => _openFilterSheet(context, c),
          )
        ],
      ),

      body: Column(
        children: [
          _buildSearchAndTagRow(context, c),

          Expanded(
            child: Obx(() {
              if (c.filtered.isEmpty) {
                return Center(child: Text("No data found"));
              }
              return ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: c.filtered.length,
                itemBuilder: (_, i) => ServiceCard(data: c.filtered[i]),
              );
            }),
          )
        ],
      ),
    );
  }
}
Widget _buildSearchAndTagRow(BuildContext context, ServiceController c) {
  final theme = Theme.of(context);

  return Padding(
    padding: const EdgeInsets.all(12),
    child: Row(
      children: [
        // SEARCH BAR
        Expanded(
          child: GestureDetector(
            onTap: () async {
              final q = await Get.to(() => const ServiceSearchPage());
              if (q != null && q is String) c.updateSearch(q);
            },
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: theme.iconTheme.color),
                  const SizedBox(width: 8),
                  Text("Search providers",
                      style: theme.textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),

        const SizedBox(width: 10),

        // TAG DROPDOWN
        Obx(() => DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: c.selectedTag.value,
            items: const [
              DropdownMenuItem(value: "All", child: Text("All")),
              DropdownMenuItem(value: "Verified", child: Text("Verified")),
              DropdownMenuItem(value: "Top Rated", child: Text("Top Rated")),
              DropdownMenuItem(value: "Trusted", child: Text("Trusted")),
            ],
            onChanged: (v) => c.updateTag(v!),
          ),
        )),
      ],
    ),
  );
}
void _openFilterSheet(BuildContext context, ServiceController c) {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (_) => Obx(() {
      return Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Sort by", style: TextStyle(fontSize: 18)),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ["Recommended", "Rating", "Reviews", "Experience"]
                  .map((s) => ChoiceChip(
                label: Text(s),
                selected: c.sortBy.value == s,
                onSelected: (_) => c.updateSort(s),
              ))
                  .toList(),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Apply"),
            )
          ],
        ),
      );
    }),
  );
}

class ServiceCard extends StatelessWidget {
  final CategoriesListingItem data;

  const ServiceCard({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          // IMAGE
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              data.mainImage,
              height: 90,
              width: 110,
              fit: BoxFit.cover,
            ),
          ),

          const SizedBox(width: 12),

          // INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(data.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium),

                const SizedBox(height: 6),

                Text(data.descriptionEn,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall),

                const SizedBox(height: 8),

                Text("\$${data.price}",
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.primary)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceSearchPage extends StatelessWidget {
  const ServiceSearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    final c = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Search Providers")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: c,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Type to search...",
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, c.text.trim()),
              child: const Text("Search"),
            )
          ],
        ),
      ),
    );
  }
}
