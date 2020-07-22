import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 150,
          height: 150,
          child: Stack(
              children: [
                Container(
                  width: 150,
                  height: 150,
                  child: Align(
                      alignment: Alignment.center,
                      heightFactor: 0.5,
                      widthFactor: 1,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          image: DecorationImage(
                              image: FirebaseImage('gs://collaborative-repetition.appspot.com/' + snapshot.data.profile_picture.toString(),
                              ), fit: BoxFit.cover
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(110.0)),
                        ),
                      )
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: IconButton(
                    icon: Icon(Icons.add_circle, size: 40),
                    onPressed: () {
                    },
                  ),
                ),
              ]
          ),
        ),
        SizedBox(height: 20),
        Container(
          width: 200,
          child: TextField(
            enabled: false,
            autofocus: false,
            onChanged: (val) {
              setState(() => name = val);
            },
            controller: _controller,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
              labelText: "Name",
              prefixText: "df",
              labelStyle: TextStyle(color: Colors.grey),
              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
              focusColor: Color(0xFF572f8c),
              fillColor: Color(0xFF572f8c),
              disabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Color(0xFF572f8c), width: 2)
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Color(0xFF572f8c), width: 2)
              ),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Color(0xFF572f8c), width: 2)
              ),
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(50),
                  borderSide: BorderSide(color: Color(0xFF572f8c), width: 2)
              ),
            ),
          ),
        ),
      ],
    );
  }
}
