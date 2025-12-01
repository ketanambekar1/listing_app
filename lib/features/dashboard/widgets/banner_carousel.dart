import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';

class BannerCarousel extends StatelessWidget {
  final List<BannerItem> banners; // <-- custom model with image + text
  final double height;
  final Duration autoScrollDelay;

  const BannerCarousel({
    super.key,
    required this.banners,
    this.height = 200,
    this.autoScrollDelay = const Duration(seconds: 3),
  });

  @override
  Widget build(BuildContext context) {
    return _AutoScrollPageView(
      banners: banners,
      height: height,
      autoScrollDelay: autoScrollDelay,
    );
  }
}

/// Model to hold banner data
class BannerItem {
  final String imageUrl;
  final String title;
  final String subtitle;

  BannerItem({
    required this.imageUrl,
    required this.title,
    this.subtitle = "",
  });
}

/// Internal widget that handles auto-scroll
class _AutoScrollPageView extends StatefulWidget {
  final List<BannerItem> banners;
  final double height;
  final Duration autoScrollDelay;

  const _AutoScrollPageView({
    required this.banners,
    required this.height,
    required this.autoScrollDelay,
  });

  @override
  State<_AutoScrollPageView> createState() => _AutoScrollPageViewState();
}

class _AutoScrollPageViewState extends State<_AutoScrollPageView> {
  late final PageController _pageController;
  Timer? _timer;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(viewportFraction: 0.9);

    _timer = Timer.periodic(widget.autoScrollDelay, (_) {
      if (_pageController.hasClients) {
        _currentIndex = (_currentIndex + 1) % widget.banners.length;
        _pageController.animateToPage(
          _currentIndex,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
         Padding(
          padding: EdgeInsets.only(left: 16, bottom: 12),
          child: Text(
            "topService".tr,
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            itemCount: widget.banners.length,
            itemBuilder: (_, i) {
              final banner = widget.banners[i];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // background image
                      Image.network(
                        banner.imageUrl,
                        fit: BoxFit.cover,
                      ),
                      // gradient for readability
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Colors.black.withOpacity(0.6),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                      // text overlay
                      Positioned(
                        left: 16,
                        bottom: 16,
                        right: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              banner.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (banner.subtitle.isNotEmpty)
                              Text(
                                banner.subtitle,
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13,
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
