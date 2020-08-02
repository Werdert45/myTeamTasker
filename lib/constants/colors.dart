import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/scheduler.dart';

var brightness = SchedulerBinding.instance.window.platformBrightness;
bool darkModeOn = brightness == Brightness.dark;

//var primaryColor = Color(0xFF572f8c);
//var primaryColor = darkModeOn ? Color.fromRGBO(21, 105, 94, 1) : Colors.white;
var primaryColor = Color.fromRGBO(21, 105, 94, 1);
var secondaryColor = Color(0xFFc6bed2);

var boxColor = Color.fromRGBO(21, 105, 94, 1);
var mainTextColor = Colors.white;
var selectedColor = Colors.green;
var unselectedColor = Colors.red;
var confirmColor = Colors.green;
var tabColor = Colors.teal;

// List of colors for the per member statistics
List pieChartColors = [Colors.pink, Colors.red, Colors.yellow, Colors.lime, Colors.green, Colors.teal, Colors.cyan];
List colorList = [
  charts.MaterialPalette.pink.shadeDefault,
  charts.MaterialPalette.red.shadeDefault,
  charts.MaterialPalette.yellow.shadeDefault,
  charts.MaterialPalette.lime.shadeDefault,
  charts.MaterialPalette.green.shadeDefault,
  charts.MaterialPalette.teal.shadeDefault,
  charts.MaterialPalette.cyan.shadeDefault
];