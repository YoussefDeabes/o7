import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/models/has_wallet_sessions/List.dart';
import 'package:o7therapy/prefs/pref_manager.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/booking/booking_screen/booking_screen.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/home/home_main_logged_in/home_main_logged_in/home_main_logged_in_screen.dart';
import 'package:o7therapy/ui/screens/sessions_credit/bloc/sessions_credit_bloc.dart';
import 'package:o7therapy/ui/screens/therapist_profile/therapist_profile_screen/therapist_profile_screen.dart';
import 'package:o7therapy/ui/widgets/widgets.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:o7therapy/util/ui/feedback_controller.dart';
import 'package:shimmer/shimmer.dart';

class SessionsWalletCard extends BaseStatefulWidget {
  final HasWalletSessionsList sessionsList;

  const SessionsWalletCard({Key? key, required this.sessionsList})
      : super(key: key);

  @override
  BaseState<SessionsWalletCard> baseCreateState() => _SessionsWalletCardState();
}

class _SessionsWalletCardState extends BaseState<SessionsWalletCard> {
  @override
  Widget baseBuild(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Card(
        margin: EdgeInsets.zero,
        elevation: 0,
        shape: _getCardShape(),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      children: [
                        _dateContainer(),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _therapistDetails(),
                              const SizedBox(height: 10),
                              _sessionDetails()
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  _therapistImageAndTime(),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  // _refundButton(),
                  // const SizedBox(
                  //   width: 20,
                  // ),
                  _bookASessionButton()
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  ShapeBorder _getCardShape() {
    return RoundedRectangleBorder(
        borderRadius: Directionality.of(context).index == 1
            ? const BorderRadius.only(
                bottomLeft: Radius.zero,
                bottomRight: Radius.circular(16),
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16))
            : const BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.zero,
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16)),
        side: const BorderSide(color: ConstColors.disabled));
  }

  Widget _therapistImageAndTime() {
    return Column(
      children: [
        SizedBox(
          height: width / 5,
          width: width / 6,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            child: CachedNetworkImage(
              imageUrl:
                  ApiKeys.baseUrl + widget.sessionsList.therapistImage!.url!,
              fit: BoxFit.fitHeight,
              placeholder: (_, __) => Shimmer.fromColors(
                baseColor: Colors.black12,
                highlightColor: Colors.white,
                child: Container(
                  height: double.infinity,
                  width: 0.27 * width,
                  decoration: const BoxDecoration(color: Colors.black26),
                ),
              ),
              errorWidget: (context, url, error) => const SizedBox(
                  width: 30,
                  height: 30,
                  child: Center(child: Icon(Icons.error))),
            ),
          ),
        ),
        SizedBox(
          height: height / 90,
        ),
      ],
    );
  }

  Widget _refundButton() {
    return ElevatedButton(
      onPressed: () {
        // context.read<ActivityBloc>().add(const CancelActivityEvt());
      },
      style: ButtonStyle(
          elevation: MaterialStateProperty.all(0),
          backgroundColor:
              MaterialStateProperty.all<Color>(ConstColors.appWhite),
          foregroundColor:
              MaterialStateProperty.all<Color>(ConstColors.textSecondary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  side: const BorderSide(color: ConstColors.textSecondary)))),
      child: Text(translate(LangKeys.refund)),
    );
  }

  Widget _bookASessionButton() {
    return SizedBox(
      width: width / 2.5,
      child: ElevatedButton(
        onPressed: () async {
          /// this will navigate the user to Therapist profile

          showLoading();
          SessionsCreditState sessionsCreditState = await context
              .read<SessionsCreditBloc>()
              .getTherapistBio(widget.sessionsList.therapistId ?? "");
          if (sessionsCreditState is BioState) {
            TherapistData therapistData =
                TherapistData.fromBackEndFromTherapistBio(
              sessionsCreditState.bio,
            );
            hideLoading();
            await Navigator.of(context).pushNamed(
              TherapistProfileScreen.routeName,
              arguments: {"therapistModel": therapistData},
            );
          } else if (sessionsCreditState is NetworkError) {
            showToast(sessionsCreditState.message);
          } else if (sessionsCreditState is ErrorState) {
            showToast(sessionsCreditState.message);
          }
        },
        style: ButtonStyle(
            elevation: MaterialStateProperty.all(0),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0),
            ))),
        child: Text(translate(LangKeys.bookASession)),
      ),
    );
  }

  Widget _therapistDetails() {
    return FutureBuilder(
        future: PrefManager.getLang(),
        builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                snapshot.data == 'en'
                    ? widget.sessionsList.therapistName!
                    : widget.sessionsList.therapistNameAr!,
                style: const TextStyle(
                    color: ConstColors.app,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              Wrap(
                children: [
                  SizedBox(
                    width: width * 0.35,
                    child: Text(
                      snapshot.data == 'en'
                          ? widget.sessionsList.therapistProfession!
                          : widget.sessionsList.therapistProfessionAr!,
                      maxLines: 1,
                      style: const TextStyle(
                          overflow: TextOverflow.ellipsis,
                          color: ConstColors.textSecondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                ],
              ),
            ],
          );
        });
  }

  Widget _sessionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LangKeys.fiftyMinutes),
          style: const TextStyle(
              color: ConstColors.app,
              fontSize: 12,
              fontWeight: FontWeight.w600),
        ),
        Text(
          translate(LangKeys.oneOnOneSession),
          style: const TextStyle(
              color: ConstColors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w400),
        ),
      ],
    );
  }

  Widget _dateContainer() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.zero,
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)),
      child: Container(
        height: height / 10,
        width: width / 7,
        color: ConstColors.app.withOpacity(0.10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              widget.sessionsList.patientWallet!.length.toString(),
              style: const TextStyle(
                  color: ConstColors.app,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              translate(LangKeys.credit),
              style: const TextStyle(
                  color: ConstColors.app,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}
