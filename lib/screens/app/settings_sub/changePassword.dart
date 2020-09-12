import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:collaborative_repitition/services/usermanagement.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class ChangePassword extends StatefulWidget {
  final email;

  ChangePassword({
    @required this.email
  });

  @override

  _ChangePasswordState createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {


  final UserManagement userManagement = new UserManagement();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController _currentController;
  var _currentPwd = "";
  bool _showCurrent = false;

  TextEditingController _newController;
  var _newPwd = "";
  bool _showNew = false;

  TextEditingController _repeatController;
  var _repeatPwd = "";
  bool _showRepeat = false;

  bool _completed = false;

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
  Widget build(BuildContext context) {
    getDarkModeSetting().then((val) {
      brightness = val;
    });
    

    var color = brightness ? darkmodeColor : lightmodeColor;

    
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
                  child: Text("Change Password", style: TextStyle(fontSize: 24)),
                ),
              ),
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: EdgeInsets.only(right: 15, top: 12),
                  child: GestureDetector(
                    onTap: () async {
                      try {
                        var credential = EmailAuthProvider.getCredential(email: widget.email, password: _currentPwd);

                        final FirebaseUser user = (await _auth.signInWithCredential(credential)).user;
                      } catch (e) {
                        print(e);
                        return e;
                      }

                      if (_newPwd == _repeatPwd) {

                        await userManagement.updatePassword(_newPwd);
                      }
                      // Save the password, if the conditions apply
                    },
                    child: Icon(Icons.edit, size: 30, color: color['confirmColor']),
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
                        Text("CURRENT PASSWORD", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: _currentController,
                          validator: (val) => val.isEmpty ? 'No description provided' : null,
                          onChanged: (val) {
                            setState(() => _currentPwd = val);
                          },
                          textCapitalization: TextCapitalization.none,
                          obscureText: _showCurrent ? false : true,
                          decoration: InputDecoration(
                            suffixIcon: IconButton(
                                icon: _showCurrent ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                              onPressed: () {
                                  setState(() {
                                    _showCurrent = !_showCurrent;
                                  });
                              },
                            ),
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                            labelText: "Task Title",
                              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                              focusColor: color['primaryColor'],
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
                              hintText: "Let's check if it is you"
                          ),
                        ),
                        SizedBox(height: 60),
                        Text("NEW PASSWORD", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: _newController,
                          validator: (val) => val.isEmpty ? 'No description provided' : null,
                          onChanged: (val) {
                            setState(() => _newPwd = val);
                          },
                          textCapitalization: TextCapitalization.none,
                          obscureText: _showNew ? false : true,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _showNew ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _showNew = !_showNew;
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                            labelText: "Task Title",
                              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                              focusColor: color['primaryColor'],
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
                              hintText: 'Your new password'
                          ),
                        ),
                        SizedBox(height: 20),
                        Text("REPEATED PASSWORD", style: TextStyle(fontSize: 16, color: Colors.grey)),
                        SizedBox(height: 5),
                        TextFormField(
                          controller: _repeatController,
                          validator: (val) => val.isEmpty ? 'No description provided' : null,
                          onChanged: (val) {
                            setState(() => _repeatPwd = val);
                          },
                          textCapitalization: TextCapitalization.none,
                          obscureText: _showRepeat ? false : true,
                          decoration: InputDecoration(
                              suffixIcon: IconButton(
                                icon: _showRepeat ? Icon(Icons.visibility) : Icon(Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    _showRepeat = !_showRepeat;
                                  });
                                },
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                            labelText: "Task Title",
                              prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                              focusColor: color['primaryColor'],
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
                              hintText: 'Repeat your new password'
                          ),
                        ),
                        SizedBox(height: 40),
                        _completed ? Container(
                          width: MediaQuery.of(context).size.width - 40,
                          height: 50,
                          decoration: BoxDecoration(
                              color: color['confirmColor'],
                              borderRadius: BorderRadius.all(Radius.circular(8))
                          ),
                          child: Center(
                            child: Text("Succesfully changed password"),
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
