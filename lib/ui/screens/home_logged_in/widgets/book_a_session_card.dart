import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class BookASessionCard extends StatelessWidget {
  final void Function()? onPressed;
  final String Function(String key) translate;
  const BookASessionCard({
    super.key,
    required this.translate,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CheckUserDiscountCubit, CheckUserDiscountState>(
      builder: (context, state) {
        if (state is LoadedUserDiscountState &&
            state.userDiscountData.isOldClient == false) {
          return Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Stack(
                children: [
                  Image.asset(
                    AssPath.getStartedCardBg,
                    matchTextDirection: true,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 22,
                      vertical: 30,
                    ),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _TwoColoredWidget(translate: translate),
                          _CardDescriptionText(translate: translate),
                          _GetStartedButton(
                            onPressed: onPressed,
                            translate: translate,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }
}

class _TwoColoredWidget extends StatelessWidget {
  final String Function(String key) translate;
  const _TwoColoredWidget({
    Key? key,
    required this.translate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(text: '${translate(LangKeys.wellnessBeginsWithYour)} '),
          TextSpan(
            text: '${translate(LangKeys.mentalHealth)} ',
            style: const TextStyle(color: ConstColors.secondary),
          ),
          // TextSpan(text: translate(LangKeys.wellBeingStart)),
          const TextSpan(
              text: '.', style: TextStyle(color: ConstColors.accentColor)),
        ],
      ),
      style: const TextStyle(
          fontSize: 18, fontWeight: FontWeight.w700, color: ConstColors.app),
    );
  }
}

class _CardDescriptionText extends StatelessWidget {
  final String Function(String key) translate;
  const _CardDescriptionText({super.key, required this.translate});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 50.0,
      ),
      child: Text(
        translate(LangKeys.wellBeingStartDesc),
        style: const TextStyle(
            fontWeight: FontWeight.w400, fontSize: 14, color: ConstColors.text),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  final void Function()? onPressed;
  final String Function(String key) translate;
  const _GetStartedButton({
    super.key,
    required this.onPressed,
    required this.translate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).size.height / 50,
      ),
      child: SizedBox(
        width: double.infinity,
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ))),
          child: Text(translate(LangKeys.bookASession)),
        ),
      ),
    );
  }
}
