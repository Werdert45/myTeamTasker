import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  final Streams streams = Streams();

  @override
  Widget build(BuildContext context) {


    var user = Provider.of<User>(context);

    return FutureBuilder(
      future: streams.getCalendar(user.uid),
      builder: (context, snapshot) {
        print(snapshot.data);
        return Container();
      }
    );
  }
}


