import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
  final Streams streams = Streams();

  void initState() {
    super.initState();
    checkedValue = false;
  }


  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return SingleChildScrollView(
      child: FutureBuilder(
        future: streams.getCompleteUser(user.uid),
        builder: (context, snapshot) {
          return Container(
              child: Column(
                children: [
                  Container(
                    child: Center(
                      child: RaisedButton(
                        onPressed: () async {
                          await _auth.signOut();
                        },
                        child: Text("Logout"),
                      ),
                    ),
                    height: MediaQuery.of(context).size.height / 4.5,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: Color(0xFF572f8c),
                        border: Border(
                        ),
                        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30))
                    ),
                  ),

                  SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    height: 800,
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data.tasks.length,
                        itemBuilder: (context, index) {
                          return Container(
                            width: double.infinity,
                            child: EmoIcon(snapshot.data.tasks[index]),
                          );
                        }
                    ),
                  )
                ],
              )
          );
        },
      ),
    );
  }
}
