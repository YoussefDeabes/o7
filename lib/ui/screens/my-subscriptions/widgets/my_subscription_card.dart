import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/api/models/rassel_client_subscriptions_with_resubscribe/Data.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/my-subscriptions/widgets/cancel_subscription.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_checkout_screen.dart';
import 'package:o7therapy/ui/screens/rassel/screens/rassel_payment_screen.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/general.dart';
import 'package:o7therapy/util/lang/app_localization.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

class MySubscriptionsCard extends StatefulWidget {
  Data subscriptions;

  MySubscriptionsCard({Key? key, required this.subscriptions})
      : super(key: key);

  @override
  State<MySubscriptionsCard> createState() => _MySubscriptionsCardState();
}

class _MySubscriptionsCardState extends State<MySubscriptionsCard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    translate = AppLocalizations.of(context).translate;
    height = MediaQuery.of(context).size.height;
    super.didChangeDependencies();
  }

  late final String Function(String key) translate;
  late final double height;
  bool? isUserActiveSubscription;
  int? status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(left: 16, right: 16, top: 16, bottom: 24),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          color: Colors.white,
          border: widget.subscriptions.status == 1
              ? Border.all(color: ConstColors.error)
              : Border.all(color: ConstColors.disabled),
          borderRadius: const BorderRadius.all(Radius.circular(16))),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${translate(LangKeys.o7)} ${translate(LangKeys.rassel)}",
                    style: const TextStyle(
                        fontSize: 14.0,
                        fontWeight: FontWeight.w500,
                        color: ConstColors.app),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    translate(LangKeys.monthlyPremium),
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w400,
                        color: ConstColors.text),
                  ),
                ],
              ),
              SvgPicture.asset(
                AssPath.rasselBanner,
                height: context.width * 0.15,
                width: context.width * 0.15,
              ),
            ],
          ),
          const SizedBox(
            height: 10,
          ),

          Text(
            getFeeOrNextPaymentText(widget.subscriptions.isActive!),
            style: const TextStyle(
                fontSize: 12.0,
                fontWeight: FontWeight.w500,
                color: ConstColors.text),
          ),
          widget.subscriptions.status == 1
              ? const SizedBox(
                  height: 8,
                )
              : SizedBox(),
          widget.subscriptions.status == 1
              ? Text(translate(LangKeys.renewailFailErrorMsg),
                  style: TextStyle(color: ConstColors.error))
              : SizedBox(),
          // const SizedBox(
          //   height: 10,
          // ),
          // Text(
          //   "${translate(LangKeys.paymentCard)}: ****34",
          //   textAlign: TextAlign.start,
          //   style: TextStyle(
          //       fontSize: 12.0,
          //       fontWeight: FontWeight.w400,
          //       color: ConstColors.textDisabled),
          // ),
          widget.subscriptions.isActive == true
              ? InkWell(
                  onTap: () {
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
                      builder: (BuildContext context) => SizedBox(
                          height: height * 0.23,
                          child: CancelSubscriptionWidget(
                            nextPaymentDate:
                                widget.subscriptions.nextPaymentDate!,
                            currency: widget.subscriptions.currency!,
                            id: widget.subscriptions.id!.toString(),
                            paidFees: widget.subscriptions.paidFees!,
                          )),
                    );
                  },
                  child: Text(
                    translate(LangKeys.cancelSubscription),
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                        fontSize: 12.0,
                        fontWeight: FontWeight.w500,
                        color: ConstColors.error,
                        decoration: TextDecoration.underline),
                  ))
              : (widget.subscriptions.isActive == false &&
                      DateTime.parse(widget.subscriptions.nextPaymentDate!)
                          .isAfter(DateTime.now()) &&
                      widget.subscriptions.status == 3)
                  ? Text(
                      translate(LangKeys.canceled),
                      style: const TextStyle(color: ConstColors.textSecondary),
                    )
                  : (widget.subscriptions.status == 3
                      ? Center(
                          child: ElevatedButton(
                              onPressed: () {
                                log(widget.subscriptions.id.toString());
                                Navigator.of(context).pushNamed(
                                    RasselCheckoutScreen.routeName,
                                    arguments: {
                                      "fromReSubscribe": true,
                                    }).then(_onGoBack);
                              },
                              style: ButtonStyle(
                                  elevation: MaterialStateProperty.all(0),
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30.0),
                                  ))),
                              child: Text(translate(LangKeys.reSubscribe))),
                        )
                      : widget.subscriptions.status == 1
                          ? Center(
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(
                                        context, RasselPaymentScreen.routeName,
                                        arguments: {
                                          "originalRasselAmount": widget
                                                  .subscriptions
                                                  .nextPaymentAmount ??
                                              0,
                                          "amount": widget
                                              .subscriptions.nextPaymentAmount,
                                          "currency": _getCurrencyNum(
                                              widget.subscriptions.currency!),
                                          "id": widget
                                              .subscriptions.subscriptionId,
                                          "fromReSubscribe": true
                                        });
                                  },
                                  style: ButtonStyle(
                                      elevation: MaterialStateProperty.all(0),
                                      shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(30.0),
                                      ))),
                                  child:
                                      Text(translate(LangKeys.updatePayment))),
                            )
                          : const SizedBox()),
        ],
      ),
    );
  }

  FutureOr _onGoBack(dynamic value) {
    context.read<RasselBloc>().add(RasselClientSubscriptionsEvt());
  }

  String getFeeOrNextPaymentText(bool isActive) {
    if (isActive &&
        widget.subscriptions.status != 3 &&
        widget.subscriptions.corporateId != null) {
      return ("${translate(LangKeys.nextPayment)}: 0 ${_getCurrency(widget.subscriptions.currency)} "
          "${translate(LangKeys.onDate)} ${DateFormat('dd MMM y').format(DateTime.parse(widget.subscriptions.nextPaymentDate!))}");
    } else if (isActive && widget.subscriptions.status != 3) {
      return ("${translate(LangKeys.nextPayment)}: ${widget.subscriptions.nextPaymentAmount!.toInt()} ${_getCurrency(widget.subscriptions.currency)} "
          "${translate(LangKeys.onDate)} ${DateFormat('dd MMM y').format(DateTime.parse(widget.subscriptions.nextPaymentDate!))}");
    } else if (isActive == false &&
        DateTime.parse(widget.subscriptions.nextPaymentDate!)
            .isAfter(DateTime.now()) &&
        widget.subscriptions.status! == 3) {
      return "${translate(LangKeys.validUntil)}: ${DateFormat('dd MMM y').format(DateTime.parse(widget.subscriptions.nextPaymentDate!))} ";
    } else {
      return "${translate(LangKeys.subscriptionFee)}: ${widget.subscriptions.corporateId != null ? "0" : widget.subscriptions.nextPaymentAmount!.toInt()} ${_getCurrency(widget.subscriptions.currency)} ";
    }
  }

  num _getCurrencyNum(String currency) {
    switch (currency) {
      case 'EGP':
        return 1;
      case 'USD':
        return 2;
      case 'KWD':
        return 5;
      default:
        return 1;
    }
  }

  String _getCurrency(String? currency) {
    return getCurrencyNameByContext(context, currency);
  }
}
