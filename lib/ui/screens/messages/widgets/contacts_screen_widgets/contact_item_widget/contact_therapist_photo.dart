import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:shimmer/shimmer.dart';

class ContactTherapistPhoto extends StatelessWidget {
  final String imageUrl;
  const ContactTherapistPhoto({
    Key? key,
    required this.width,
    required this.imageUrl,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(8.0),
      child: CachedNetworkImage(
        key: key,
        imageUrl: ApiKeys.baseUrl + imageUrl,
        cacheKey: ApiKeys.baseUrl + imageUrl,
        maxHeightDiskCache: 500,
        maxWidthDiskCache: 500,
        width: 0.12 * width,
        height: 0.13 * width,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white,
          child: Container(
            width: 0.12 * width,
            height: 0.13 * width,
            decoration: const BoxDecoration(color: Colors.black26),
          ),
        ),
        errorWidget: (context, url, error) => SizedBox(
          width: 0.12 * width,
          height: 0.13 * width,
        ),

        fadeOutDuration: const Duration(milliseconds: 1500),

        /// time takes to show image
        fadeInDuration: const Duration(milliseconds: 100),
        fadeInCurve: Curves.easeInCubic,
        placeholderFadeInDuration: const Duration(milliseconds: 10),
      ),
    );
  }
}
