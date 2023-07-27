import 'package:flutter/material.dart';
import 'package:o7therapy/ui/widgets/get_started_widget.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Start now button To Sign up or login
class StartNowButton extends StatelessWidget {
  const StartNowButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: context.width / 10),
      child: SizedBox(
        width: context.width,
        height: 45,
        child: ElevatedButton(
          onPressed: () {
            showModalBottomSheet<void>(
              backgroundColor: Colors.white,
              context: context,
              isScrollControlled: true,
              clipBehavior: Clip.antiAlias,
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16.0),
                topRight: Radius.circular(16.0),
              )),
              builder: (BuildContext context) => GetStartedWidget(),
            );
          },
          style: ButtonStyle(
              elevation: MaterialStateProperty.all(0),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              ))),
          child: Text(context.translate(LangKeys.startNow)),
        ),
      ),
    );
  }
}
