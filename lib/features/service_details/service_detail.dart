// service_detail_rtl.dart
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

/// -----------------
/// Centralized constants & styles
/// -----------------
class AppStyles {
  // spacing
  static const double gapSmall = 8.0;
  static const double gap = 12.0;
  static const double gapLarge = 18.0;
  static const double cardRadius = 12.0;

  // colors (adaptive)
  static Color primary(BuildContext c) => Theme.of(c).colorScheme.primary;
  static Color surfaceBg(BuildContext c) => Theme.of(c).cardColor;
  static Color scrimLight = Colors.white;
  static Color scrimDark = Colors.black;

  // text styles (prefer Roboto loaded in pubspec and theme)
  static TextStyle title(BuildContext c) =>
      Theme.of(c).textTheme.titleLarge!.copyWith(fontWeight: FontWeight.w800);
  static TextStyle subtitle(BuildContext c) =>
      Theme.of(c).textTheme.bodyMedium!.copyWith(
        color: Theme.of(c).textTheme.bodyMedium!.color?.withOpacity(0.9),
      );
  static TextStyle chipLabel(BuildContext c) =>
      Theme.of(c).textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w700);
}

/// -----------------
/// Data Models
/// -----------------
class ServiceOffered {
  final String title;
  final String subtitle;
  final String price;
  ServiceOffered({required this.title, this.subtitle = "", this.price = ""});
}

class ServiceItemData {
  final String id;
  final String name;
  final List<String> photos; // gallery
  final String photo; // single fallback
  final double rating;
  final int reviews;
  final String address;
  final String experience;
  final String timings;
  final bool verified;
  final bool topRated;
  final bool trusted;
  final String responseTime;
  final String phone;
  final String website;
  final List<ServiceOffered> offerings;
  final String description;

  ServiceItemData({
    required this.id,
    required this.name,
    required this.photos,
    required this.photo,
    required this.rating,
    required this.reviews,
    required this.address,
    required this.experience,
    required this.timings,
    this.verified = false,
    this.topRated = false,
    this.trusted = false,
    this.responseTime = "60 mins",
    this.phone = "",
    this.website = "",
    this.offerings = const [],
    this.description = "",
  });
}

/// -----------------
/// Service Detail Page (RTL + Dark/Light ready)
/// -----------------
class ServiceDetailPage extends StatefulWidget {
  final ServiceItemData service;
  const ServiceDetailPage({super.key, required this.service});

  @override
  State<ServiceDetailPage> createState() => _ServiceDetailPageState();
}

