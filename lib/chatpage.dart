import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/models/user_db.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final db = DatabaseService();
  final streams = Streams();
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    print(streams.getCompleteUser(user.uid));

    return Container(
        child: Center(
          child: StreamBuilder(
              stream: streams.streamUser(user.uid),
              builder: (BuildContext context, snapshot) {
                return Text(snapshot.data.groups[0]);
              }
          ),
        )
    );
  }
}
