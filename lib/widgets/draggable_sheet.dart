import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BottomInfoSheet extends StatelessWidget {
  const BottomInfoSheet({
    Key? key,
    required this.children,
    required this.backdrops,
    this.minSize,
  }) : super(key: key);
  final List<Widget> children;
  final String backdrops;
  final double? minSize;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        child: DraggableScrollableSheet(
          initialChildSize: minSize == null ? 0.65 : minSize!,
          minChildSize: minSize == null ? 0.65 : minSize!,
          maxChildSize: 0.88,
          builder: (context, controller) {
            return Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                image: DecorationImage(
                  image: CachedNetworkImageProvider(backdrops),
                  fit: BoxFit.cover,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 50,
                    sigmaY: 100,
                  ),
                  child: ColoredBox(
                    color: Colors.black87.withOpacity(0.7),
                    child: ListView(
                      controller: controller,
                      children: children,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}