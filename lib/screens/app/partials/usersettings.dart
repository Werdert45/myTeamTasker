import 'package:flutter/material.dart';

class UserSettings extends StatefulWidget {
  final name;
  final email;


  UserSettings(this.name, this.email);

  @override
  _UserSettingsState createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  var _controller;
  var _controller_email;
  var _controller_pwd = new TextEditingController(text: "Password");
  var name;
  var email;
  var password;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    var _controller = new TextEditingController(text: widget.name);
    var _controller_email = new TextEditingController(text: widget.email);
  }

  @override
  Widget build(BuildContext context) {
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
              controller: _controller,
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
          Text("Email"),
          Container(
            width: double.infinity,
            child: TextField(
              autofocus: false,
              onChanged: (val) {
                setState(() => email = val);
              },
              controller: _controller_email,
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
