import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:o7therapy/_base/widgets/base_stateful_widget.dart';
import 'package:o7therapy/api/api_keys.dart';
import 'package:o7therapy/api/models/activity/past_sessions/List.dart';
import 'package:o7therapy/api/models/confirm_status/confirm_status_send_model.dart';
import 'package:o7therapy/res/assets_path.dart';
import 'package:o7therapy/res/const_colors.dart';
import 'package:o7therapy/ui/screens/activity/bloc/activity_bloc.dart';
import 'package:o7therapy/util/lang/app_localization_keys.dart';
import 'package:shimmer/shimmer.dart';

class PastSessionsCard extends BaseStatefulWidget {
  final PastListData sessions;

  const PastSessionsCard({Key? key, required this.sessions}) : super(key: key);

  @override
  BaseState<PastSessionsCard> baseCreateState() => _PastSessionsCardState();
}

class _PastSessionsCardState extends BaseState<PastSessionsCard> {
  ConfirmStatusSendModel model = ConfirmStatusSendModel();
  bool requiredComment = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget baseBuild(BuildContext context) {
    return BlocBuilder<ActivityBloc, ActivityState>(
      builder: (context, state) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4.0),
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
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: _getStatusText(
                              widget.sessions.status!, widget.sessions),
                        ),
                        _getRateAndConfirmStatusButton(
                            widget.sessions.status!,
                            widget.sessions.sessionStatusConfirmedByClient,
                            widget.sessions),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isSessionInTime(String date) {
    return false;
  }

///////////////////////////////////////////////////////////
//////////////////// Widget methods ///////////////////////
///////////////////////////////////////////////////////////

