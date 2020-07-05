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
            Container(
              height: MediaQuery.of(context).size.height / 4.5,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF572f8c),
                border: Border(
                  
                ),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
              ),
            ),


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
