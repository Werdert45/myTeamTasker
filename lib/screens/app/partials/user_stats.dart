import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/screens/app/partials/timeseriesgraph.dart';
import 'package:collaborative_repitition/services/functions/stat_functions.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UserStatPage extends StatefulWidget {
  final task_history;

  UserStatPage(this.task_history);

  @override

  _UserStatPageState createState() => _UserStatPageState();
}

class _UserStatPageState extends State<UserStatPage> {
  List<bool> timeFrame = [true,false];



  @override
  Widget build(BuildContext context) {
    return Container(
      height: 500,
//      color: backgroundColor,
      child: Column(
        children: [
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  SizedBox(height: 65),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Finished Task History", style: TextStyle(fontSize: 18)),
                        SizedBox()
                      ],
                    ),
                  ),
                  Container(
                    height: 280,
                      child: TimeSeriesGraphScreen(timeSeriesPointsPers(widget.task_history, 7))
                  ),
                ],
              ),
            ),
          ),
        ],
      )
    );
  }
}
