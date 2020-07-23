import 'package:flutter/material.dart';
// Prim: primaryColor
// Second: secondaryColor


Widget checkbox(size, primaryColor, secondaryColor, checked) {
  var boxdec;

  if (checked) {
    boxdec = BoxDecoration(
        color: Colors.grey,
        border: Border.all(width: 3, color: Colors.blueGrey),
        borderRadius: new BorderRadius.all(
            Radius.circular(10)
        )
    );
  }

  else {
    boxdec = BoxDecoration(
//        color: Colors.grey,
        border: Border.all(width: 3, color: Colors.blueGrey),
        borderRadius: new BorderRadius.all(
            Radius.circular(7.5)
        )
    );
  }

  return Container(
      width: size,
      height: size,
      decoration: boxdec
  );
}


Widget primaryRoundButton(primaryColor, secondaryColor, buttonText, function, width, height) {
  return RaisedButton(
      onPressed: function,
      textColor: secondaryColor,
      padding: EdgeInsets.symmetric(horizontal: width/2, vertical: height/2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width/2),
      ),
      color: primaryColor,
      child: Container(
          child: Text(buttonText, style: TextStyle(fontSize: 20))
      )
  );
}


Widget secondaryRoundButton(primaryColor, secondaryColor, buttonText, function, width, height) {
  return RaisedButton(
      onPressed: () {
        function;
      },
      textColor: primaryColor,
      padding: EdgeInsets.symmetric(horizontal: width/2, vertical: height/2),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(width/2),
        side: BorderSide(color: primaryColor, width: 2),
      ),
      color: secondaryColor,
      child: Container(
          child: Text(buttonText, style: TextStyle(fontSize: 20))
      )
  );
}

Widget thirdRoundButton(primaryColor, secondaryColor, buttonText, function) {
  return RaisedButton(
      onPressed: () {
        function;
      },
      textColor: primaryColor,
      padding: EdgeInsets.symmetric(horizontal: 80, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
      ),
      color: secondaryColor,
      child: Container(
          child: Text(buttonText, style: TextStyle(fontSize: 20))
      )
  );
}


Widget RoundButton(size, icon, color) {
  return Container(
    height: size,
    width: size,
    decoration: BoxDecoration(
        border: Border.all(
          color: color,
        ),
        borderRadius: BorderRadius.all(Radius.circular(size))
    ),
    child: Icon(icon, color: color),
  );
}