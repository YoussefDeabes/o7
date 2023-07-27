import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:shimmer/shimmer.dart';

/// get the therapist personal photo and cached it in the network
class TherapistPhoto extends StatelessWidget {
  final String imageUrl;
  final double? width;
  const TherapistPhoto({
    super.key,
    required this.imageUrl,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      key: key,
      borderRadius: BorderRadius.only(
        bottomLeft: Directionality.of(context) == TextDirection.ltr
            ? const Radius.circular(16.0)
            : const Radius.circular(34.0),
        bottomRight: Directionality.of(context) == TextDirection.rtl
            ? const Radius.circular(16.0)
            : const Radius.circular(34.0),
        topLeft: const Radius.circular(16.0),
        topRight: const Radius.circular(16.0),
      ),
      child: CachedNetworkImage(
        key: key,
        width: 0.27 * MediaQuery.of(context).size.width,
        height: double.infinity,
        imageUrl: ApiKeys.baseUrl + imageUrl,
        maxHeightDiskCache: 1000,
        maxWidthDiskCache: 500,
        fit: BoxFit.cover,
        placeholder: (_, __) => Shimmer.fromColors(
          baseColor: Colors.black12,
          highlightColor: Colors.white,
          child: Container(
            height: double.infinity,
            width: 0.27 * MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(color: Colors.black26),
          ),
        ),
        errorWidget: (context, url, error) => const SizedBox(
            width: 30, height: 30, child: Center(child: Icon(Icons.error))),
        cacheKey: ApiKeys.baseUrl + imageUrl,
      ),
    );
  }
}
