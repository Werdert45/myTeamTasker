import 'package:collaborative_repitition/components/button.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class CreateGroupPage extends StatefulWidget {
  @override
  _CreateGroupPageState createState() => _CreateGroupPageState();
}

class _CreateGroupPageState extends State<CreateGroupPage> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String _group_name = '';
  String _group_description = '';
  String error = '';


  @override
  Widget build(BuildContext context) {

    var user = Provider.of<User>(context);


    createGroup(uid, group_name, group_description) async {
      try {
        var check = await DatabaseService(uid: uid).createGroup(uid, group_name, group_description);
      } catch (e) {
        return e;
      }
    }

    return new Scaffold(
//        resizeToAvoidBottomPadding: false,
        body: SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height / 4.5,
                      color: Color(0xFF572f8c),
                      child: Center(
                          child: Text("\n\nCREATE GROUP", style: TextStyle(fontSize: 30, color: Color(0xFFc6bed2),
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
                Positioned(
                    top: 45,
                    right: 20,
                    child: GestureDetector(
                      onTap: () {
                        createGroup(user.uid, _group_name, _group_description);
                      },
                      child: Text("CREATE", style: TextStyle(fontSize: 16, color: Color(0xFFc6bed2))),
                    )
                ),
                Form(
                  key: _formKey,
                  child: Center(
                    child: Padding(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: (MediaQuery.of(context).size.height / 4.5)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 30),
                          Text("Group name", style: TextStyle(fontSize: 14, color: Color(0xFFc6bed2))),
                          SizedBox(height: 5),
                          Padding(
                              padding: EdgeInsets.only(left: 0),
                              child: TextFormField(
                                  onChanged: (val) {
                                    setState(() => _group_name = val);
                                  },
                                style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                                textCapitalization: TextCapitalization.none,
                                decoration: InputDecoration(
                                    contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                    prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                                    focusColor: Color(0xFFc6bed2),
                                    fillColor: Color(0xFFc6bed2),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8),
                                        borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                                    ),
                                    hintText: 'Enter group name'
                                ),
                              )
                          ),
                          SizedBox(height: 30),
                          Text("Description", style: TextStyle(fontSize: 14, color: Color(0xFFc6bed2))),
                          SizedBox(height: 5),
                          TextFormField(
                            onChanged: (val) {
                              setState(() => _group_description = val);
                            },
                            minLines: 5,
                            maxLines: 5,
                            style: TextStyle(fontWeight: FontWeight.w300, fontSize: 14),
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                                prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                                focusColor: Color(0xFFc6bed2),
                                fillColor: Color(0xFFc6bed2),
                                enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                                ),
                                focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                                ),
                                border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: BorderSide(color: Color(0xFFc6bed2), width: 2)
                                ),
                                hintText: 'Put down a small description of the group here'
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("TASKS", style: TextStyle(fontSize: 14, color: Color(0xFFc6bed2))),
                          SizedBox(height: 5),
                          Container(height: MediaQuery.of(context).size.height / 4.5, width: double.infinity, color: Colors.red),
                        ],
                      ),
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
          ),
        )
    );
  }
}