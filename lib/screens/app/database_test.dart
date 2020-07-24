import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/screens/app/partials/donutchart.dart';
import 'package:collaborative_repitition/screens/app/partials/timeseriesgraph.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/stat_functions.dart';
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

    var test_data = {"2020-7-23": [1,1]};

    var test_data2 = {"2020-7-22": {"puid": [2], "puid2": [3]}, "2020-7-23": {"puid": [2], "puid2": [4]}};

    print(pieChartGroup(test_data2, ["puid", "puid2"]));
    return Container(
      child: DonutPieChart(pieChartGroup(test_data2, ["puid", "puid2"])),
    );
  }
}
