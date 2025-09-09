import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:listing_app/features/service_details/service_detail.dart'; // your detail page

/// Model (re-used; keep same as your detail page expects)
// class ServiceItemData {
//   final String id;
//   final String name;
//   final String photo;
//   final List<String> photos;
//   final double rating;
//   final int reviews;
//   final String address;
//   final String experience; // e.g. "10 yrs"
//   final String timings; // e.g. "09:00 AM - 08:00 PM";
//   final bool verified;
//   final bool topRated;
//   final bool trusted;
//   final String responseTime; // e.g. "60 mins"
//
//   ServiceItemData({
//     required this.id,
//     required this.name,
//     required this.photo,
//     this.photos = const [],
//     required this.rating,
//     required this.reviews,
//     required this.address,
//     required this.experience,
//     required this.timings,
//     this.verified = false,
//     this.topRated = false,
//     this.trusted = false,
//     this.responseTime = "60 mins",
//   });
// }

/// Service list page (RTL + Theme friendly)
class ServiceListPage extends StatefulWidget {
  final String category;
  const ServiceListPage({super.key, required this.category});

  @override
  State<ServiceListPage> createState() => _ServiceListPageState();
}

class _ServiceListPageState extends State<ServiceListPage> {
  // Dummy data
  final List<ServiceItemData> _allServices = [
    ServiceItemData(
      id: "s1",
      name: "Spark Cleaners",
      photo:
          "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=1200",
      photos: [
        "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=1200",
        "https://images.unsplash.com/photo-1521590832167-7bcbfaa6381f?w=1200",
      ],
      rating: 4.6,
      reviews: 128,
      address: "Sector 18, MG Road",
      experience: "8 yrs",
      timings: "09:00 AM - 07:00 PM",
      verified: true,
      topRated: true,
      trusted: true,
    ),
    ServiceItemData(
      id: "s2",
      name: "QuickFix Electricians",
      photo:
          "https://images.unsplash.com/photo-1518770660439-4636190af475?w=800",
      photos: [],
      rating: 4.2,
      reviews: 64,
      address: "Near City Mall",
      experience: "5 yrs",
      timings: "10:00 AM - 09:00 PM",
      verified: true,
      trusted: true,
    ),
    ServiceItemData(
      id: "s3",
      name: "Happy Cuts Salon",
      photo:
          "https://images.unsplash.com/photo-1581092795360-fd1ca04f0952?w=1200",
      photos: [],
      rating: 4.8,
      reviews: 240,
      address: "Rose Avenue",
      experience: "12 yrs",
      timings: "10:00 AM - 08:00 PM",
      topRated: true,
    ),
    ServiceItemData(
      id: "s4",
      name: "Green Landscaping",
      photo:
          "https://images.unsplash.com/photo-1501004318641-b39e6451bec6?w=800",
      photos: [],
      rating: 4.4,
      reviews: 31,
      address: "Lakeview Colony",
      experience: "6 yrs",
      timings: "08:00 AM - 06:00 PM",
      trusted: true,
    ),
  ];

  late List<ServiceItemData> _visible;

