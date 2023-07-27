import 'dart:async';
import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/bloc/get_matched_pressed_bloc/pressed_get_matched_model.dart';
import 'package:o7therapy/util/secure_storage_helper/secure_storage.dart';

part 'get_matched_button_event.dart';
part 'get_matched_button_state.dart';

class GetMatchedButtonBloc
    extends Bloc<GetMatchedButtonEvent, GetMatchedButtonState> {
  PressedGetMatchedModel? pressedGetMatchedModel;
  GetMatchedButtonBloc() : super(const HideGetMatchedCard()) {
    on<CheckGetMatchedCardEvent>(_onCheckGetMatchedCardEvent);
    on<PressedGetMatchedButtonEvent>(_onPressedGetMatchedButtonEvent);
  }

  static GetMatchedButtonBloc bloc(BuildContext context) =>
      context.read<GetMatchedButtonBloc>();

  /// On user press on the button to navigate to get matched
  /// 1. get the saved list of ids list
  /// 2. check if the json model is empty
  ///   1. empty: create new model and add his id >> [_handelEmptyGetMatchedIds]
  ///   2. not empty: there is saved model >> Check if his id already exit or not in [_handelModelWithGetMatchedIds]
  /// 3. convert to json and save it in secure storage
  FutureOr<void> _onPressedGetMatchedButtonEvent(
    PressedGetMatchedButtonEvent event,
    Emitter<GetMatchedButtonState> emit,
  ) async {
    final String getMatchedModelJson =
        await SecureStorage.getPressedGetMatchedModel();
    final String userId = await SecureStorage.getId() ?? "";

    PressedGetMatchedModel model;

    /// if get getMatchedIds is empty String
    /// >> then create new model and add new list in it
    /// else
    /// >> convert the data form json and update the list in the model
    if (getMatchedModelJson.isEmpty) {
      model = await _handelEmptyGetMatchedIds(userId);
    } else {
      model = await _handelModelWithGetMatchedIds(userId, getMatchedModelJson);
    }

    log(model.toString());

    /// save the model to the storage
    await SecureStorage.setGetMatchedModel(value: model.toJson());
    emit(const HideGetMatchedCard());
  }

  /// Get Ids of the user who GEt Matched Before
  /// and if the list contains the current logged in user
  /// then hide the cards
  /// and show getMatch again button
  FutureOr<void> _onCheckGetMatchedCardEvent(
    CheckGetMatchedCardEvent event,
    Emitter<GetMatchedButtonState> emit,
  ) async {
    final String getMatchedIds =
        await SecureStorage.getPressedGetMatchedModel();
    final String userId = await SecureStorage.getId() ?? "";

    /// if get getMatchedIds is empty >> then show the card
    if (getMatchedIds.isEmpty) {
      return emit(const ShowGetMatchedCard());
    }

    PressedGetMatchedModel model =
        PressedGetMatchedModel.fromJson(getMatchedIds);
    log(model.toString());

    if (model.pressedGetMatchedIds.contains(userId)) {
      return emit(const HideGetMatchedCard());
    } else {
      return emit(const ShowGetMatchedCard());
    }
  }

  /// if the model stored in the storage is empty
  /// then create new model and add the user id to it
  Future<PressedGetMatchedModel> _handelEmptyGetMatchedIds(
    String userId,
  ) async {
    return PressedGetMatchedModel(pressedGetMatchedIds: [userId]);
  }

  /// handle the model already contains list of ids
  /// add the new id to it if not exist
  Future<PressedGetMatchedModel> _handelModelWithGetMatchedIds(
    String userId,
    String getMatchedModel,
  ) async {
    final List<String> pressedGetMatchedIds =
        PressedGetMatchedModel.fromJson(getMatchedModel).pressedGetMatchedIds;

    /// add the new id if not exist in the current list
    if (!pressedGetMatchedIds.contains(userId)) {
      pressedGetMatchedIds.add(userId);
    }

    /// create new model
    return PressedGetMatchedModel(pressedGetMatchedIds: pressedGetMatchedIds);
  }
}
