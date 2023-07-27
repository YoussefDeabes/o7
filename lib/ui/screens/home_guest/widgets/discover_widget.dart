import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:o7therapy/_base/widgets/base_stateless_widget.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';

class DiscoverWidget extends BaseStatelessWidget {
  final List<String> titles;
  final List<String> date;
  final List<String> readTime;

  DiscoverWidget(
      {Key? key,
      required this.titles,
      required this.date,
      required this.readTime})
      : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return SizedBox(
      height: height / 8,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        primary: false,
        itemCount: titles.length,
        itemBuilder: (ctx, index) => SizedBox(
          width: width * 0.86,
          child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: Directionality.of(context) == TextDirection.ltr
                      ? const BorderRadius.only(
                          bottomLeft: Radius.zero,
                          bottomRight: Radius.circular(16),
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16))
                      : const BorderRadius.only(
                          bottomLeft: Radius.circular(16),
                          bottomRight: Radius.zero,
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                  side: const BorderSide(color: ConstColors.disabled)),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius:
                        Directionality.of(context) == TextDirection.ltr
                            ? const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(42))
                            : const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomLeft: Radius.circular(42)),
                    child: Image.asset(AssPath.discoverImg),
                  ),
                  Padding(
                    padding:
                        EdgeInsets.only(left: width / 25, right: width / 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          width: width / 2.4,
                          child: Text(
                            titles[index],
                            softWrap: true,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: ConstColors.text,
                            ),
                          ),
                        ),
                        Text(
                          date[index],
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: ConstColors.textDisabled,
                          ),
                        ),
                        Row(
                          children: [
                            SvgPicture.asset(
                              AssPath.timerIcon,
                              // scale: 3,
                            ),
                            const SizedBox(
                              width: 6,
                            ),
                            Text(
                              readTime[index],
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: ConstColors.text,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              )),
        ),
      ),
    );
  }
}
