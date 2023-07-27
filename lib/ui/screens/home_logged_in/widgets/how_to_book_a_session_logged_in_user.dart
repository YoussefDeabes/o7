import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/header_text_widget.dart';
import 'package:o7therapy/ui/screens/home_guest/widgets/how_it_works_widget.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class HowToBookASessionLoggedInUser extends StatefulWidget {
  static const ValueKey _key = ValueKey("HowToBookASessionLoggedInUser");
  const HowToBookASessionLoggedInUser() : super(key: _key);

  @override
  State<HowToBookASessionLoggedInUser> createState() =>
      _HowToBookASessionLoggedInUserState();
}

class _HowToBookASessionLoggedInUserState
    extends State<HowToBookASessionLoggedInUser>
    with AutomaticKeepAliveClientMixin {
  static final Image arAssetImage = Image.asset(
    AssPath.howItWorksAr,
    key: const ValueKey(AssPath.howItWorksAr),
    fit: BoxFit.fitWidth,
    scale: 2.35,
    cacheWidth: 1146,
    cacheHeight: 2693,
  );

  static final Image enAssetImage = Image.asset(
    AssPath.howItWorks,
    key: const ValueKey(AssPath.howItWorks),
    fit: BoxFit.fitWidth,
    scale: 2.35,
    cacheWidth: 1146,
    cacheHeight: 2693,
  );

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (AppLocalizations.of(context).locale.languageCode == 'ar') {
      await precacheImage(
        arAssetImage.image,
        context,
        size: Size(context.width, context.width * 2.36),
      );
    } else {
      await precacheImage(
        enAssetImage.image,
        context,
        size: Size(context.width, context.width * 2.36),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        HeaderWidget(
          text: context.translate(LangKeys.howItWorks),
          fontWeight: FontWeight.w700,
          fontSize: 18,
        ),
        const SizedBox(height: 16),
        HowItWorks(assetImage: _getAssetImage()),
      ],
    );
    // return BlocBuilder<CheckUserDiscountCubit, CheckUserDiscountState>(
    //   builder: (context, state) {
    //     if (state is LoadedUserDiscountState &&
    //         state.userDiscountData.isOldClient == false) {
    //       return Column(
    //         mainAxisSize: MainAxisSize.min,
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         children: [
    //           HeaderWidget(text: context.translate(LangKeys.howItWorks)),
    //           const HowItWorks(),
    //         ],
    //       );
    //     }
    //     return const SizedBox.shrink();
    //   },
    // );
  }

  @override
  bool get wantKeepAlive => true;

  Image _getAssetImage() {
    if (AppLocalizations.of(context).locale.languageCode == 'ar') {
      return arAssetImage;
    } else {
      return enAssetImage;
    }
  }
}
