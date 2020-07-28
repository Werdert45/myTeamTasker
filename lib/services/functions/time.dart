import 'package:flutter/material.dart';

TimeOfDay parsedAlertTime(alert_time) {
  var parsed_list = alert_time.split(':');

  return TimeOfDay(hour: int.parse(parsed_list[0]), minute: int.parse(parsed_list[1]));
}