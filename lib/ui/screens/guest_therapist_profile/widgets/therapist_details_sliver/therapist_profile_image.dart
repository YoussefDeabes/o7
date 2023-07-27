import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:shimmer/shimmer.dart';

class TherapistProfileImage extends StatelessWidget {
  final String imageUrl;
  const TherapistProfileImage({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.all(
        Radius.circular(16),
      ),
      child: SizedBox(
        height: 0.3 * context.width,
        width: 0.3 * context.width,
        child: CachedNetworkImage(
          imageUrl: "${ApiKeys.baseUrl}$imageUrl",
          fit: BoxFit.cover,
          height: 0.3 * context.width,
          width: 0.3 * context.width,
          maxHeightDiskCache: 600,
          maxWidthDiskCache: 300,
          placeholder: (_, __) => Shimmer.fromColors(
            baseColor: Colors.black12,
            highlightColor: Colors.white,
            child: Container(
              height: 0.3 * context.width,
              width: 0.3 * context.width,
              decoration: const BoxDecoration(color: Colors.black26),
            ),
          ),
          errorWidget: (context, url, error) => const SizedBox(
              width: 30, height: 30, child: Center(child: Icon(Icons.error))),
          cacheKey: ApiKeys.baseUrl + imageUrl,
        ),
      ),
    );
  }
}
