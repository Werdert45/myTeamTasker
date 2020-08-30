import 'package:collaborative_repitition/components/button.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  // Variables for user information
  String _email = '';
  String _password = '';
  String _error = '';




  @override
  Widget build(BuildContext context) {

    _signInAction() async {
      if (_formKey.currentState.validate()) {
        dynamic result = await _auth.signInWithEmail(_email, _password);
        Navigator.pop(context);

        if (result == null) {
          setState(() => _error = 'No user found with this email');
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
                        child: Text("\n\nLOGIN", style: TextStyle(fontSize: 34, color: mainTextColor,
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
                      SizedBox(height: 100),

                      Padding(
                        padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'Enter an email' : null,
                            onChanged: (val) {
                              setState(() => _email = val);
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
                                hintText: 'Enter Email'
                            ),
                          )
                      ),
                      SizedBox(height: 20),
                      Padding(
                          padding: EdgeInsets.only(left: 20, right: 20),
                          child: TextFormField(
                            validator: (val) => val.isEmpty ? 'A password must have 6+ characters' : null,
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
                      primaryRoundButton(primaryColor, mainTextColor, "LOG IN", _signInAction, 310, 30),
                      SizedBox(height: 20),
                      GestureDetector(
                        onTap: () {
                          Navigator.popAndPushNamed(context, '/signup');
                        },
                        child: Text("Don't have an account? Sign up here", style: TextStyle(color: primaryColor, fontSize: 10))
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
