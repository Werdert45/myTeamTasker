import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: Container(
            height: 400,
            width: MediaQuery.of(context).size.width * 0.7,
            child: Column(
              children: [
                Icon(Icons.not_interested, size: 60),
                SizedBox(height: 30),
                Text("No Connectivity", style: TextStyle(fontSize: 20)),
                SizedBox(height: 20),
                Text("Oops, it seems that you are not connected and we cannot authenticate you right now, try again, when you have internet connection.", textAlign: TextAlign.center,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
