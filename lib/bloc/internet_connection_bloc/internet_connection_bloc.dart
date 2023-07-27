import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart'
    show ConnectivityResult;
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:o7therapy/bloc/internet_connection_bloc/repository/network_info.dart';

part 'internet_connection_event.dart';
part 'internet_connection_state.dart';

class InternetConnectionBloc
    extends Bloc<InternetConnectionEvent, InternetConnectionState> {
  final AbstractNetworkInfo _connectionCheck;
  InternetConnectionBloc({required AbstractNetworkInfo connectionCheck})
      : _connectionCheck = connectionCheck,
        super(const InternetConnectionState(isConnected: false)) {
    _checkConnectionStream();
    on<CheckConnection>(_onCheckConnection);
    on<SetConnectionToFalse>(_onSetConnectionToFalse);
  }

  static InternetConnectionState currentState =
      const InternetConnectionState(isConnected: false);
  static InternetConnectionBloc bloc(BuildContext context) =>
      context.read<InternetConnectionBloc>();

  /// this event only called in the situation of _checkConnectionStream is false
  void _onSetConnectionToFalse(event, emit) {
    currentState = const InternetConnectionState(isConnected: false);
    emit(currentState);
  }

  FutureOr<void> _onCheckConnection(event, emit) async {
    try {
      final bool isConnected = await _connectionCheck.isConnected;
      currentState = InternetConnectionState(isConnected: isConnected);
      emit(currentState);
    } catch (e) {
      currentState = const InternetConnectionState(isConnected: false);
      emit(currentState);
    }
  }

  /// listen to the stream and each time the user close data or wifi
  /// the it will force to set connection to false
  void _checkConnectionStream() {
    _connectionCheck
        .checkConnectionStream()
        .listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        add(const SetConnectionToFalse());
      } else {
        add(const CheckConnection());
      }
    });
  }
}
