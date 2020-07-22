import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:collaborative_repitition/screens/app/partials/donutchart.dart';
import 'package:flutter/material.dart';
import 'package:collaborative_repitition/screens/app/partials/timeseriesgraph.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class GroupStatPage extends StatefulWidget {
  @override
  _GroupStatPageState createState() => _GroupStatPageState();
}

class _GroupStatPageState extends State<GroupStatPage> {
  List<bool> timeFrame = [true,false];

  @override
  Widget build(BuildContext context) {
    return Container(
        child: DefaultTabController(
          initialIndex: 1,
          length: 2,
          child: Column(
            children: [
              SizedBox(height: 20),
              Container(
                width: 300,
                child: Center(
                  child: TabBar(
                    tabs: [
                      Container(
                        width: 80,
                        child: Row(
                          children: [
                            Icon(Icons.insert_chart, color: Colors.black),
                            SizedBox(width: 5),
                            Text("History", style: TextStyle(color: Colors.black))
                          ],
                        ),
                      ),
                      Container(
                        width: 106,
                        child: Row(
                          children: [
                            Icon(Icons.pie_chart, color: Colors.black),
                            SizedBox(width: 5),
                            Text("Per member", style: TextStyle(color: Colors.black))
                          ],
                        ),
                      )
                    ],
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: new BubbleTabIndicator(
                      indicatorHeight: 35.0,
                      indicatorColor: Colors.blueAccent,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    ),
                  ),
                ),
              ),
              Container(
                height: 420,
                child: TabBarView(
                  children: [
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            SizedBox(height: 25),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("Finished Task History", style: TextStyle(fontSize: 18)),
                                  SizedBox(height: 15),
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
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          children: [
                            SizedBox(height: 25),
                            Text("Finished Task History", style: TextStyle(fontSize: 18)),
                            SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: SizedBox(),
                                            ),
                                            SizedBox(width: 5),
                                            Text("Ian Ronk")
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: SizedBox(),
                                            ),
                                            SizedBox(width: 5),
                                            Text("Ian Ronk")
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.green,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: SizedBox(),
                                            ),
                                            SizedBox(width: 5),
                                            Text("Ian Ronk")
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.yellow,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: SizedBox(),
                                            ),
                                            SizedBox(width: 5),
                                            Text("Ian Ronk")
                                          ],
                                        ),
                                      ),
                                    ),Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                      child: Container(
                                        height: 30,
                                        child: Row(
                                          children: [
                                            Container(
                                              width: 20,
                                              height: 20,
                                              decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(10)
                                              ),
                                              child: SizedBox(),
                                            ),
                                            SizedBox(width: 5),
                                            Text("Ian Ronk")
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                                height: 280,
                                child: DonutPieChart(_createSampleData())
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
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

List<charts.Series<LinearSales, int>> _createSampleData() {
  final data = [
    new LinearSales(0, 100, "Ian", charts.MaterialPalette.blue.shadeDefault),
    new LinearSales(1, 75, "Ian 2", charts.MaterialPalette.red.shadeDefault),
    new LinearSales(2, 25, "Ian 3", charts.MaterialPalette.green.shadeDefault),
    new LinearSales(3, 5, "John", charts.MaterialPalette.yellow.shadeDefault),
  ];

  return [
    new charts.Series<LinearSales, int>(
      id: 'Sales',
      domainFn: (LinearSales sales, _) => sales.year,
      measureFn: (LinearSales sales, _) => sales.sales,
      data: data,
      labelAccessorFn: (LinearSales row, _) => '${row.member}',
//      fillColorFn: (LinearSales row, _) => row.color,
      colorFn: (LinearSales row, _) => row.color
    )
  ];
}

class TimeSeriesSales {
  final DateTime time;
  final int sales;

  TimeSeriesSales(this.time, this.sales);
}

class LinearSales {
  final int year;
  final int sales;
  final String member;
  final charts.Color color;

  LinearSales(this.year, this.sales, this.member, this.color);
}