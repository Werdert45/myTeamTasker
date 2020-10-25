import 'package:collaborative_repitition/constants/colors.dart';
import 'package:charts_flutter/flutter.dart' as charts;

// Example of task_history_pers:
// {
//  2020-7-23: [0, 1] first is the completed tasks, the second is the total tasks
// }

timeSeriesPointsPers(Map task_history, range) {
  List<TimeSeriesSales> seriesLine = [];

  var now  = DateTime.now();
  var start_day = Duration(days: -range);


  var start = now.add(start_day);

  for (var i = 0; i <= range; i++) {

    var day = "${start.year}-${start.month}-${start.day}";


    if (task_history.containsKey(day)) {
      seriesLine.add(TimeSeriesSales(DateTime(start.year, start.month, start.day), task_history[day][0]));
    }

    else {
      // return a point with (day, 0)
      seriesLine.add(TimeSeriesSales(DateTime(start.year, start.month, start.day), 0));

    }

    start = start.add(Duration(days: 1));
  }

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

// Example of task_history_group:
// {
// datetime: {
//    userid: [task],
// }

timeSeriesPointsGroup(Map task_history, range) {
  List<TimeSeriesSales> seriesLine = [];

  var now  = DateTime.now();
  var start_day = Duration(days: -range);


  var start = now.add(start_day);

  for (var i = 0; i <= range; i++) {

    var day = "${start.year}-${start.month}-${start.day}";

    if (task_history.containsKey(day)) {
      var task_count = 0;

      // Loop through all of the users to get the length of the task list to add

      task_history[day].forEach((k,v) => task_count += v.length);

      seriesLine.add(TimeSeriesSales(DateTime(start.year, start.month, start.day), task_count));
    }

    else {
      // return a point with (day, 0)
      seriesLine.add(TimeSeriesSales(DateTime(start.year, start.month, start.day), 0));
    }

    // Increment day
    start = start.add(Duration(days: 1));
  }

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


pieChartGroup(Map task_history, Map members) {

  List<LinearSales> data = [];
  // Set all members contrib to zero
  var member_contrib = {};

  if (task_history.length != 0) {
    members.forEach((key, value) { member_contrib[key] = 0; });

    task_history.forEach((key, value) {

      value.forEach((key, value) => member_contrib[key] += value.length);
    });
  }

  else {
    member_contrib["No tasks completed"] = 1;
  }



  // TODO change color to dart colors and
  // Use counter to get the colors etc (note that the color list has to be expanded (a function to loop over values can be used for dart colors

  var counter = 0;

  member_contrib.forEach((key, value) {
    data.add(LinearSales(counter, value, members[key], colorList[counter]));
    counter += 1;
  });


  List<charts.Series<LinearSales, int>> _createSampleData() {
    return [
      new charts.Series<LinearSales, int>(
          id: 'Sales',
          domainFn: (LinearSales sales, _) => sales.year,
          measureFn: (LinearSales sales, _) => sales.sales,
          data: data,
          labelAccessorFn: (LinearSales row, _) => '${row.member}',
          colorFn: (LinearSales row, _) => row.color
      )
    ];
  }

  return _createSampleData();
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
