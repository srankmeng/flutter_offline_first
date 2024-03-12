import 'dart:io'; //InternetAddress utility
import 'dart:async'; //For StreamController/Stream

import 'package:connectivity_plus/connectivity_plus.dart';

class ConnectionStatusService {
  //This creates the single instance by calling the `_` constructor specified below
  static final ConnectionStatusService _connectionStatus =
      ConnectionStatusService._();
  ConnectionStatusService._();

  factory ConnectionStatusService() {
    return _connectionStatus;
  }

  //This is how we'll allow subscribing to connection changes
  StreamController connectionChangeController = StreamController.broadcast();

  Stream get connectionChange => connectionChangeController.stream;

  final Connectivity _connectivity = Connectivity();
  bool hasConnection = false;

  void _connectionChange(ConnectivityResult result) async {
    checkConnection();
  }

  Future<bool> checkConnection() async {
    bool previousConnection = hasConnection;

    try {
      final result = await _connectivity.checkConnectivity();
      if (result == ConnectivityResult.wifi ||
          result == ConnectivityResult.mobile) {
        hasConnection = true;
      } else {
        hasConnection = false;
      }
    } on SocketException catch (_) {
      hasConnection = false;
    }

    // ignore: avoid_print
    print("Connection status :: $hasConnection");

    //The connection status changed send out an update to all listeners
    if (previousConnection != hasConnection) {
      connectionChangeController.add(hasConnection);
    }

    return hasConnection;
  }

  void initialize() async {
    _connectivity.onConnectivityChanged.listen(_connectionChange);
    await checkConnection();
  }

  void dispose() {
    connectionChangeController.close();
  }
}
