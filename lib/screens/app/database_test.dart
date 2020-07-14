import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:collaborative_repitition/services/database.dart';

class Testing extends StatefulWidget {
  @override
  _TestingState createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  final DatabaseService database = DatabaseService();
  final Streams streams = Streams();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    return FutureBuilder(
      future: streams.getCompleteUser(user.uid),
      builder: (context, snapshot) {
        print(snapshot);
        return Container();
      }
    );
  }
}
