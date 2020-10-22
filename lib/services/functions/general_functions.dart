import 'package:flutter/material.dart';

int getIndexNestedList(List list, string) {
  for (int i = 0; i < list.length; i++) {
    if (list[i][0] == string) {
      return i;
    };
  }
}