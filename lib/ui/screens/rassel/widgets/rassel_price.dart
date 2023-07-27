import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:shimmer/shimmer.dart';

const Color _tempColor = Color(0xFF656565);

class RasselPrice extends StatelessWidget {
  const RasselPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      child: BlocBuilder<CheckUserDiscountCubit, CheckUserDiscountState>(
        builder: (context, state) {
          if (state is LoadingCheckUserDiscountState) {
            return const _LoadingRasselPriceShimmer();
          }
          bool isEWP = false;
          if (state is LoadedUserDiscountState) {
            isEWP = state.userDiscountData.isCorporate ?? false;
          }

          if (isEWP) {
            return const _EWPRasselPrice();
          } else {
            return const _IndividualRasselPrice();
          }
        },
      ),
    );
  }
}

class _IndividualRasselPrice extends StatelessWidget {
  const _IndividualRasselPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RasselBloc, RasselState>(builder: (context, state) {
      if (RasselBloc.rasselSubscriptionState == null) {
        return const _LoadingRasselPriceShimmer();
      }
      String? originalAmount = RasselBloc
          .rasselSubscriptionState?.rasselSubscription.data?.originalAmount
          ?.toInt()
          .toString();
      String currency = getRasselCurrency(
        context,
        RasselBloc.rasselSubscriptionState!.rasselSubscription.data?.currency ??
            0,
      );

      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            "$originalAmount $currency",
            style: const TextStyle(
                color: ConstColors.app,
                fontSize: 24,
                fontWeight: FontWeight.w500),
          ),
          Text(
            context.translate(LangKeys.perMonth),
            style: const TextStyle(
                color: _tempColor, fontSize: 12, fontWeight: FontWeight.w400),
          ),
        ],
      );
    });
  }
}

class _EWPRasselPrice extends StatelessWidget {
  const _EWPRasselPrice({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          context.translate(LangKeys.monthlySubscription),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 20,
            color: ConstColors.app,
          ),
        ),
        Text(
          context.translate(LangKeys.atExclusiveRatesProvidedByYourEmployer),
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 12,
            color: _tempColor,
          ),
        )
      ],
    );
  }
}

class _LoadingRasselPriceShimmer extends StatelessWidget {
  const _LoadingRasselPriceShimmer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      highlightColor: Colors.black12,
      baseColor: Colors.white,
      child: Container(
        height: 40,
        width: 160,
        decoration: const BoxDecoration(color: Colors.white12),
      ),
    );
  }
}
