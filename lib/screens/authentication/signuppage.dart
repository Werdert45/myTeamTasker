import 'package:collaborative_repitition/components/button.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/screens/authentication/selectprofpic.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _name = '';
  String _email = '';
  String _password = '';
  String _error = '';


  @override
  Widget build(BuildContext context) {

    _signUpAction() async {
      if (_formKey.currentState.validate()) {
        dynamic result = await _auth.registerWithEmail(_email, _password, _name);
        if (result == null) {
          setState(() => _error = 'please supply a valid email');
        }
        else {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectprofilepicPage(_name)));
        }
      }
    }

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
                          color: secondaryColor,
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
                    color: primaryColor,
                    child: Center(
                        child: Text("\n\nSIGN UP", style: TextStyle(fontSize: 34, color: mainTextColor,
                            fontWeight: FontWeight.w400), textAlign: TextAlign.center)
                    )
                ),
              ),
              Positioned(
                  top: 30,
                  left: 10,
                  child: IconButton(
                      icon: Icon(Icons.arrow_back, size: 25, color: Colors.white),
                      onPressed: () { Navigator.pop(context); }
                  )
              ),
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(height: 130),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Enter your name' : null,
                            onChanged: (val) {
                              setState(() => _name = val);
                            },
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              prefixText: "df",
                                prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                                focusColor: primaryColor,
                                fillColor: primaryColor,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: primaryColor, width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: primaryColor, width: 2)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: primaryColor, width: 2)
                                ),
                                hintText: 'Enter your Name'
                            ),
                          )
                      ),
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Enter your email' : null,
                            onChanged: (val) {
                              setState(() => _email = val);
                            },
                            textCapitalization: TextCapitalization.sentences,
                            decoration: InputDecoration(
                                prefixText: "df",
                                prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                                focusColor: primaryColor,
                                fillColor: primaryColor,
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: primaryColor, width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: primaryColor, width: 2)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(50),
                                    borderSide: BorderSide(color: primaryColor, width: 2)
                                ),
                                hintText: 'Enter Email'
                            ),
                          )
                      ),
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Enter your name' : null,
                            onChanged: (val) {
                              setState(() => _password = val);
                            },
                            obscureText: true,
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                              prefixText: "df",
                              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                              focusColor: primaryColor,
                              fillColor: primaryColor,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: primaryColor, width: 2)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: primaryColor, width: 2)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50),
                                  borderSide: BorderSide(color: primaryColor, width: 2)
                              ),
                              hintText: '*********',
                            ),
                          )
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: 25),
                        child: Container(
                          height: 6,
                          width: 30,
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(3.0)
                          ),
                          child: SizedBox(),
                        ),
                      ),
                      primaryRoundButton(primaryColor, mainTextColor, "SIGN UP", _signUpAction, 310, 30),
                      SizedBox(height: 15),
                      GestureDetector(
                          onTap: () {
//                            Navigator.pop(context);
                            Navigator.popAndPushNamed(context, '/login');
                          },
                          child: Text("Already have an account? Log in here", style: TextStyle(color: primaryColor, fontSize: 10))
                      )
                    ],
                  ),
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
                          color: secondaryColor,
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
                        color: secondaryColor,
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
