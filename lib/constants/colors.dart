import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/scheduler.dart';

var brightness = SchedulerBinding.instance.window.platformBrightness;
bool darkModeOn = brightness == Brightness.dark;


/// First color palette
//var primaryColor = Color(0xFF572f8c);
//var primaryColor = darkModeOn ? Color.fromRGBO(21, 105, 94, 1) : Colors.white;
//var primaryColor = Color.fromRGBO(21, 105, 94, 1);
//var secondaryColor = Color(0xFFc6bed2);
//
//var boxColor = Color.fromRGBO(21, 105, 94, 1);
//var mainTextColor = Colors.white;
//var selectedColor = Colors.green;
//var unselectedColor = Colors.red;
//var confirmColor = Colors.green;
//var tabColor = Colors.teal;



/// Second color palette
//var primaryColorFocus = Colors.blue;
//var primaryColor = Color(0xFF26315A);
//var primaryColorHalf = Color(0xCC26315A);
//var secondaryColor = Color(0xFF6165E1);
//var foregroundColor = Color(0xFFEF9C80);
//var backgroundColor = Color(0xFFD8D8D8);
//
//var boxColor = Color.fromRGBO(21, 105, 94, 1);
//var mainTextColor = Colors.white;
//var selectedColor = Colors.green;
//var unselectedColor = Colors.red;
//// Color of confirm/change buttons
//var confirmColor = primaryColor;
//var textFieldFillColor = Color(0xFFE0E0E0);
//var tabColor = Colors.teal;


var darkmodeColor = {
  'name': 'Dark',
  'primaryColorFocus': Colors.blue,
  'primaryColor': Color(0xFF05668D),
  'primaryColorHalf': Color(0xCC05668D),
  'secondaryColor': Color(0xFF028090),
  'foregroundColor': Color(0xFF028090),
  'backgroundColor': Color(0xFF303030),

  'boxColor': Color.fromRGBO(21, 105, 94, 1),
  'mainTextColor': Colors.white,
  'selectedColor': Colors.green,
  'unselectedColor': Colors.red,

  'confirmColor': Color(0xFF05668D),
  'textFieldFillColor': Color(0xFFE0E0E0),
  'tabColor': Colors.teal,

  'taskColor': Color(0xFF232B2B)
};

var lightmodeColor = {
  'name': 'Light',
  'primaryColorFocus': Colors.blue,
  'primaryColor': Color(0xFF05668D),
  'primaryColorHalf': Color(0xCC05668D),
  'secondaryColor': Color(0xFF028090),
  'foregroundColor': Color(0xFF028090),
  'backgroundColor': Color(0xFFD8D8D8),


  'boxColor': Color.fromRGBO(21, 105, 94, 1),
  'mainTextColor': Colors.black,
  'selectedColor': Colors.green,
  'unselectedColor': Colors.red,

  'confirmColor': Color(0xFF05668D),
  'textFieldFillColor': Color(0xFFE0E0E0),
  'tabColor': Colors.teal,

  'taskColor': Color(0xFFE8EDED)
};

//var primaryColorFocus = Colors.blue;
//var primaryColor = Color(0xFF05668D);
//var primaryColorHalf = Color(0xCC05668D);
//var secondaryColor = Color(0xFF028090);
//var foregroundColor = Color(0xFF028090);
//var backgroundColor = Color(0xFFD8D8D8);
//
//var boxColor = Color.fromRGBO(21, 105, 94, 1);
//var mainTextColor = Colors.white;
//var selectedColor = Colors.green;
//var unselectedColor = Colors.red;
//// Color of confirm/change buttons
//var confirmColor = primaryColor;
//var textFieldFillColor = Color(0xFFE0E0E0);
//var tabColor = Colors.teal;
//
//var taskColor = Color(0xFFE8EDED);
//


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

