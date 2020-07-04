import 'dart:math';

import 'package:flutter/material.dart';

Widget diamond(size, color) {
  return Transform.rotate(
    angle: 45 * pi/180,
    child: Container(
      padding: EdgeInsets.all(size),
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Colors.black
          ),
//          borderRadius: BorderRadius.all(Radius.circular(20))
      ),
      child: SizedBox(height: 0, width: 0),
    ),
  );
}


List<Widget> _diamondCheckPoint(total, done, size, startColor, finalColor) {
  List<Widget> diamonds = [];
  var margin = size / (total);
//  var doneBar = margin * done;


  for (var i = 1; i <= total; i++) {
    if (done < i) {
      diamonds.add(
          Positioned(
            left: margin*i + 20,
            child: diamond(8.0, finalColor),
          )
      );
    }
    else {
      diamonds.add(
          Positioned(
            left: margin*i + 20,
            child: diamond(8.0, startColor),
          )
      );
    }
  }

  return diamonds;
}


Widget progressBar(size, startColor, finalColor, total, done, context) {


  var checkpoints = _diamondCheckPoint(total, done, size, startColor, finalColor);


  var margin = size / (total + 2);
  var doneBar = margin * (done+1) - 10;

  return Container(
    height: 50,
    child: Stack(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: startColor,
                    border: Border.all(
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: SizedBox(width: 0, height: 0)
            ),
            Container(
              width: doneBar,
              height: 5,
              decoration: BoxDecoration(
                color: startColor,
                border: Border.symmetric(
                  horizontal: BorderSide(color: total == done ? startColor : finalColor),
                  vertical: BorderSide(color: Colors.black)
                ),
              ),
              child: SizedBox(),
            ),
            Container(
              width: size - doneBar,
              height: 5,
              decoration: BoxDecoration(
                color: total == done ? startColor : finalColor,
                border: Border.symmetric(
                    horizontal: BorderSide(color: total == done ? startColor : finalColor),
                    vertical: BorderSide(color: Colors.black)
                ),
              ),
              child: SizedBox(),
            ),
            Container(
                width: 15,
                height: 15,
                decoration: BoxDecoration(
                    color: total == done ? startColor : finalColor,
                    border: Border.all(
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(20))
                ),
                child: SizedBox(width: 0, height: 0)
            )
          ],
        ),
        ...checkpoints,

      ],
    ),
  );
}


