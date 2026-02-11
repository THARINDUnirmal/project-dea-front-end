import 'dart:ui';

import 'package:flutter/material.dart';

class GlassText extends StatelessWidget {
  final Widget textWidget;
  final double cardWidth;
  const GlassText({
    super.key,
    required this.textWidget,
    required this.cardWidth,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadiusGeometry.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 40, sigmaY: 40),
        child: Container(
          padding: EdgeInsets.all(10),
          width: MediaQuery.of(context).size.width * cardWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: Colors.white.withOpacity(0.04),
          ),
          child: Center(child: textWidget),
        ),
      ),
    );
  }
}
