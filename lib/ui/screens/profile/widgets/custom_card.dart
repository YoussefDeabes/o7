import 'package:flutter/material.dart';

import '../../../../_base/widgets/base_stateless_widget.dart';
import '../../../../res/const_colors.dart';
import '../../../../util/lang/app_localization_keys.dart';

class CustomCard extends BaseStatelessWidget {
  final List<String> labels;
  final List<String> values;
  CustomCard({Key? key, required this.labels, required this.values})
      : super(key: key);

  @override
  Widget baseBuild(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: ConstColors.disabled)),
      child: Padding(
        padding: const EdgeInsets.only(right: 24, left: 24, top: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
              labels.length,
              (index) => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labels[index],
                        style: const TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 11,
                            color: ConstColors.text),
                        maxLines: 1,
                      ),
                      Text(
                        values[index],
                        textDirection: TextDirection.ltr,
                        style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontStyle: FontStyle.normal,
                            fontSize: 14,
                            color: values[index] ==
                                    translate(LangKeys.noInformation)
                                ? ConstColors.textGrey
                                : ConstColors.text),
                        maxLines: 1,
                      ),
                      SizedBox(
                        height: height / 50,
                      ),
                    ],
                  )),
        ),
      ),
    );
  }
}
