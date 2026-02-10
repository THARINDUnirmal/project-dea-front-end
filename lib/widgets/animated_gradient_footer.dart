import 'package:flutter/material.dart';

class AnimatedGradientFooter extends StatefulWidget {
  const AnimatedGradientFooter({super.key});

  @override
  State<AnimatedGradientFooter> createState() => _AnimatedGradientFooterState();
}

class _AnimatedGradientFooterState extends State<AnimatedGradientFooter>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fade;
  late Animation<Offset> slide;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    fade = CurvedAnimation(parent: controller, curve: Curves.easeOut);
    slide = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutCubic));

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final bool isMobile = constraints.maxWidth < 700;
        final bool isTablet =
            constraints.maxWidth >= 700 && constraints.maxWidth < 1100;

        final double horizontalPadding = isMobile
            ? 20
            : isTablet
            ? 40
            : 80;
        final double verticalPadding = isMobile ? 40 : 70;

        return FadeTransition(
          opacity: fade,
          child: SlideTransition(
            position: slide,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                horizontal: horizontalPadding,
                vertical: verticalPadding,
              ),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF020617),
                    Color(0xFF0F172A),
                    Color(0xFF1E1B4B),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // TOP SECTION
                  isMobile
                      ? _MobileFooterTop()
                      : _DesktopFooterTop(isTablet: isTablet),

                  const SizedBox(height: 40),
                  Container(height: 1, color: Colors.white10),
                  const SizedBox(height: 20),

                  // BOTTOM BAR
                  isMobile
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              "© 2026 EventHub. All rights reserved.",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              "Built by Apex",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text(
                              "© 2026 EventHub. All rights reserved.",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              "Built by Apex",
                              style: TextStyle(
                                color: Colors.white38,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _DesktopFooterTop extends StatelessWidget {
  final bool isTablet;
  const _DesktopFooterTop({required this.isTablet});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Brand
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "EventHub",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 14),
              Text(
                "A modern platform to discover, manage and experience events seamlessly.",
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 14,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),

        SizedBox(width: isTablet ? 40 : 100),

        const _FooterColumn(
          title: "Explore",
          items: ["Events", "Categories", "Venues", "Creators"],
        ),
        const _FooterColumn(
          title: "Platform",
          items: ["Create Event", "Tickets", "Dashboard", "Insights"],
        ),
        const _FooterColumn(
          title: "Support",
          items: ["Help Center", "Contact", "Privacy", "Terms"],
        ),
      ],
    );
  }
}

class _MobileFooterTop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          "EventHub",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 12),
        Text(
          "A modern platform to discover, manage and experience events seamlessly.",
          style: TextStyle(color: Colors.white60, fontSize: 14, height: 1.6),
        ),
        SizedBox(height: 30),

        Wrap(
          spacing: 40,
          runSpacing: 30,
          children: [
            _FooterColumn(
              title: "Explore",
              items: ["Events", "Categories", "Venues", "Creators"],
            ),
            _FooterColumn(
              title: "Platform",
              items: ["Create Event", "Tickets", "Dashboard", "Insights"],
            ),
            _FooterColumn(
              title: "Support",
              items: ["Help Center", "Contact", "Privacy", "Terms"],
            ),
          ],
        ),
      ],
    );
  }
}

class _FooterColumn extends StatelessWidget {
  final String title;
  final List<String> items;

  const _FooterColumn({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
        const SizedBox(height: 16),
        ...items.map(
          (item) => Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              item,
              style: const TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }
}
