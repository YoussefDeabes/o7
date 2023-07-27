import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class ReviewsScreen extends StatefulWidget {
  final List<ReviewModel> reviews;
  final double width;

  const ReviewsScreen({Key? key, required this.reviews, required this.width})
      : super(key: key);

  @override
  State<ReviewsScreen> createState() => _ReviewsScreenState();
}

class _ReviewsScreenState extends State<ReviewsScreen> with Translator {
  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _getReviewsList(),
        ]));
  }

  Widget _getReviewsList() {
    return ListView.builder(
        itemCount: widget.reviews.length,
        padding: const EdgeInsets.only(bottom: 13),
        primary: false,
        shrinkWrap: true,
        itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: SizedBox(
                child: Card(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: ConstColors.disabled)),
                    child: Padding(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    translate(LangKeys.session),
                                    style: const TextStyle(
                                        color: ConstColors.text,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  ),
                                  Text(
                                    " " +
                                        DateFormat("d-MM-yyyy").format(
                                            widget.reviews[index].sessionDate),
                                    style: const TextStyle(
                                        color: ConstColors.text,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  )
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SvgPicture.asset(
                                    AssPath.starIcon,
                                    // scale: 1.5,
                                  ),
                                  Text(" " + widget.reviews[index].rate)
                                ],
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text.rich(
                              TextSpan(text: widget.reviews[index].review),
                              style: const TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  fontWeight: FontWeight.w400,
                                  color: ConstColors.text),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                translate(LangKeys.verifiedO7Client),
                                style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w400,
                                    color: ConstColors.text),
                              )
                            ],
                          ),
                        ],
                      ),
                    )))));
  }
}
