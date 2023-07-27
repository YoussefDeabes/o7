import 'package:flutter/material.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

const List<String> _therapistsAvatars = [
  AssPath.avatar1,
  AssPath.avatar2,
  AssPath.avatar3,
  AssPath.avatar4,
  AssPath.avatar5,
  AssPath.avatar6,
];

/// Intro Section of booking screen >> get Therapists Info Rectangle
// ignore: must_be_immutable
class IntroSection extends StatelessWidget {
  const IntroSection({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: EdgeInsets.only(top: 0.02 * context.height, left: 24, right: 24),
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.all(Radius.circular(16.0)),
        border: Border.all(color: ConstColors.disabled),
        color: Colors.white,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          RectangleTherapistsTitle(),
          RectangleTherapistsDetails(),
          RectangleTherapistsAvatars(),
        ],
      ),
    );
  }
}

/// get Rectangle Contains all Therapists Avatars
class RectangleTherapistsAvatars extends StatelessWidget {
  const RectangleTherapistsAvatars({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          bottom: context.height * 0.035, top: context.height * 0.02),
      child: Stack(
        alignment: Alignment.centerLeft,
        children: List.generate(
          _therapistsAvatars.length,
          (index) => TherapistAvatar(index),
        ),
      ),
    );
  }
}

/// get the single avatar for each Therapist
class TherapistAvatar extends StatelessWidget {
  const TherapistAvatar(
    this._therapistIndex, {
    super.key,
  });

  final int _therapistIndex;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: _therapistIndex * context.width * 0.08),
      child: Container(
        width: 0.11 * context.width,
        height: 0.11 * context.width,
        decoration: BoxDecoration(
          border: Border.all(
            color: ConstColors.appWhite,
            width: 1.0,
          ),
          shape: BoxShape.circle,
        ),
        child: CircleAvatar(
          radius: 37,
          backgroundImage: AssetImage(_therapistsAvatars[_therapistIndex]),
        ),
      ),
    );
  }
}

/// get Rectangle Therapists Details Text
class RectangleTherapistsDetails extends StatelessWidget {
  const RectangleTherapistsDetails({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: context.height * 0.02),
      child: Text(
        context.translate(LangKeys.rectangleTherapistsDetails),
        textAlign: TextAlign.center,
        style: const TextStyle(
            color: ConstColors.text, fontWeight: FontWeight.w400, fontSize: 14),
      ),
    );
  }
}

/// get the rectangle Therapists Title >>  title is "Highly qualified & Certified therapists."
class RectangleTherapistsTitle extends StatelessWidget {
  const RectangleTherapistsTitle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.width / 1.7,
      padding: EdgeInsets.only(top: context.height * 0.02),
      child: Text.rich(
        TextSpan(
          style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
              color: ConstColors.app),
          children: [
            TextSpan(text: '${context.translate(LangKeys.highly)} '),
            TextSpan(
                text: '${context.translate(LangKeys.qualified)} ',
                style: const TextStyle(color: ConstColors.secondary)),
            TextSpan(text: context.translate(LangKeys.professionals)),
            const TextSpan(
                text: '.', style: TextStyle(color: ConstColors.warning)),
          ],
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