class _ServiceDetailPageState extends State<ServiceDetailPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  late final PageController _pageController;
  int _currentGalleryIndex = 0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _pageController = PageController();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  // helpers
  Future<void> _launchPhone(String number) async {
    if (number.isEmpty) {
      _showMsg('Phone not available');
      return;
    }
    final uri = Uri.parse('tel:$number');
    if (await canLaunchUrl(uri)) await launchUrl(uri);
  }

  Future<void> _launchWhatsApp(String number) async {
    if (number.isEmpty) {
      _showMsg('Phone not available');
      return;
    }
    final uri = Uri.parse('https://wa.me/$number');
    if (await canLaunchUrl(uri))
      await launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  void _showMsg(String t) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t)));

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final dir = Directionality.of(context);
    final gallery = (s.photos.isNotEmpty
        ? s.photos
        : (s.photo.isNotEmpty ? [s.photo] : []));
    final images = gallery.isNotEmpty
        ? gallery
        : ['https://via.placeholder.com/1200x800?text=No+Image'];

    // colors that adapt
    final overlayTop = isDark
        ? Colors.black.withOpacity(0.45)
        : Colors.black.withOpacity(0.35);
    final overlayMid = isDark
        ? Colors.black.withOpacity(0.18)
        : Colors.black.withOpacity(0.08);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        bottom: false,
        child: DefaultTabController(
          length: 5,
          child: NestedScrollView(
            headerSliverBuilder: (context, innerScrolled) => [
              SliverAppBar(
                pinned: true,
                expandedHeight: 320,
                elevation: 0,
                backgroundColor: theme.scaffoldBackgroundColor,
                // leading & actions automatically follow textDirection; keep icons white for readability
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Get.back(),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share, color: Colors.white),
                    onPressed: () => _showMsg('Share (demo)'),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.bookmark_border,
                      color: Colors.white,
                    ),
                    onPressed: () => _showMsg('Bookmark (demo)'),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      // gallery
                      PageView.builder(
                        controller: _pageController,
                        itemCount: images.length,
                        onPageChanged: (i) =>
                            setState(() => _currentGalleryIndex = i),
                        itemBuilder: (context, idx) {
                          final url = images[idx];
                          return Image.network(
                            url,
                            fit: BoxFit.cover,
                            loadingBuilder: (c, child, progress) {
                              if (progress == null) return child;
                              return Container(
                                color: Colors.grey.shade200,
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            },
                            errorBuilder: (_, __, ___) => Container(
                              color: Colors.grey.shade200,
                              child: const Center(
                                child: Icon(Icons.broken_image, size: 48),
                              ),
                            ),
                          );
                        },
                      ),

                      // layered gradients for contrast
                      Positioned.fill(
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                overlayTop,
                                overlayMid,
                                Colors.transparent,
                                overlayTop,
                              ],
                              stops: const [0.0, 0.25, 0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // radial vignette
                      Positioned.fill(
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              center: const Alignment(0, -0.3),
                              radius: 1.1,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.12),
                              ],
                              stops: const [0.6, 1.0],
                            ),
                          ),
                        ),
                      ),

                      // frosted glass info panel (directional paddings)
                      PositionedDirectional(
                        start: 14,
                        end: 14,
                        bottom: 12,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                            child: Container(
                              padding: EdgeInsetsDirectional.only(
                                start: 14,
                                end: 14,
                                top: 12,
                                bottom: 12,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.10),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.06),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // title + rating
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          s.name,
                                          style: AppStyles.title(context)
                                              .copyWith(
                                                color: Colors.white,
                                                fontSize: 18,
                                              ),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      _ratingChip(s.rating, s.reviews),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  // tags row (inverted chips)
                                  Row(
                                    children: [
                                      if (s.verified)
                                        _pill(
                                          context,
                                          'Verified',
                                          Icons.verified,
                                          Colors.blue,
                                          inverted: true,
                                        ),
                                      if (s.topRated) ...[
                                        const SizedBox(width: 8),
                                        _pill(
                                          context,
                                          'Top Rated',
                                          Icons.star,
                                          Colors.amber,
                                          inverted: true,
                                        ),
                                      ],
                                      if (s.trusted) ...[
                                        const SizedBox(width: 8),
                                        _pill(
                                          context,
                                          'Trusted',
                                          Icons.thumb_up,
                                          Colors.green,
                                          inverted: true,
                                        ),
                                      ],
                                      const Spacer(),
                                    ],

                                    // _responseChip(s.responseTime),
                                  ),
                                  const SizedBox(height: 10),
                                  // address & timings
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          s.address,
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 12,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        s.timings,
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  // attractive tabbar
                                  _buildAttractiveTabBar(),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // gallery pills
                      PositionedDirectional(
                        bottom: 140,
                        start: 0,
                        end: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(images.length, (i) {
                            final active = i == _currentGalleryIndex;
                            return AnimatedContainer(
                              duration: const Duration(milliseconds: 260),
                              margin: const EdgeInsets.symmetric(horizontal: 4),
                              width: active ? 28 : 8,
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(
                                  active ? 0.95 : 0.5,
                                ),
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: active
                                    ? [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 6,
                                          offset: const Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                            );
                          }),
                        ),
                      ),
                    ],
                  ),
                  collapseMode: CollapseMode.parallax,
                ),
              ),
            ],
            body: Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _overviewTab(s),
                    _servicesTab(s),
                    _reviewsTab(s),
                    _contactTab(s),
                    _infoTab(s),
                  ],
                ),
                PositionedDirectional(
                  start: 0,
                  end: 0,
                  bottom: 0,
                  child: _bottomCTA(s),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Attractive TabBar
  Widget _buildAttractiveTabBar() {
    final tabs = [
      {"t": "Overview", "i": Icons.info_outline},
      {"t": "Services", "i": Icons.list_alt},
      {"t": "Reviews", "i": Icons.reviews},
      {"t": "Contact", "i": Icons.call},
      {"t": "Info", "i": Icons.info},
    ];
    return Container(
      height: 42,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: TabBar(
        controller: _tabController,
        isScrollable: true,
        labelPadding: const EdgeInsets.symmetric(horizontal: 12),
        indicator: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: Colors.white.withOpacity(0.08)),
        ),
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        tabs: tabs
            .map(
              (m) => Tab(
                icon: Icon(m['i'] as IconData, size: 14),
                text: m['t'] as String,
              ),
            )
            .toList(),
      ),
    );
  }

  // --- Tabs (same content but use EdgeInsetsDirectional) ---
  Widget _overviewTab(ServiceItemData s) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 96),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'About',
              style: AppStyles.title(context).copyWith(fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              s.description.isNotEmpty
                  ? s.description
                  : 'Professional, dependable and experienced. We provide timely service with satisfaction guarantee.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                _infoCard(
                  icon: Icons.work_outline,
                  title: 'Experience',
                  subtitle: s.experience,
                ),
                const SizedBox(width: 10),
                _infoCard(
                  icon: Icons.access_time,
                  title: 'Timings',
                  subtitle: s.timings,
                ),
                const SizedBox(width: 10),
                _infoCard(
                  icon: Icons.timer,
                  title: 'Response',
                  subtitle: s.responseTime,
                ),
              ],
            ),
            const SizedBox(height: 18),
            Text('Location', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppStyles.cardRadius),
                color: Colors.grey.shade200,
              ),
              child: const Center(child: Text('Map placeholder')),
            ),
            const SizedBox(height: 18),
            Text('Highlights', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _featureChip(Icons.star, 'Top Rated'),
                _featureChip(Icons.shield, 'Verified'),
                _featureChip(Icons.timer, 'Quick Response'),
                _featureChip(Icons.thumb_up, 'Trusted'),
              ],
            ),
            const SizedBox(height: 36),
          ],
        ),
      ),
    );
  }

  Widget _servicesTab(ServiceItemData s) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 96),
      child: s.offerings.isEmpty
          ? Center(
              child: Text(
                'No services listed',
                style: TextStyle(color: Colors.grey.shade700),
              ),
            )
          : ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: s.offerings.length,
              separatorBuilder: (_, __) => const Divider(height: 1),
              itemBuilder: (context, i) {
                final o = s.offerings[i];
                return ListTile(
                  contentPadding: EdgeInsetsDirectional.zero,
                  title: Text(
                    o.title,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: o.subtitle.isEmpty ? null : Text(o.subtitle),
                  trailing: o.price.isEmpty
                      ? null
                      : Text(
                          o.price,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                );
              },
            ),
    );
  }

  Widget _reviewsTab(ServiceItemData s) {
    final reviews = [
      {
        "name": "Ravi",
        "rating": 5.0,
        "text": "Excellent service, punctual and neat job.",
        "time": "2 days ago",
      },
      {
        "name": "Anita",
        "rating": 4.0,
        "text": "Good but arrived 15 mins late.",
        "time": "1 week ago",
      },
      {
        "name": "Suresh",
        "rating": 5.0,
        "text": "Very professional. Highly recommended.",
        "time": "2 months ago",
      },
    ];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Ratings & Reviews',
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${s.rating.toStringAsFixed(1)} • ${s.reviews} reviews',
                    style: TextStyle(color: Colors.grey.shade700),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showMsg('Write review (demo)'),
                icon: const Icon(Icons.rate_review),
                label: const Text('Write Review'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ExpandedSection(
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: reviews.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, i) {
                final r = reviews[i];
                return _reviewTile(
                  r['name'] as String,
                  r['rating'] as double,
                  r['text'] as String,
                  r['time'] as String,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _contactTab(ServiceItemData s) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 96),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsetsDirectional.zero,
            leading: const Icon(Icons.phone),
            title: Text(s.phone.isNotEmpty ? s.phone : 'Phone not available'),
            trailing: ElevatedButton(
              onPressed: () => _launchPhone(s.phone),
              child: const Text('Call'),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsetsDirectional.zero,
            leading: const Icon(Icons.language),
            title: Text(
              s.website.isNotEmpty ? s.website : 'Website not available',
            ),
            trailing: TextButton(
              onPressed: () => _showMsg('Open website (demo)'),
              child: const Text('Visit'),
            ),
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsetsDirectional.zero,
            leading: const Icon(Icons.location_on),
            title: Text(s.address),
            subtitle: const Text('Tap to open in maps'),
            onTap: () => {},
          ), //_openMaps(s.address)),
          const SizedBox(height: 12),
          Text(
            'Business Hours',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 6),
          Text(s.timings),
        ],
      ),
    );
  }

  Widget _infoTab(ServiceItemData s) {
    final faqs = [
      {
        'q': 'Do you provide on-site service?',
        'a': 'Yes, we provide on-site service across the city.',
      },
      {
        'q': 'What are your payment modes?',
        'a': 'Cash, card and popular wallets accepted.',
      },
      {
        'q': 'Do you offer warranty?',
        'a': 'Yes — 30 days warranty on services as applicable.',
      },
    ];

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(16, 18, 16, 96),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Details', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(
              s.description.isNotEmpty
                  ? s.description
                  : 'Full business details and policies appear here.',
            ),
            const SizedBox(height: 16),
            Text('FAQs', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            ...faqs.map(
              (f) => ExpansionTile(
                title: Text(f['q']!),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Text(f['a']!),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  // bottom CTA
  Widget _bottomCTA(ServiceItemData s) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 14, 12),
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: () => _launchPhone(s.phone),
                  icon: const Icon(Icons.call, size: 18),
                  label: const Text('Call Now'),
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 52,
                child: OutlinedButton.icon(
                  onPressed: () => _showMsg('Send Enquiry (demo)'),
                  icon: const Icon(Icons.mail_outline, size: 18),
                  label: const Text('Send Enquiry'),
                  style: OutlinedButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 10),
            SizedBox(
              height: 52,
              width: 52,
              child: ElevatedButton(
                onPressed: () => _launchWhatsApp(s.phone),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade700,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Icon(Icons.phone, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // small widgets (use theme / direction safe)
  Widget _pill(
    BuildContext c,
    String text,
    IconData icon,
    Color color, {
    bool inverted = false,
  }) {
    if (inverted) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.06),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 12, color: Colors.white),
            const SizedBox(width: 6),
            Text(
              text,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _ratingChip(double rating, int reviews) {
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
            '($reviews)',
            style: const TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _responseChip(String txt) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer, size: 14, color: Colors.orange),
          const SizedBox(width: 6),
          Text(
            txt,
            style: const TextStyle(
              color: Colors.orange,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard({
    required IconData icon,
    required String title,
    required String subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(AppStyles.cardRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: Colors.grey.shade800),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      ),
    );
  }

  Widget _featureChip(IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14, color: Colors.grey.shade700),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(
              color: Colors.grey.shade700,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _reviewTile(String name, double rating, String text, String time) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: Colors.grey.shade300,
          child: Text(
            name[0].toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    name,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(width: 8),
                  _ratingChip(rating, 0),
                ],
              ),
              const SizedBox(height: 6),
              Text(text),
              const SizedBox(height: 6),
              Text(
                time,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Helper to embed scrollable child
class ExpandedSection extends StatelessWidget {
  final Widget child;
  const ExpandedSection({super.key, required this.child});
  @override
  Widget build(BuildContext context) =>
      ConstrainedBox(constraints: BoxConstraints(), child: child);
}