  ShapeBorder _getCardShape() {
    return RoundedRectangleBorder(
        borderRadius: Directionality.of(context) == TextDirection.LTR
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

  Widget _dateContainer() {
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          bottomRight: Radius.circular(16),
          bottomLeft: Radius.zero,
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16)),
      child: Container(
        height: height / 9,
        width: width / 7,
        color: ConstColors.app.withOpacity(0.10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              DateFormat("dd").format(
                DateTime.parse(_getDate(widget.sessions.dateFrom!)),
              ),
              style: const TextStyle(
                  color: ConstColors.textSecondary,
                  fontSize: 24,
                  fontWeight: FontWeight.w700),
            ),
            Text(
              DateFormat("MMM").format(
                DateTime.parse(_getDate(widget.sessions.dateFrom!)),
              ),
              style: const TextStyle(
                  color: ConstColors.textSecondary,
                  fontSize: 11,
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }

  Widget _therapistDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.sessions.therapistName!,
          style: const TextStyle(
              color: ConstColors.text,
              fontSize: 14,
              fontWeight: FontWeight.w600),
        ),
        Wrap(
          children: [
            SizedBox(
              width: width * 0.35,
              child: Text(
                widget.sessions.therapistProfession!,
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
  }

  Widget _sessionDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          translate(LangKeys.fiftyMinutes),
          style: const TextStyle(
              color: ConstColors.text,
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

  Widget _therapistImageAndTime() {
    return Column(
      children: [
        SizedBox(
          height: width / 5.5,
          width: width / 5.5,
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(8)),
            child: CachedNetworkImage(
              imageUrl: ApiKeys.baseUrl + widget.sessions.therapistImage!.url!,
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
        Text(
          DateFormat().add_jm().format(
              DateTime.parse(_getDate(widget.sessions.dateFrom!)).toLocal()),
          style: const TextStyle(
              color: ConstColors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w700),
        )
      ],
    );
  }

  Widget _getStatusText(int status, PastListData? session) {
    switch (status) {
      case 3:
        return _getText(translate(LangKeys.canceled), ConstColors.textDisabled);
      case 4:
        return _getText(translate(LangKeys.completed), ConstColors.app);
      case 5:
        if (session?.therapistJoinedDate == null &&
            session?.patientJoinedDate != null) {
          return _getText(
              translate(LangKeys.missedByTherapist), ConstColors.textDisabled);
        } else if (session?.patientJoinedDate == null &&
            session?.therapistJoinedDate != null) {
          return _getText(
              translate(LangKeys.missedByMe), ConstColors.textDisabled);
        } else {
          return _getText(translate(LangKeys.missed), ConstColors.textDisabled);
        }

      default:
        return _getText(translate(LangKeys.completed), ConstColors.app);
    }
  }

  Widget _getText(String status, Color color) {
    return Text(
      status,
      style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w400),
    );
  }

  Widget _getRateAndConfirmStatusButton(
      int status, bool? sessionStatusConfirmedByClient, PastListData sessions) {
    if (sessions.patientJoinedDate != null &&
        sessions.therapistJoinedDate == null) {
      if (status == 5 &&
          (sessionStatusConfirmedByClient == null ||
              sessionStatusConfirmedByClient == false)) {
        final Duration duration = DateTime.now()
            .difference(DateTime.parse(_getDate(sessions.dateFrom!)));
        if (duration.inDays < 7) {
          return TextButton(
              onPressed: () {
                _getConfirmStatusModalSheet();
              },
              child: Text(
                translate(LangKeys.confirmStatus),
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: ConstColors.secondary,
                    fontSize: 12,
                    fontWeight: FontWeight.w500),
              ));
        } else {
          return const SizedBox();
        }
      }
      if (status == 4) {
        if (sessions.sessionStatusConfirmedByClient != null &&
            sessions.sessionStatusConfirmedByClient == true) {
          return const SizedBox();
        } else {
          if (sessions.endedDate == null) {
            return const SizedBox();
          } else {
            final Duration duration =
                DateTime.parse(_getDate(sessions.endedDate!)).difference(
                    DateTime.parse(_getDate(sessions.startedDate!)));
            if (duration.inMinutes < 15) {
              final Duration duration = DateTime.now()
                  .difference(DateTime.parse(_getDate(sessions.dateFrom!)));

              if (duration.inDays < 7) {
                return TextButton(
                    onPressed: () {
                      _getConfirmStatusModalSheet();
                    },
                    child: Text(
                      translate(LangKeys.confirmStatus),
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: ConstColors.secondary,
                          fontSize: 12,
                          fontWeight: FontWeight.w500),
                    ));
              } else {
                return const SizedBox();
              }
            } else {
              return const SizedBox();
            }
          }
        }
      } else {
        return const SizedBox();
      }
    } else {
      if (sessions.sessionStatusConfirmedByClient != null &&
          sessions.sessionStatusConfirmedByClient == true) {
        return const SizedBox();
      }
      if (status == 4) {
        if (sessions.endedDate == null) {
          return const SizedBox();
        } else {
          final Duration duration =
              DateTime.parse(_getDate(sessions.endedDate!))
                  .difference(DateTime.parse(_getDate(sessions.startedDate!)));
          if (duration.inMinutes < 15) {
            final Duration duration = DateTime.now()
                .difference(DateTime.parse(_getDate(sessions.dateFrom!)));

            if (duration.inDays < 7) {
              return TextButton(
                  onPressed: () {
                    _getConfirmStatusModalSheet();
                  },
                  child: Text(
                    translate(LangKeys.confirmStatus),
                    style: const TextStyle(
                        decoration: TextDecoration.underline,
                        color: ConstColors.secondary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ));
            } else {
              return const SizedBox();
            }
          } else {
            return const SizedBox();
          }
        }
      } else {
        return const SizedBox();
      }
      // return const SizedBox();
    }
  }

  _getConfirmStatusModalSheet() {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(16), topLeft: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: Padding(
            // padding: const EdgeInsets.all(20.0),
            padding: EdgeInsets.only(
                top: 20.0,
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 20.0,
                right: 20.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Text(
                    translate(LangKeys.confirmSessionStatus),
                    style: const TextStyle(
                        color: ConstColors.app,
                        fontSize: 18,
                        fontWeight: FontWeight.w700),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      translate(LangKeys.looksLikeYouLeftTheSession),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: ConstColors.text,
                          fontSize: 14,
                          fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  _getDropdownReasonField(),
                  const SizedBox(height: 24),
                  _detailsTextField(),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _cancelButton(),
                      const SizedBox(
                        width: 10,
                      ),
                      _submitButton(),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  List<DropdownMenuItem<String>> get genderDropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      DropdownMenuItem(
          value: "The client missed the session",
          child: Text(translate(LangKeys.clientMissedTheSession))),
      DropdownMenuItem(
          value: "The session was rescheduled",
          child: Text(translate(LangKeys.sessionRescheduled))),
      DropdownMenuItem(
          value: "The session was taken off the O7 Therapy Platform",
          child: Text(translate(LangKeys.sessionTakenOff))),
      DropdownMenuItem(
          value: "Other", child: Text(translate(LangKeys.otherAddNote))),
    ];
    return menuItems;
  }

  String selectedValue = "The client missed the session";

  Widget _getDropdownReasonField() {
    return DropdownButtonFormField<String>(
      isExpanded: true,
      elevation: 5,
      dropdownColor: ConstColors.appWhite,
      // value: selectedValue,
      hint: Text(translate(LangKeys.selectReason)),
      decoration: const InputDecoration(
        filled: true,
        fillColor: ConstColors.scaffoldBackground,
        alignLabelWithHint: true,
        enabled: true,
        border: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        disabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        errorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
        focusedErrorBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: ConstColors.textDisabled)),
      ),
      onChanged: (String? newValue) {
        setState(() {
          selectedValue = newValue!;
        });
        if (newValue == 'The session was taken off the O7 Therapy Platform' ||
            newValue == 'Other') {
          requiredComment = true;
        } else {
          requiredComment = false;
        }
      },
      items: genderDropdownItems,
      onSaved: (value) {
        model.reason = value!;
        if (value == 'The session was taken off the O7 Therapy Platform') {
          model.sessionStatus = 4;
        }
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return translate(LangKeys.reasonEmptyErr);
        }
      },
    );
  }

  Widget _detailsTextField() {
    return TextFormField(
      minLines: 7,
      maxLines: 7,
      keyboardType: TextInputType.multiline,
      onSaved: (value) {
        model.clientComment = value;
      },
      decoration: const InputDecoration(
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(color: ConstColors.disabled)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(color: ConstColors.disabled)),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16),
            ),
            borderSide: BorderSide(color: ConstColors.disabled)),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          if (requiredComment) {
            return translate(LangKeys.clientCommentEmptyErr);
          }
        }
        // validator: (value) {
        //   if (value == null && !requiredComment == true) {
        //     return translate(LangKeys.clientCommentEmptyErr);
        //   }
      },
    );
  }

  Widget _cancelButton() {
    return InkWell(
      onTap: () {
        Navigator.of(context).pop();
      },
      child: Chip(
        backgroundColor: ConstColors.appWhite,
        side: const BorderSide(color: ConstColors.app),
        label: Text(
          translate(LangKeys.cancel),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.app,
          ),
        ),
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () {
        if (!_formKey.currentState!.validate()) {
          return;
        }
        _formKey.currentState!.save();
        context.read<ActivityBloc>().add(ConfirmStatusEvent(
            ConfirmStatusSendModel(
                clientComment: model.clientComment,
                reason: model.reason,
                sessionStatus: model.sessionStatus ?? widget.sessions.status,
                sessionId: widget.sessions.id)));
        Navigator.of(context).pop();
      },
      child: Chip(
        backgroundColor: ConstColors.app,
        label: Text(
          translate(LangKeys.submit),
          style: const TextStyle(
            fontSize: 14.0,
            fontWeight: FontWeight.w400,
            color: ConstColors.appWhite,
          ),
        ),
      ),
    );
  }

///////////////////////////////////////////////////////////
/////////////////// Helper methods ////////////////////////
///////////////////////////////////////////////////////////

  String _getDate(String date) {
    String year = date.substring(0, 4);
    String month = date.substring(4, 6);
    String day = date.substring(6, 8);
    String hour = date.substring(8, 10);
    String minute = date.substring(10, 12);
    String second = date.substring(12, 14);
    String formattedDate = year +
        '-' +
        month +
        "-" +
        day +
        "T" +
        hour +
        ":" +
        minute +
        ":" +
        second +
        "Z";
    return formattedDate;
  }
}
