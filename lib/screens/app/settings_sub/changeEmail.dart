import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ChangeEmail extends StatefulWidget {
  final email;

  ChangeEmail({
    @required this.email
  });

  @override

  _ChangeEmailState createState() => _ChangeEmailState();
}

class _ChangeEmailState extends State<ChangeEmail> {


  final UserManagement userManagement = new UserManagement();
  final DatabaseService database = DatabaseService();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _currentController;
  var _email = "";

  TextEditingController _passwordController;
  var _password = "";
  bool _showPassword = false;

  bool _completed = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var uid = Provider.of<User>(context).uid;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 12),
                  child: GestureDetector(
                    onTap: () {Navigator.pop(context);},
                    child: Icon(Icons.arrow_back_ios),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(top: 10),
                  child: Text("Change Email", style: TextStyle(fontSize: 24)),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 15, top: 12),
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        var credential = EmailAuthProvider.getCredential(email: widget.email, password: _password);

                        final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;

                        // Set email in auth
                        await userManagement.updateEmail(_email);

                        // Add the email to the database as change
                        await database.updateEmail(_email, uid);


                        setState(() {
                          _completed = true;
                        });
                      } catch (e) {
                        print(e);
                        return e;
                      }

                    },
                    child: Icon(Icons.edit, size: 30, color: confirmColor),
                  ),
                ),
              ),
              Positioned(
                top: 60,
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width - 40,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("NEW EMAIL", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: _currentController,
                          validator: (val) => val.isEmpty ? 'No description provided' : null,
                          onChanged: (val) {
                            setState(() => _email = val);
                          },
                          textCapitalization: TextCapitalization.none,
                          decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                            labelText: "Task Title",
                              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                              focusColor: primaryColor,
                              fillColor: Color(0xFFE0E0E0),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                              ),
                              hintText: "New email address"
                          ),
                        ),
                        SizedBox(height: 50),
                        Text("PASSWORD", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5),
                        TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          controller: _passwordController,
                          validator: (val) => val.isEmpty ? 'No description provided' : null,
                          onChanged: (val) {
                            setState(() => _password = val);
                          },
                          textCapitalization: TextCapitalization.none,
                          obscureText: _showPassword ? false : true,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _showPassword ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _showPassword = !_showPassword;
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                            labelText: "Task Title",
                              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                              focusColor: primaryColor,
                              fillColor: Color(0xFFE0E0E0),
                              filled: true,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                              ),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Color(0xFFE0E0E0), width: 2)
                              ),
                              hintText: "To make sure it is really you"
                          ),
                        ),
                        SizedBox(height: 40),
                        _completed ? Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 50,
                          decoration: BoxDecoration(
                            color: confirmColor,
                            borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(
                            child: Text("Succesfully changed email"),
                          ),
                        ) : SizedBox()
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
