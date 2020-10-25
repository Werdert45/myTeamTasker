import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectGroupPage extends StatefulWidget {

  @override
  _SelectGroupPageState createState() => _SelectGroupPageState();
}

class _SelectGroupPageState extends State<SelectGroupPage> {

  final AuthService _auth = AuthService();
  final DatabaseService database = DatabaseService();

  TextEditingController _controller;

  var _group_code;

  bool brightness = false;


  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _group_code = "";

    _controller = new TextEditingController();

    getDarkModeSetting().then((val) {
      brightness = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    getDarkModeSetting().then((val) {
      brightness = val;
    });

    var color = brightness ? darkmodeColor : lightmodeColor;

    
    return new Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          child: Stack(
            children: [
              Positioned(
                left: -60,
                top: MediaQuery.of(context).size.height / 4.5 - 60,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          color: color['secondaryColor'],
                          borderRadius: BorderRadius.circular(60.0)),
                      child: SizedBox()
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height / 4.5,
                    color: color['primaryColor'],
                    child: Center(
                        child: Text("\n\nSELECT OR\nJOIN A GROUP", style: TextStyle(fontSize: 30, color: color['mainTextColor'],
                            fontWeight: FontWeight.w400), textAlign: TextAlign.center)
                    )
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Text("JOIN A GROUP", style: TextStyle(color: color['primaryColor'])),
                    SizedBox(height: 30),

                    // The error for iOS is in here
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          controller: _controller,
                          onChanged: (val) {
                            setState(() => _group_code = val);
                          },
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                              prefixText: "df",
                              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                              focusColor: color['secondaryColor'],
                              fillColor: color['secondaryColor'],
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: color['secondaryColor'], width: 2)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: color['secondaryColor'], width: 2)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: color['secondaryColor'], width: 2)
                              ),
                              hintText: 'ENTER CODE'
                          ),
                        )
                    ),
                    SizedBox(height: 20),
                    RaisedButton(
                        onPressed: () {
                          database.addToGroup(user.uid, _group_code, "Ian Ronk");
                          Navigator.popAndPushNamed(context, '/homepage');
                        },
                        textColor: color['mainTextColor'],
                        padding: EdgeInsets.symmetric(horizontal: 310/2, vertical: 30/2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(310/2),
                          side: BorderSide(color: color['secondaryColor'], width: 2),
                        ),
                        color: color['secondaryColor'],
                        child: Container(
                            child: Text("JOIN", style: TextStyle(fontSize: 20))
                        )
                    ),
                    SizedBox(height: 30),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 1,
                            color: Colors.grey,
                          ),
                          Text("Or"),
                          Container(
                            width: MediaQuery.of(context).size.width / 3,
                            height: 1,
                            color: Colors.grey,
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 50),
                    GestureDetector(
                      onTap: () {
                        Navigator.popAndPushNamed(context, '/creategroup');
                      },
                      child: Text("CREATE A GROUP", style: TextStyle(fontSize: 24, color: color['primaryColor'])),
                    )
                  ],
                ),
              ),
              Positioned(
                right: -60,
                top: -60,
                child: Opacity(
                  opacity: 0.8,
                  child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                          color: color['secondaryColor'],
                          borderRadius: BorderRadius.circular(60.0)),
                      child: SizedBox()
                  ),
                ),
              ),
              Positioned(
                left: -60,
                bottom: -30,
                child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: color['secondaryColor'],
                        borderRadius: BorderRadius.circular(60.0)),
                    child: SizedBox()
                ),
              ),
            ],
          ),
        )
    );
  }
}
