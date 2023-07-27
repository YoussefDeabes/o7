import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/translator.dart';
import 'package:o7therapy/dummy_data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class BlogsScreen extends StatefulWidget {
  final List<BlogsModel> blogs;
  final double width;

  const BlogsScreen({Key? key, required this.blogs, required this.width})
      : super(key: key);

  @override
  State<BlogsScreen> createState() => _BlogsScreenState();
}

class _BlogsScreenState extends State<BlogsScreen> with Translator {
  @override
  Widget build(BuildContext context) {
    initTranslator(context);
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _getBlogsList(),
        ]));
  }

  //Get blogs list
  Widget _getBlogsList() {
    return ListView.builder(
      padding: const EdgeInsets.only(bottom: 13),
      primary: false,
      shrinkWrap: true,
      itemCount: widget.blogs.length,
      itemBuilder: (context, index) => _getSingleBlogItem(index),
    );
  }

  //Get single blog item
  Widget _getSingleBlogItem(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: InkWell(
        onTap: () {},
        child: Card(
            elevation: 0,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.zero,
                    bottomRight: Radius.circular(16),
                    topLeft: Radius.circular(16),
                    topRight: Radius.circular(16)),
                side: BorderSide(color: ConstColors.disabled)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(16),
                      topRight: Radius.circular(16),
                      bottomRight: Radius.circular(42)),
                  child: Image.asset(
                    AssPath.discoverImg,
                    scale: 2,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: widget.width / 25),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.blogs[index].title,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: ConstColors.text,
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            translate(LangKeys.published) + " ",
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: ConstColors.textDisabled),
                          ),
                          Text(
                            DateFormat("d-MM-yyyy")
                                .format(widget.blogs[index].publishedDate),
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w400,
                              color: ConstColors.textDisabled,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SvgPicture.asset(
                                AssPath.timerIcon,
                                // scale: 3.5,
                              ),
                              const SizedBox(
                                width: 6,
                              ),
                              Text(
                                widget.blogs[index].duration +
                                    " " +
                                    translate(LangKeys.minRead),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w400,
                                  color: ConstColors.text,
                                ),
                              ),
                            ],
                          ),
                          // Image.asset(
                          //   AssPath.bookmarkIcon,
                          //   scale: 2,
                          // )
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
