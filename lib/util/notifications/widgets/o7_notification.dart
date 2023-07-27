import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:overlay_support/overlay_support.dart';

class O7Notification extends StatelessWidget {
  final String? title;
  final String? body;
  final Map<dynamic, dynamic>? data;

  const O7Notification({super.key, this.title, this.body, this.data});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Dismissible(
      key: key!,
      onDismissed: (direction) {
        OverlaySupportEntry.of(context)!.dismiss(animate: false);
      },
      child: Card(
        color: Colors.transparent,
        elevation: 10,
        shadowColor: ConstColors.disabled,
        margin: const EdgeInsets.all(7),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: ConstColors.appWhite,
          ),
          child: ListTile(
            leading: SizedBox(
              width: 25,
              height: 25,
              child: Image.asset(
                AssPath.appLogo,
                color: ConstColors.app,
              ),
            ),
            onTap: () {
              OverlaySupportEntry.of(context)!.dismiss();
            },
            title: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              padding: const EdgeInsets.only(top: 5),
              width: MediaQuery.of(context).size.width * .8,
              height: MediaQuery.of(context).size.height / 25,
              child: Text(title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16,
                      color: ConstColors.app,
                      fontWeight: FontWeight.w500)),
            ),
            subtitle: Container(
              margin: const EdgeInsets.symmetric(vertical: 5),
              child: Text(body ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: ConstColors.text,
                  )),
            ),
          ),
        ),
      ),
    ));
  }
}
