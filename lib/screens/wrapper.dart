import 'package:collaborative_repitition/components/syncingComponents.dart';
import 'package:collaborative_repitition/screens/app/homepage.dart';
import 'package:collaborative_repitition/screens/authentication/welcome.dart';
import 'package:collaborative_repitition/screens/noconnection.dart';
import 'package:collaborative_repitition/services/functions/connectionFunctions.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user.dart';


class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {

  Map _source = {ConnectivityResult.none: false};
  MyConnectivity _connectivity = MyConnectivity.instance;


  void initState() {
    super.initState();

    // Connection check
    _connectivity.initialise();
    _connectivity.myStream.listen((source) {
      setState(() => _source = source);
    });
  }

  @override
  Widget build(BuildContext context) {

    final user = Provider.of<User>(context);


    if (user == null) {
      if (connected(_source)) {
        return WelcomePage();
      }
      else {
        return NoConnection();
      }
    }
    else {
      return HomePage();
    }
  }
}


