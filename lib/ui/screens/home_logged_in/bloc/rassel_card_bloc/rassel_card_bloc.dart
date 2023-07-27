import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/ui/screens/home_logged_in/bloc/rassel_card_bloc/users_dismissed_rassel_card_model.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

part 'rassel_card_event.dart';
part 'rassel_card_state.dart';

class RasselCardBloc extends Bloc<RasselCardEvent, RasselCardState> {
  RasselCardBloc() : super(const RasselCardInitial()) {
    on<DismissRasselCardEvent>(_onDismissRasselCardEvent);
    on<CheckRasselCardIsDismissedEvent>(_onCheckRasselCardIsDismissedEvent);
  }

  static RasselCardBloc bloc(BuildContext context) =>
      context.read<RasselCardBloc>();

  FutureOr<void> _onDismissRasselCardEvent(
    DismissRasselCardEvent event,
    Emitter<RasselCardState> emit,
  ) async {
    log("message");
    String? usersDismissedRasselCardJson =
        await SecureStorage.getUsersDismissedRasselCard();
    String? currentUserMail = await SecureStorage.getEmail();
    log("usersDismissedRasselCardJson: $usersDismissedRasselCardJson");
    log("currentUserMail: $currentUserMail");
    if (currentUserMail == null) {
      return emit(const NotDismissedRasselCardState());
    }

    if (usersDismissedRasselCardJson == null) {
      UsersDismissedRasselCardModel usersDismissedRasselCard =
          UsersDismissedRasselCardModel([currentUserMail]);
      SecureStorage.setUsersDismissedRasselCard(
          usersDismissedRasselCard.toJson());
    } else {
      UsersDismissedRasselCardModel usersDismissedRasselCard =
          UsersDismissedRasselCardModel.fromJson(usersDismissedRasselCardJson);
      List<String> updatedUsersMails = usersDismissedRasselCard.usersMails
        ..add(currentUserMail);
      SecureStorage.setUsersDismissedRasselCard(
          UsersDismissedRasselCardModel(updatedUsersMails).toJson());
    }

    return emit(const DismissedRasselCardState());
  }

  FutureOr<void> _onCheckRasselCardIsDismissedEvent(
    CheckRasselCardIsDismissedEvent event,
    Emitter<RasselCardState> emit,
  ) async {
    String? usersDismissedRasselCardJson =
        await SecureStorage.getUsersDismissedRasselCard();
    String? currentUserMail = await SecureStorage.getEmail();
    if (usersDismissedRasselCardJson == null || currentUserMail == null) {
      return emit(const NotDismissedRasselCardState());
    }

    List<String> usersDismissedRasselMails =
        UsersDismissedRasselCardModel.fromJson(usersDismissedRasselCardJson)
            .usersMails;
    log("Users Dismissed Rassel on this phone ${usersDismissedRasselMails.toString()}");
    bool isUserDismissedRasselCard = usersDismissedRasselMails
        .any((userMail) => userMail == currentUserMail);

    if (isUserDismissedRasselCard) {
      return emit(const DismissedRasselCardState());
    } else {
      return emit(const NotDismissedRasselCardState());
    }
  }
}
