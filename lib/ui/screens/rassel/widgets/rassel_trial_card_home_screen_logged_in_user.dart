import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/rassel_card_bloc/rassel_card_bloc.dart';
import 'package:o7therapy/ui/screens/rassel/bloc/rassel_bloc/rassel_bloc.dart'
    as rassel;
import 'package:o7therapy/ui/screens/rassel/widgets/rassel-trial-card-homescreen-loggedin-user-card.dart';

class RasselTrialCardHomeScreenLoggedInUser extends StatefulWidget {
  const RasselTrialCardHomeScreenLoggedInUser({super.key});

  @override
  State<RasselTrialCardHomeScreenLoggedInUser> createState() =>
      _RasselTrialCardHomeScreenLoggedInUserState();
}

class _RasselTrialCardHomeScreenLoggedInUserState
    extends State<RasselTrialCardHomeScreenLoggedInUser> {
  bool? hasActiveSubscription;
  bool? isSubscribedBefore;
  String? expirationDate;
  int? subscriptionStatus;
  bool? userCanceledSubscription;
  double originalRasselAmount=0.0;
  num currency=0;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RasselCardBloc, RasselCardState>(
      builder: (context, state) {
        if (state is DismissedRasselCardState) {
          return const SizedBox.shrink();
        }

        return BlocConsumer<rassel.RasselBloc, rassel.RasselState>(
          listener: (context, state) {
            if (state is rassel.RasselSubscriptionState) {
              setState(() {
                expirationDate = state.rasselSubscription.data?.expirationDate;
                subscriptionStatus =
                    state.rasselSubscription.data?.subscriptionStatus;
                // user canceled subscription will return 3 from backend
                userCanceledSubscription =
                    subscriptionStatus == 3 ? true : false;
                hasActiveSubscription =
                    state.rasselSubscription.data?.hasActiveSubscription;
                isSubscribedBefore =
                    state.rasselSubscription.data?.isSupscripedBefore;
              });
            }
          },
          builder: (context, state) {
            if (state is rassel.RasselSubscribedState) {
              return const SizedBox.shrink();
            } else if (state is rassel.RasselNotSubscribedState) {
              /// this Condition will appear only if user
              /// user: NotSubscribedState && Renewal Fail
              if (hasActiveSubscription != null &&
                  isSubscribedBefore != null &&
                  userCanceledSubscription != null &&
                  !hasActiveSubscription! &&
                  isSubscribedBefore! &&
                  !userCanceledSubscription!) {
                return const SizedBox.shrink();
              }

              return  RasselTrialCardHomeScreenLoggedInUserCard(originalRasselAmount:originalRasselAmount,currency:currency);
            } else if (state is rassel.RasselClientSubscriptionState) {
              context.read<rassel.RasselBloc>().add(rassel.RasselInitialEvt());
              return const SizedBox.shrink();
            } else if (state is rassel.RasselSubscriptionState) {
              /// add this event here not in listener
              /// because in the listener sometimes not listen
              /// Fix Home Page load without Rassel Card
              if (state.rasselSubscription.data != null) {
               originalRasselAmount= state.rasselSubscription.data!.originalAmount!;
               currency= state.rasselSubscription.data!.currency!;
                context.read<rassel.RasselBloc>().add(
                    rassel.RasselIsSubscribedEvt(
                        subscriptionId:
                            state.rasselSubscription.data!.id.toString(),
                        amount: state.rasselSubscription.data!.amount!,
                        currency: state.rasselSubscription.data!.currency!));
              }else{
                context.read<rassel.RasselBloc>().add(rassel.RasselInitialEvt());
              }
              return const SizedBox.shrink();
            } else {
              return const SizedBox.shrink();
            }
          },
        );
      },
    );
  }
}

