import 'package:connectivity/connectivity.dart';

bool connected(connection) {
  switch (connection.keys.toList()[0]) {
    case ConnectivityResult.none:
    // Offline: show
      return false;
      break;
    case ConnectivityResult.mobile:
      return true;
      break;
    case ConnectivityResult.wifi:
      return true;
  }
}