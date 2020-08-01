import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
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
      color: Colors.white,
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
                        Container(
                          height: 25,
                          child: ToggleButtons(
                            children: [
                              Text("Week"),
                              Text("Month")
                            ],
                            borderWidth: 0,
                            borderRadius: BorderRadius.circular(6),
                            selectedColor: Colors.greenAccent,
                            fillColor: Colors.grey,
                            splashColor: Colors.blue,
                            isSelected: timeFrame,
                            onPressed: (int index) {
                              setState(() {
                                if (index == 0) {
                                  timeFrame[1] = false;
                                }

                                else {
                                  timeFrame[0] = false;
                                }

                                timeFrame[index] = !timeFrame[index];
                              });
                            },
                          ),
                        ),

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
