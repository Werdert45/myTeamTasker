import 'package:collaborative_repitition/notifications_lib/store/RemindersState.dart';
import 'package:flutter/material.dart';

@immutable
class AppState {
  final RemindersState remindersState;

  AppState({@required this.remindersState});

  factory AppState.initial() {
    return AppState(
      remindersState: RemindersState.initial(),
    );
  }

  dynamic toJson() {
    return {'remindersState': this.remindersState.toJson()};
  }

  static AppState fromJson(dynamic json) {
    return json != null
        ? AppState(
            remindersState: RemindersState.fromJson(json["remindersState"]))
        : {};
  }

  AppState copyWith({RemindersState remindersState}) {
    return AppState(remindersState: remindersState ?? this.remindersState);
  }
}
