import 'dart:ui';
import 'package:flutter/material.dart';

class NoDataWidget extends StatefulWidget {
  final String? message;
  final VoidCallback? onRetry;

  const NoDataWidget({super.key, this.message, this.onRetry});

  @override
  State<NoDataWidget> createState() => _NoDataWidgetState();
}

class _NoDataWidgetState extends State<NoDataWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 900),
      vsync: this,
    );

    _fade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );

    _slide = Tween<Offset>(begin: const Offset(0, 0.15), end: Offset.zero)
        .animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // ============================================================
  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ⭐ ILLUSTRATION CARD
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    padding: const EdgeInsets.all(30),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.withOpacity(0.15),
                          Colors.purple.withOpacity(0.15),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      border:
                      Border.all(color: Colors.white.withOpacity(0.3)),
                    ),
                    child: Column(
                      children: [
                        // ⭐ Animated empty box image
                        Image.network(
                          "https://cdn-icons-png.flaticon.com/512/4076/4076549.png",
                          height: 140,
                          color: Colors.grey.shade700,
                        ),

                        const SizedBox(height: 20),

                        Text(
                          widget.message ?? "Oops! No Data Found",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                            color: Colors.grey.shade800,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Try refreshing the page or check back later.",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 35),

              if (widget.onRetry != null)
                ElevatedButton.icon(
                  onPressed: widget.onRetry,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    backgroundColor: Colors.blueAccent,
                  ),
                  icon: const Icon(Icons.refresh),
                  label: const Text(
                    "Retry",
                    style: TextStyle(fontSize: 16),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
