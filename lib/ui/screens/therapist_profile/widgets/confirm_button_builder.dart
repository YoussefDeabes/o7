import 'package:adjust_sdk/adjust.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:o7therapy/api/adjust_manager.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/bloc/mixpanel_booking_bloc/mixpanel_booking_bloc.dart';
import 'package:o7therapy/ui/screens/booking/models/therapist_data.dart';
import 'package:o7therapy/ui/screens/therapist_profile/bloc/therapist_profile_bloc.dart';
import 'package:o7therapy/util/extensions/extensions.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';

/// Build confirm booking button
/// will return on of these buttons
/// (next || requestASession || joinWaitList || notAvailable)
class ConfirmButtonBuilder extends StatelessWidget {
  final TherapistData therapistData;
  final int? selectedSlotId;
  final DateTime? selectedSlotDate;
  final String selectedSlotDateString;
  const ConfirmButtonBuilder({
    Key? key,
    required this.therapistData,
    required this.selectedSlotId,
    required this.selectedSlotDate,
    required this.selectedSlotDateString,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// firstAvailableSlotDate  ||  acceptNewClient
    if (therapistData.firstAvailableSlotDate != null ||
        therapistData.acceptNewClient!) {
      /// isOldClient && firstAvailableSlotDate
      /// normal flow
      if (therapistData.isOldClient == true &&
          therapistData.firstAvailableSlotDate != null) {
        return _ConfirmButton(
          onPressed: selectedSlotId == null
              ? null
              : () {
                  MixpanelBookingBloc.bloc(context).add(
                    NextButtonInScheduleClickedEvent(
                      currency: therapistData.currency,
                      price: therapistData.feesPerSession,
                      slotDateTimeInUtc: selectedSlotDate!.toUtc(),
                    ),
                  );
                  Adjust.trackEvent(
                    AdjustManager.buildSimpleEvent(
                      eventToken: ApiKeys.nextEventToken,
                    ),
                  );
                  context.read<TherapistProfileBloc>().add(
                        BookASessionClicked(
                          selectedSlotId!.toString(),
                          selectedSlotDateString,
                        ),
                      );
                },
          text: context.translate(LangKeys.next),
        );

        /// firstAvailableSlotDate && acceptNewClient
        /// normal flow
      } else if (therapistData.firstAvailableSlotDate != null &&
          therapistData.acceptNewClient == true) {
        return _ConfirmButton(
          onPressed: selectedSlotId == null
              ? null
              : () {
                  MixpanelBookingBloc.bloc(context).add(
                    NextButtonInScheduleClickedEvent(
                      currency: therapistData.currency,
                      price: therapistData.feesPerSession,
                      slotDateTimeInUtc: selectedSlotDate!.toUtc(),
                    ),
                  );
                  Adjust.trackEvent(
                    AdjustManager.buildSimpleEvent(
                      eventToken: ApiKeys.nextEventToken,
                    ),
                  );
                  context.read<TherapistProfileBloc>().add(
                        BookASessionClicked(
                          selectedSlotId!.toString(),
                          selectedSlotDateString,
                        ),
                      );
                },
          text: context.translate(LangKeys.next),
        );

        /// firstAvailableSlotDate && acceptNewClient
        /// request a session
      } else if (therapistData.firstAvailableSlotDate == null &&
          therapistData.acceptNewClient == true) {
        return _ConfirmButton(
          onPressed: () {
            context
                .read<TherapistProfileBloc>()
                .add(RequestASessionEvent(therapistData.id!));
          },
          text: context.translate(LangKeys.requestASession),
        );

        /// isOldClient && firstAvailableSlotDate && acceptNewClient
        /// joinWaitList
      } else if (therapistData.isOldClient == false &&
          therapistData.firstAvailableSlotDate != null &&
          therapistData.acceptNewClient == false) {
        return _ConfirmButton(
          onPressed: () {
            context
                .read<TherapistProfileBloc>()
                .add(JoinWaitListEvent(therapistData.id!));
          },
          text: context.translate(LangKeys.joinWaitList),
        );
      }
    }

    /// no slots && not accept new clients
    /// notAvailable
    if (therapistData.firstAvailableSlotDate == null &&
        therapistData.acceptNewClient == false) {
      return _ConfirmButton(
        onPressed: null,
        text: context.translate(LangKeys.notAvailable),
      );
    }
    return const SizedBox.shrink();
  }
}

class _ConfirmButton extends StatelessWidget {
  final String text;
  final void Function()? onPressed;

  const _ConfirmButton({
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding:
          const EdgeInsets.only(top: 20.0, left: 24, right: 24, bottom: 20),
      child: SizedBox(
        width: context.width * 0.70,
        height: 45,
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0),
              )),
          child: Text(text),
        ),
      ),
    );
  }
}
