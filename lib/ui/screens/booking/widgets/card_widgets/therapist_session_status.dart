import 'package:flutter/material.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/check_user_discount_cubit/check_user_discount_cubit.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class TherapistSessionStatus extends StatelessWidget {
  final bool? flatRate;
  final double? feesPerSession;
  final String? currency;
  final ClientStatus? clientStatus;

  const TherapistSessionStatus({
    super.key,
    required this.flatRate,
    required this.feesPerSession,
    required this.currency,
    required this.clientStatus,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Align(
        alignment: AlignmentDirectional.centerStart,
        child:Text(
          getStatusString(context),
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: ConstColors.app,
          ),
        )
        // CheckUserDiscountCubit.userDiscountData?.discount != null &&
        //         CheckUserDiscountCubit.userDiscountData?.discount != 0.0 &&
        //         flatRate != true
        //     ? Wrap(
        //         children: [
        //           Text(
        //             "${(feesPerSession!.toInt() - CheckUserDiscountCubit.userDiscountData!.discount!.toInt())}\t$currency\t",
        //             textAlign: TextAlign.start,
        //             style: const TextStyle(
        //               fontWeight: FontWeight.w500,
        //               fontSize: 13,
        //               color: ConstColors.app,
        //             ),
        //           ),
        //           Text(
        //             "${feesPerSession?.toInt()}\t$currency\t",
        //             textAlign: TextAlign.start,
        //             style: const TextStyle(
        //               decoration: TextDecoration.lineThrough,
        //               fontWeight: FontWeight.w500,
        //               fontSize: 13,
        //               color: ConstColors.app,
        //             ),
        //           )
        //         ],
        //       )
        //     : Text(
        //         getStatusString(context),
        //         textAlign: TextAlign.start,
        //         style: const TextStyle(
        //           fontWeight: FontWeight.w500,
        //           fontSize: 13,
        //           color: ConstColors.app,
        //         ),
        //       ),
      ),
    );
  }

  String getStatusString(BuildContext context) {
    // flat rate is false then >> user is not have insurance or ewp >> and show the price
    // if true I need to check if the user is ewp or insurance again to handle the status
    if (flatRate == null || flatRate == false) {
      return _getPricePerSession();
    } else {
      final String Function(String) translate =
          AppLocalizations.of(context).translate;
      if (clientStatus == ClientStatus.ewpClient) {
        return translate(LangKeys.coveredByEWP);
      } else {
        return translate(LangKeys.coveredByInsurance);
      }
      // return _translateFunction(LangKeys.coveredByInsurance);
      // return _translateFunction(LangKeys.coveredByEWP);
      //! will remove next line
      // return _getPricePerSession();
    }
  }

  String _getPricePerSession() {
    final String price = feesPerSession!.toInt().toString();
    final String cr = currency ?? "";

    return "$price $cr";
  }
}
