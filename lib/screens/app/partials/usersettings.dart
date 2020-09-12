import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class UserSettings extends StatefulWidget {
  final name;
  final email;


  UserSettings(this.name, this.email);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  var _controller_pwd = new TextEditingController(text: "Password");
  var name;
  var email;
  var password;
  bool brightness = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDarkModeSetting().then((val) {
      brightness = val;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var controller = new TextEditingController(text: widget.name);
    var controller_email = new TextEditingController(text: widget.email);

    getDarkModeSetting().then((val) {
      brightness = val;
    });

    var color = brightness ? darkmodeColor : lightmodeColor;

    

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text("Name"),
          Container(
            width: double.infinity,
            child: TextField(
              autofocus: false,
              onChanged: (val) {
                setState(() => name = val);
              },
              controller: controller,
              decoration: InputDecoration(
//                labelText: "Name",
                labelStyle: TextStyle(color: Colors.grey),
                prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                focusColor: color['primaryColor'],
                fillColor: color['primaryColor'],

              ),
            ),
          ),
          SizedBox(height: 30),
          Text("Email"),
          Container(
            width: double.infinity,
            child: TextField(
              autofocus: false,
              onChanged: (val) {
                setState(() => email = val);
              },
              controller: controller_email,
              decoration: InputDecoration(
//                labelText: "Name",
                labelStyle: TextStyle(color: Colors.grey),
                prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                focusColor: Color(0xFF572f8c),
                fillColor: Color(0xFF572f8c),

              ),
            ),
          ),
          SizedBox(height: 30),
          Text("Password"),
          Container(
            width: double.infinity,
            child: TextField(
              autofocus: false,
              onChanged: (val) {
                setState(() => password = val);
              },
              controller: _controller_pwd,
              obscureText: true,
              decoration: InputDecoration(
//                labelText: "Name",
                labelStyle: TextStyle(color: Colors.grey),
                prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                focusColor: Color(0xFF572f8c),
                fillColor: Color(0xFF572f8c),

              ),
            ),
          ),
        ],
      ),
    );
  }
}
