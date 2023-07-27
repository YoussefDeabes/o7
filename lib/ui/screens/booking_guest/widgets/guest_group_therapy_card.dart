import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:o7therapy/api/models/guest_therapist_list/List.dart';
import 'package:o7therapy/res/assets_path.dart';

import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';

import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/widgets/card_widgets/card_widgets.dart';
import 'package:o7therapy/ui/screens/booking/widgets/play_video_button.dart';
import 'package:o7therapy/ui/screens/booking/widgets/therapist_photo.dart';
import 'package:o7therapy/ui/screens/booking_guest/widgets/guest_play_video_button.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/therapist_profile_screen.dart';
import 'package:shimmer/shimmer.dart';

// the therapist Card
class GuestGroupTherapyCard extends StatelessWidget {
  Function() onPressed;
  GuestGroupTherapyCard({super.key,required this.onPressed});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double width = size.width;
    double height = size.height;
    return SizedBox(
      height: 0.22 * height,
      child: Stack(children: [
        InkWell(
          onTap: onPressed,
          borderRadius: const BorderRadius.all(Radius.circular(16.0)),
          child: Ink(
            height: 0.19 * height,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(16.0)),
              border: Border.all(color: ConstColors.disabled),
              color: Colors.white,
            ),
            child: Row(
              children: [
                _getCardImage(context),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 0.04 * width,
                      vertical: 0.015 * height,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Introduction to art therapy',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: ConstColors.text)),
                        Text(
                          'Introduction to art therapy',
                          style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: ConstColors.text),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        // GuestPlayVideoButton(videoUrl: therapistModel.biographyVideo?.url ?? "")
      ]),
    );
  }

  Widget _getCardImage(BuildContext context) {
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
        imageUrl:
            "https://cdni.iconscout.com/illustration/premium/thumb/group-therapy-3163253-2655839.png",
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

        //errorWidget: (context, url, error) => Image.asset('assets/images/notAvailable.jpg', fit: BoxFit.fill),
        fadeOutDuration: const Duration(milliseconds: 1500),

        /// time takes to show image
        fadeInDuration: const Duration(milliseconds: 100),
        fadeInCurve: Curves.easeInCubic,
        placeholderFadeInDuration: const Duration(milliseconds: 10),
        cacheKey:
            "https://cdni.iconscout.com/illustration/premium/thumb/group-therapy-3163253-2655839.png",
      ),
    );
  }
}
