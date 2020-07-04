import 'package:flutter/material.dart';
import 'task-tile.dart';
import 'components/button.dart';
import 'services/auth.dart';

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool checkedValue;

  final AuthService _auth = AuthService();

  void initState() {
    super.initState();
    checkedValue = false;
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 100),
            RaisedButton(
              onPressed: () async {
                await _auth.signOut();
              },
              child: Text("Logout"),
            ),
            SizedBox(height: 100),
            EmoIcon(),
            EmoIcon()
          ],
        ),
      )
    );
  }
}
