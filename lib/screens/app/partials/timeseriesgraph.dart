import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;


class TimeSeriesGraphScreen extends StatelessWidget {
  final List<charts.Series> seriesList;
  final bool animate;

  TimeSeriesGraphScreen(this.seriesList, {this.animate});

  @override
  Widget build(BuildContext context) {
    return new charts.TimeSeriesChart(
      seriesList,
      animate: animate,
      behaviors: [
        charts.SlidingViewport(),

      ],
      domainAxis: charts.DateTimeAxisSpec(
        tickProviderSpec: charts.DayTickProviderSpec(increments: [1]),
        tickFormatterSpec: new charts.AutoDateTimeTickFormatterSpec(
          day: new charts.TimeFormatterSpec(
              format: 'MMMd', transitionFormat: 'MMMd', noonFormat: 'MMMd'),
        ),
        showAxisLine: false,
      ),
      defaultRenderer: new charts.LineRendererConfig(),
      customSeriesRenderers: [
        new charts.PointRendererConfig(
            customRendererId: 'customPoint')
      ],
      // Optionally pass in a [DateTimeFactory] used by the chart. The factory
      // should create the same type of [DateTime] as the data provided. If none
      // specified, the default creates local date time.
      dateTimeFactory: const charts.LocalDateTimeFactory(),
    );
  }
}
