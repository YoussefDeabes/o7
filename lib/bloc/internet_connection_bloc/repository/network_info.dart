import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

/// AbstractNetworkInfo
/// Future<bool> get isConnected;
/// Stream<ConnectivityResult> checkConnectionStream();
abstract class AbstractNetworkInfo {
  const AbstractNetworkInfo();
  Future<bool> get isConnected;
  Stream<ConnectivityResult> checkConnectionStream();
}

class NetworkInfoRepository implements AbstractNetworkInfo {
  /// the package Connectivity _connectivity
  final Connectivity _connectivity;

  const NetworkInfoRepository({
    required Connectivity connectivity,
  }) : _connectivity = connectivity;

  @override
  Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();

    /// if no Date or wifi is opened the back false with url check
    /// if there is data or wifi the check the url and return the result
    if (connectivityResult == ConnectivityResult.none) {
      return false;
    }

    /// return true if the device ConnectivityResult is connected to wifi or mobile data
    /// not equal to none
    return true;
  }

  /// return _connectivity.onConnectivityChanged;
  @override
  Stream<ConnectivityResult> checkConnectionStream() {
    return _connectivity.onConnectivityChanged;
  }
}
