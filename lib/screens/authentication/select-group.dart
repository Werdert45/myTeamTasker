import 'package:collaborative_repitition/components/button.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SelectGroupPage extends StatefulWidget {

  @override
  _SelectGroupPageState createState() => _SelectGroupPageState();
}

class _SelectGroupPageState extends State<SelectGroupPage> {

  final AuthService _auth = AuthService();
  final DatabaseService database = DatabaseService();
  final _formkey = GlobalKey<FormState>();

  String _group_code = "";

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

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
                          color: Color(0xFFc6bed2),
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
                    color: Color(0xFF572f8c),
                    child: Center(
                        child: Text("\n\nSELECT OR\nJOIN A GROUP", style: TextStyle(fontSize: 30, color: Color(0xFFc6bed2),
                            fontWeight: FontWeight.w400), textAlign: TextAlign.center)
                    )
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 30),
                    Text("JOIN A GROUP", style: TextStyle(color: Color(0xFF572f8c))),
                    SizedBox(height: 30),
                    Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                        child: TextField(
                          onChanged: (val) {
                            setState(() => _group_code = val);
                          },
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                              prefixText: "df",
                              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                              focusColor: Color(0xFFc6bed2),
                              fillColor: Color(0xFFc6bed2),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                              ),
                              hintText: 'ENTER CODE'
                          ),
                        )
                    ),
                    SizedBox(height: 20),
                    secondaryRoundButton(Color(0xFF572f8c), Colors.white, "JOIN", database.addToGroup(user.uid, _group_code), 310, 30),
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
                      child: Text("CREATE A GROUP", style: TextStyle(fontSize: 24, color: Color(0xFF572f8c))),
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
                          color: Color(0xFFc6bed2),
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
                        color: Color(0xFFc6bed2),
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
