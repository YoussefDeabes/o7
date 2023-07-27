import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

const List<String> reviews = [
  LangKeys.review1,
  LangKeys.review2,
  LangKeys.review3,
  LangKeys.review4,
];

class ReviewsCardWidget extends StatelessWidget {
  const ReviewsCardWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: HeaderWidget(
            text: context.translate(LangKeys.testimonials),
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: context.height / 5,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            primary: false,
            itemCount: reviews.length,
            itemBuilder: (ctx, index) => SizedBox(
              width: context.width * 0.80,
              child: Card(
                elevation: 0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.zero,
                        bottomRight: Radius.circular(16),
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16)),
                    side: BorderSide(color: ConstColors.disabled)),
                child: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        '"${context.translate(reviews[index])}"',
                        style: const TextStyle(
                            fontWeight: FontWeight.w300,
                            fontStyle: FontStyle.italic,
                            fontSize: 14,
                            color: ConstColors.text),
                        maxLines: 4,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            context.translate(LangKeys.verifiedO7Client),
                            style: const TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 11,
                                color: ConstColors.text),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
