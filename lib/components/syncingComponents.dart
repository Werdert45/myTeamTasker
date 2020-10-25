import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';


// Check whether the banner is necessary
// connection:
Widget checkConnectivity(connection, context, bigger) {
//  print(connection);
  switch (connection.keys.toList()[0]) {
    case ConnectivityResult.none:
      // Offline: show
      return offlineBanner(context, bigger);
      break;
    case ConnectivityResult.mobile:
      return SizedBox();
      break;
    case ConnectivityResult.wifi:
      return SizedBox();
  }
}


// Offline banner to show when the user is offline
Widget offlineBanner(context, bigger) {
  if (bigger) {
    return Positioned(
      top: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 50,
        color: Colors.blueAccent,
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 30, right: 20),
          child: Text("You are offline, changes will be synced once online"),
        ),
      ),
    );
  }

  else {
    return Positioned(
      top: 0,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 40,
        color: Colors.blueAccent,
        child: Padding(
          padding: EdgeInsets.only(left: 20, top: 20, right: 20),
          child: Text("You are offline, changes will be synced once online"),
        ),
      ),
    );
  }
}



// Check the connectivity
class MyConnectivity {
  MyConnectivity._internal();

  static final MyConnectivity _instance = MyConnectivity._internal();

  static MyConnectivity get instance => _instance;

  Connectivity connectivity = Connectivity();

  StreamController controller = StreamController.broadcast();

  Stream get myStream => controller.stream;

  void initialise() async {
    ConnectivityResult result = await connectivity.checkConnectivity();
    _checkStatus(result);
    connectivity.onConnectivityChanged.listen((result) {
      _checkStatus(result);
    });
  }

  void _checkStatus(ConnectivityResult result) async {
    bool isOnline = false;
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isOnline = true;
      } else
        isOnline = false;
    } on SocketException catch (_) {
      isOnline = false;
    }
    controller.sink.add({result: isOnline});
  }

  void disposeStream() => controller.close();
}