  // Filters
  String _selectedTag = "All";
  String _sortBy = "Recommended";
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _visible = List.from(_allServices);
  }

  void _applyFilters() {
    List<ServiceItemData> tmp = List.from(_allServices);
    if (_selectedTag == "Verified") tmp = tmp.where((s) => s.verified).toList();
    if (_selectedTag == "Top Rated")
      tmp = tmp.where((s) => s.topRated).toList();
    if (_selectedTag == "Trusted") tmp = tmp.where((s) => s.trusted).toList();

    if (_searchQuery.isNotEmpty) {
      tmp = tmp
          .where(
            (s) =>
                s.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                s.address.toLowerCase().contains(_searchQuery.toLowerCase()),
          )
          .toList();
    }

    if (_sortBy == "Rating") tmp.sort((a, b) => b.rating.compareTo(a.rating));
    if (_sortBy == "Reviews")
      tmp.sort((a, b) => b.reviews.compareTo(a.reviews));
    if (_sortBy == "Experience") {
      tmp.sort((a, b) {
        final ax = int.tryParse(a.experience.split(" ").first) ?? 0;
        final bx = int.tryParse(b.experience.split(" ").first) ?? 0;
        return bx.compareTo(ax);
      });
    }
    setState(() => _visible = tmp);
  }

  void _openFilterSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        String localSort = _sortBy;
        return StatefulBuilder(
          builder: (c, setLocal) {
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Filters",
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Sort by",
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: ["Recommended", "Rating", "Reviews", "Experience"]
                        .map((s) {
                          final sel = s == localSort;
                          return ChoiceChip(
                            label: Text(s),
                            selected: sel,
                            onSelected: (_) => setLocal(() => localSort = s),
                            selectedColor: Theme.of(
                              context,
                            ).colorScheme.primary.withOpacity(0.14),
                          );
                        })
                        .toList(),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      setState(() => _sortBy = localSort);
                      _applyFilters();
                      Navigator.pop(ctx);
                    },
                    child: const Text("Apply"),
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final dir = Directionality.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.scaffoldBackgroundColor,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: theme.iconTheme.color ?? Colors.black87,
          ),
          onPressed: () => Get.back(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.category,
              style: textTheme.titleLarge?.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color ?? Colors.black87,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "${_allServices.length} providers",
              style: textTheme.bodySmall?.copyWith(color: theme.hintColor),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list_rounded, color: theme.iconTheme.color),
            onPressed: _openFilterSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          // top search + quick filters (directional padding)
          Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () async {
                      final q = await Get.to(() => const _ServiceSearchPage());
                      if (q is String) {
                        setState(() => _searchQuery = q);
                        _applyFilters();
                      }
                    },
                    child: Container(
                      height: 46,
                      padding: const EdgeInsetsDirectional.symmetric(
                        // start: 14,
                        // end: 14,
                      ),
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? Colors.white10
                            : Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.search,
                            color: theme.iconTheme.color?.withOpacity(0.7),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              "Search providers or address",
                              style: textTheme.bodyMedium?.copyWith(
                                color: theme.hintColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // tag chips horizontal (directional aware)
                Container(
                  height: 46,
                  padding: const EdgeInsetsDirectional.symmetric(
                    // start: 6,
                    // end: 6,
                  ),
                  decoration: BoxDecoration(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white10
                        : Colors.grey[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.tune, size: 18, color: theme.iconTheme.color),
                      const SizedBox(width: 8),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedTag,
                          items: const [
                            DropdownMenuItem(value: "All", child: Text("All")),
                            DropdownMenuItem(
                              value: "Verified",
                              child: Text("Verified"),
                            ),
                            DropdownMenuItem(
                              value: "Top Rated",
                              child: Text("Top Rated"),
                            ),
                            DropdownMenuItem(
                              value: "Trusted",
                              child: Text("Trusted"),
                            ),
                          ],
                          onChanged: (v) {
                            if (v == null) return;
                            setState(() => _selectedTag = v);
                            _applyFilters();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // content
          Expanded(
            child: _visible.isEmpty
                ? Center(
                    child: Text(
                      "No providers found",
                      style: textTheme.bodyMedium,
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsetsDirectional.fromSTEB(
                      12,
                      8,
                      12,
                      12,
                    ),
                    itemCount: _visible.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, idx) {
                      final s = _visible[idx];
                      return ServiceCard(
                        data: s,
                        onTap: () =>
                            Get.to(() => ServiceDetailPage(service: s)),
                        onCall: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Call ${s.name}')),
                            ),
                        onEnquiry: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Enquiry ${s.name}')),
                            ),
                        onWhatsapp: () =>
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('WhatsApp ${s.name}')),
                            ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// small search page
class _ServiceSearchPage extends StatelessWidget {
  const _ServiceSearchPage({super.key});
  @override
  Widget build(BuildContext context) {
    final TextEditingController c = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Search Providers",
          style: Theme.of(context).textTheme.titleMedium,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: c,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "Search for provider or address",
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
            ),
          ],
        ),
      ),
    );
  }
}

/// Professional Service Card (directional + theme friendly)
class ServiceCard extends StatelessWidget {
  final ServiceItemData data;
  final VoidCallback? onTap;
  final VoidCallback? onCall;
  final VoidCallback? onEnquiry;
  final VoidCallback? onWhatsapp;

  const ServiceCard({
    super.key,
    required this.data,
    this.onTap,
    this.onCall,
    this.onEnquiry,
    this.onWhatsapp,
  });

  static const String _fallbackImage =
      "https://via.placeholder.com/800x500?text=No+Image";

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final imageWidth = (MediaQuery.of(context).size.width * 0.30).clamp(
      96.0,
      140.0,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: theme.cardColor,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withOpacity(0.04),
              blurRadius: 12,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image with badge overlay
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: imageWidth,
                    child: AspectRatio(
                      aspectRatio: 4 / 3,
                      child: Stack(
                        children: [
                          Positioned.fill(
                            child: Image.network(
                              data.photo,
                              fit: BoxFit.cover,
                              errorBuilder: (_, __, ___) => Image.network(
                                _fallbackImage,
                                fit: BoxFit.cover,
                              ),
                              loadingBuilder: (_, child, progress) {
                                if (progress == null) return child;
                                return Container(
                                  color: Colors.grey.shade100,
                                  child: const Center(
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),

                          // subtle gradient bottom
                          Positioned.fill(
                            child: DecoratedBox(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.center,
                                  colors: [Colors.black26, Colors.transparent],
                                ),
                              ),
                            ),
                          ),

                          // badge (directional: start/top)
                          if (data.verified)
                            PositionedDirectional(
                              start: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.verified,
                                      size: 12,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      "Verified",
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Details
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // tags (scrollable)
                      SizedBox(
                        height: 28,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          children: [
                            if (data.verified)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 6,
                                ),
                                child: _chip(
                                  context,
                                  "Verified",
                                  Icons.verified,
                                  colorScheme.primary,
                                ),
                              ),
                            if (data.topRated)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 6,
                                ),
                                child: _chip(
                                  context,
                                  "Top Rated",
                                  Icons.star,
                                  Colors.amber,
                                ),
                              ),
                            if (data.trusted)
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                  end: 6,
                                ),
                                child: _chip(
                                  context,
                                  "Trusted",
                                  Icons.thumb_up,
                                  Colors.green,
                                ),
                              ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 6),

                      // title + rating on the same row
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              data.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          _ratingBadge(context, data.rating, data.reviews),
                        ],
                      ),

                      const SizedBox(height: 6),

                      // address
                      Text(
                        data.address,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.hintColor,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // info row
                      Row(
                        children: [
                          _infoInline(
                            context,
                            Icons.work_outline,
                            data.experience,
                          ),
                          const SizedBox(width: 12),
                          _infoInline(
                            context,
                            Icons.access_time_outlined,
                            data.timings,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [_responsePill(context, data.responseTime)],
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // CTA row — horizontally scrollable to fit on small devices; uses theme for colors
            SizedBox(
              height: 40,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _ctaButton(
                      context,
                      icon: Icons.call,
                      label: "Call Now",
                      onTap: onCall,
                      filled: true,
                    ),
                    const SizedBox(width: 8),
                    _ctaButton(
                      context,
                      icon: Icons.message,
                      label: "Send Enquiry",
                      onTap: onEnquiry,
                      filled: false,
                    ),
                    const SizedBox(width: 8),
                    _iconSquareButton(
                      icon: Icons.phone,
                      color: Colors.green.shade700,
                      onTap: onWhatsapp,
                    ),
                    const SizedBox(width: 8),
                    _ctaPill(
                      context,
                      icon: Icons.directions,
                      label: "Directions",
                    ),
                    const SizedBox(width: 8),
                    _ctaPill(
                      context,
                      icon: Icons.info_outline,
                      label: "Details",
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // small reusable widgets (theme aware & directional-safe)
  Widget _chip(BuildContext c, String text, IconData icon, Color color) {
    final theme = Theme.of(c);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingBadge(BuildContext c, double rating, int reviews) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.green.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            rating.toStringAsFixed(1),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 6),
          const Icon(Icons.star, size: 14, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            "($reviews)",
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _infoInline(BuildContext c, IconData icon, String text) {
    final theme = Theme.of(c);
    return Row(
      children: [
        Icon(icon, size: 14, color: theme.iconTheme.color?.withOpacity(0.8)),
        const SizedBox(width: 6),
        Text(text, style: theme.textTheme.bodyMedium?.copyWith(fontSize: 12)),
      ],
    );
  }

  Widget _responsePill(BuildContext c, String txt) {
    final theme = Theme.of(c);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.orange.shade700.withOpacity(0.12)
            : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.timer, size: 14, color: Colors.orange),
          const SizedBox(width: 6),
          Text(
            txt,
            style: const TextStyle(
              color: Colors.orange,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ctaButton(
    BuildContext c, {
    required IconData icon,
    required String label,
    VoidCallback? onTap,
    bool filled = true,
  }) {
    final theme = Theme.of(c);
    if (filled) {
      return ElevatedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16,color: Colors.white),
        label: Text(label, style: TextStyle(color: Colors.white),),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: theme.colorScheme.primary,
        ),
      );
    } else {
      return OutlinedButton.icon(
        onPressed: onTap,
        icon: Icon(icon, size: 16),
        label: Text(label),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          side: BorderSide(color: theme.dividerColor),
        ),
      );
    }
  }

  Widget _iconSquareButton({
    required IconData icon,
    required Color color,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 18),
      ),
    );
  }

  Widget _ctaPill(
    BuildContext c, {
    required IconData icon,
    required String label,
  }) {
    final theme = Theme.of(c);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: theme.brightness == Brightness.dark
            ? Colors.white10
            : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: theme.iconTheme.color?.withOpacity(0.9)),
          const SizedBox(width: 8),
          Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
