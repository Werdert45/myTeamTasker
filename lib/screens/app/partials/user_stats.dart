import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:collaborative_repitition/screens/app/partials/timeseriesgraph.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UserStatPage extends StatefulWidget {
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
                  Container(
                    width: MediaQuery.of(context).size.width - 30,
                    child: Row(
                      children: [
                        Card(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 10, top: 0, bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.check_circle, size: 28),
                                  Container(
                                    width: 50,
                                    child: Text("153 Tasks", style: TextStyle(fontSize: 16),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          elevation: 4,
                        ),
                        Card(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 10, top: 0, bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.check_circle, size: 28),
                                  Container(
                                    width: 50,
                                    child: Text("153 Tasks", style: TextStyle(fontSize: 16),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          elevation: 4,
                        ),
                        Card(
                          child: Container(
                            width: MediaQuery.of(context).size.width / 3 - 20,
                            height: 70,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15.0, right: 10, top: 0, bottom: 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Icon(Icons.assignment_turned_in, size: 28),
                                  Container(
                                    width: 50,
                                    child: Text("153 of 234", style: TextStyle(fontSize: 16),),
                                  )
                                ],
                              ),
                            ),
                          ),
                          elevation: 4,
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 25),
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
                      child: TimeSeriesGraphScreen(createSampleData())
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

List<charts.Series<TimeSeriesSales, DateTime>> createSampleData() {
  final seriesLine = [
    new TimeSeriesSales(new DateTime(2017, 9, 19), 2),
    new TimeSeriesSales(new DateTime(2017, 9, 20), 3),
    new TimeSeriesSales(new DateTime(2017, 9, 21), 5),
    new TimeSeriesSales(new DateTime(2017, 9, 22), 8),
    new TimeSeriesSales(new DateTime(2017, 9, 23), 5),
    new TimeSeriesSales(new DateTime(2017, 9, 24), 9),
    new TimeSeriesSales(new DateTime(2017, 9, 25), 4),
  ];

  return [
    new charts.Series<TimeSeriesSales, DateTime>(
      id: 'Line',
      colorFn: (_, __) => charts.MaterialPalette.gray.shadeDefault,
      domainFn: (TimeSeriesSales sales, _) => sales.time,
      measureFn: (TimeSeriesSales sales, _) => sales.sales,
      data: seriesLine,
    ),
    new charts.Series<TimeSeriesSales, DateTime>(
        id: 'Points',
        colorFn: (_, __) => charts.MaterialPalette.black,
        domainFn: (TimeSeriesSales sales, _) => sales.time,
        measureFn: (TimeSeriesSales sales, _) => sales.sales,
        data: seriesLine)
      ..setAttribute(charts.rendererIdKey, 'customPoint'),
  ];
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}