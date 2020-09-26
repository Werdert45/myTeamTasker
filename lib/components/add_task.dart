import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:provider/provider.dart';


class AddTask extends StatefulWidget {

  @override
  _AddTaskState createState() => _AddTaskState();
}

class _AddTaskState extends State<AddTask> {
  @override
  final Streams streams = Streams();

  bool isShowSticker;
  var categories;
  TimeOfDay _time = null;
  DateTime _dateTime = DateTime.now();
  var shared = false;
  var repeated = false;
  String dropdownValue = 'Ian Ronk';
  List days = ['MON','TUE','WED','THU','FRI','SAT','SUN'];
  Map months_in_year = {1: "Jan", 2: "Feb", 3: "Mar", 4: "Apr", 5: "May", 6: "Jun", 7: "Jul", 8: "Aug", 9: "Sep", 10: "Okt", 11: "Nov", 12: "Dec"};
  var days_show = [false, false, false, false, false, false, false];

  var _titleController;
  var _descriptionController;

  String _title = "";
  String _description = "";

  final DatabaseService database = DatabaseService();

  bool brightness = false;

  void initState() {
    super.initState();
    isShowSticker = false;
    categories = Emoji(name: 'Sailboat', emoji: '👑');
    _dateTime = DateTime.now();
    _time = null;

    getDarkModeSetting().then((val) {
      brightness = val;
    });
  }

  Future<Null> selectDate(BuildContext context) async {
    var picked = await showDatePicker(context: context, initialDate: DateTime.now(), firstDate: DateTime.now(), lastDate: DateTime(2100));
    if (picked != null && picked != _dateTime) {
      setState(() {
        _dateTime = picked;
      });
    }
  }

  Future<Null> selectTime(BuildContext context) async {
    var picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  Future<bool> onBackPress() {
    if (isShowSticker) {
      setState(() {
        isShowSticker = false;
      });
    } else {
      Navigator.pop(context);
    }

    return Future.value(false);
  }


  // Improve addTaskDB to also save to either group or personal + title not working
  addTaskDB(repeated, shared, taskID, alertTime, assignee, puid, days_show, icon, title, date, group_code, group_name, description) async {


    if (repeated) {
      await database.addRepeatedTask(taskID, puid, group_code, shared);
      await database.createRepeatedTask(taskID, alertTime, puid, puid, days_show, icon, title, shared, group_code, group_name, description);
    }
    else {
      await database.addSingleTask(taskID, puid, group_code, shared);
      await database.createSingleTask(taskID, alertTime, date, icon, assignee, title, puid, shared, group_code, group_name, description);
    }
  }

  Widget build(BuildContext context) {

    var user = Provider.of<User>(context);
    var color = brightness ? darkmodeColor : lightmodeColor;

    return Hero(
        child: Scaffold(
//          appBar: AppBar(
//            centerTitle: true,
//            title: Text("Add Task"),
//            actions: [
//              FutureBuilder(
//                future: streams.getCompleteUser(user.uid),
//                builder: (context, snapshot) {
//                  print(snapshot.data);
//
//                  return IconButton(
//                    icon: Icon(Icons.check, size: 30),
//                    onPressed: () async {
//                      var puid = user.uid;
//                      var icon = categories.toString().substring(categories.toString().length - 2,categories.toString().length);
//                      var alertTime = _time.hour.toString() + ":" + _time.minute.toString();
//                      var taskID = user.uid + DateTime.now().millisecondsSinceEpoch.toString();
//                      var title = _title;
//                      var date = _dateTime.millisecondsSinceEpoch;
//                      var group_code = snapshot.data.groups[0].code;
//                      var group_name = snapshot.data.groups[0].name;
//
//                      addTaskDB(repeated, shared, taskID, alertTime, puid, puid, days_show, icon, title, date, group_code, group_name);
//
//                      // Not the correct navigator
//                      Navigator.pop(context);
//                      setState(() {});
//                    },
//                  );
//                }
//              )
//            ],
//          ),
          body: SafeArea(
            child: Form(
              child: Container(
                height: MediaQuery.of(context).size.height - 20,
                width: MediaQuery.of(context).size.width,
                child: Stack(
                  children: [
                    Positioned(
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back_ios, size: 24),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 40),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(height: 20),
//                          Text("TITLE", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("TITLE", style: TextStyle(fontSize: 16, color: Colors.grey)),
                              Text("ICON", style: TextStyle(fontSize: 16, color: Colors.grey)),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width - 100,
                                  child: TextFormField(
                                    controller: _titleController,
                                    validator: (val) => val.isEmpty ? 'Enter an email' : null,
                                    onChanged: (val) {
                                      setState(() => _title = val);
                                      print(_title);
                                    },
                                    textCapitalization: TextCapitalization.none,
                                    decoration: InputDecoration(
//                                contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 15),
//                            labelText: "Task Title",
                                      prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                                      focusColor: color['textFieldFillColor'],
                                      fillColor: color['textFieldFillColor'],
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
                                      hintText: 'Title',
                                    ),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        child: buildInput("t", 40.0)
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          Text("DESCRIPTION", style: TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 5),
                          TextFormField(
                            controller: _descriptionController,
                            minLines: 4,
                            maxLines: 4,
                            validator: (val) => val.isEmpty ? 'No description provided' : null,
                            onChanged: (val) {
                              setState(() => _description = val);
                            },
                            textCapitalization: TextCapitalization.none,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 15),
//                            labelText: "Task Title",
                                prefixStyle: TextStyle(color: Colors.white.withOpacity(0)),
                                focusColor: color['textFieldFillColor'],
                                fillColor: color['textFieldFillColor'],
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
                                hintText: 'Write down a small description'
                            ),
                          ),
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text("TYPE", style: TextStyle(fontSize: 16, color: Colors.grey)),
//                                SizedBox(height: 5),
                                  Row(
                                    children: [
                                      Text("Personal"),
                                      Switch(
                                        activeColor: Colors.grey,
                                        onChanged: (bool value) {
                                          setState(() {
                                            shared = !shared;
//                                          if (repeated) {
//                                            days_show = [false, false, false, false, false, false, false];
//                                          }
//                                          else {
//                                            days_show = null;
//                                          }
                                          });

                                        },
                                        value: shared,
                                      ),
                                      Text("Group")
                                    ],
                                  )
                                ],
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("ALERT", style: TextStyle(fontSize: 16, color: Colors.grey)),
                                  SizedBox(height: 10),
                                  GestureDetector(
                                    onTap: () {
                                      selectTime(context);
                                    },
                                    child: Text(_time != null ? _time.hour.toString() + ":" + _time.minute.toString() : "Select", style: TextStyle(fontSize: 18)),
                                  ),
                                ],
                              )
                            ],
                          ),
                          SizedBox(height: 10),
                          DefaultTabController(
                            length: 2,
                            child: Column(
                              children: [
                                TabBar(
                                  onTap: (index) {
                                    if (index == 0) {
                                      setState(() {
                                        repeated = false;
                                      });
                                    }
                                    else {
                                      setState(() {
                                        repeated = true;
                                      });
                                    }
                                  },
                                  labelColor: color['mainTextColor'],
                                  tabs: [
                                    Tab(text: "SINGLE TASK"),
                                    Tab(text: "REPEATED TASK")
                                  ],
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 180,
                                  child: TabBarView(
                                    children: [
                                      singleTask(),
                                      repeatedTask(color)
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 10,
                      left: 15,
                      child: FutureBuilder(
                          future: streams.getCompleteUser(user.uid),
                          builder: (context, snapshot) {

                            return RaisedButton(
                              color: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
//                                      side: BorderSide(color: Colors.green)
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width - 60,
                                height: 50,
                                child: Center(
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.add, color: Colors.white),
                                        SizedBox(width: 5),
                                        Text("ADD TASK", style: TextStyle(color: Colors.white, fontSize: 18))
                                      ],
                                    )
                                ),
                              ),
                              onPressed: () async {
                                var puid = user.uid;
                                var icon = categories.toString().substring(categories.toString().length - 2,categories.toString().length);
                                var alertTime = _time.hour.toString() + ":" + _time.minute.toString();
                                var taskID = user.uid + DateTime.now().millisecondsSinceEpoch.toString();
                                var title = _title;
                                var description = _description;
                                var date = _dateTime.millisecondsSinceEpoch;

                                var group_code = snapshot.data.groups[0].code;
                                var group_name = snapshot.data.groups[0].name;

                                addTaskDB(repeated, shared, taskID, alertTime, puid, puid, days_show, icon, title, date, group_code, group_name, description);

                                // Not the correct navigator
                                Navigator.pop(context);
                                setState(() {});
                              },
                            );
                          }
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      child: (isShowSticker ? buildSticker() : Container()),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
        tag: "add_task"
    );
  }

  Widget singleTask() {
    return Container(
      height: 180,
      width: MediaQuery.of(context).size.width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("SELECT DATE", style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 15),
              GestureDetector(
                child: Text(_dateTime.day.toString() + " / " + months_in_year[_dateTime.month - 1] + " / " + _dateTime.year.toString(), style: TextStyle(fontSize: 18)),
                onTap: () {
                  selectDate(context);
                },
              )
            ],
          ),
//          Column(
//            crossAxisAlignment: CrossAxisAlignment.start,
//            children: [
//              SizedBox(height: 20),
//              Text("ASSIGN TO", style: TextStyle(fontSize: 16, color: Colors.grey)),
//              Container(
////                height: 100,
//                child: DropdownButton<String>(
//                  value: dropdownValue,
//                  icon: Icon(Icons.keyboard_arrow_down),
//                  iconSize: 24,
//                  elevation: 16,
//                  style: TextStyle(color: Colors.deepPurple),
//                  onChanged: shared ? (String newValue) {
//                    setState(() {
//                      dropdownValue = newValue;
//                    });
//                  } : null,
//                  disabledHint: Text("SET TASK TO GROUP"),
//                  items: <String>['Ian Ronk', 'Iantje de Tweede', 'Meneertje 3']
//                      .map<DropdownMenuItem<String>>((String value) {
//                    return DropdownMenuItem<String>(
//                      value: value,
//                      child: Text(value),
//                    );
//                  }).toList(),
//                ),
//              )
//            ],
//          )
        ],
      ),
    );
  }

  Widget repeatedTask(color) {
    return Container(
      height: 210,
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 20),
              Text("SELECT DAYS", style: TextStyle(fontSize: 16, color: Colors.grey)),
              SizedBox(height: 5),
              Container(
                  height: MediaQuery.of(context).size.width / 9,
                  width: double.infinity,
                  child: ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: days_show.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 120),
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              days_show[index] = !days_show[index];
                            });
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width / 9,
                            height: MediaQuery.of(context).size.width / 9,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: days_show[index] ? color['selectedColor'] : color['unselectedColor'],
                            ),
                            child: Center(child: Text(days[index].substring(0,1))),
                          ),
                        ),
                      );
                    },
                  )
              ),
            ],
          ),
          SizedBox(height: 25),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 5),
//              Text("ASSIGN TO", style: TextStyle(fontSize: 16, color: Colors.grey)),
//              Container(
//                child: DropdownButton<String>(
//                  value: dropdownValue,
//                  icon: Icon(Icons.keyboard_arrow_down),
//                  iconSize: 24,
//                  elevation: 16,
//                  style: TextStyle(color: Colors.deepPurple),
//                  onChanged: shared ? (String newValue) {
//                    setState(() {
//                      dropdownValue = newValue;
//                    });
//                  } : null,
//                  disabledHint: Text("SET TASK TO GROUP"),
//                  items: <String>['Ian Ronk', 'Iantje de Tweede', 'Meneertje 3']
//                      .map<DropdownMenuItem<String>>((String value) {
//                    return DropdownMenuItem<String>(
//                      value: value,
//                      child: Text(value),
//                    );
//                  }).toList(),
//                ),
//              )
            ],
          )
        ],
      ),
    );
  }

  Widget buildInput(initialIcon, size) {
    return Container(
      width: size,
      height: size + 20,
      child: Material(
        child: new Container(
          margin: new EdgeInsets.symmetric(horizontal: 1.0),
          child: GestureDetector(
              onTap: () {
                setState(() {
                  isShowSticker = !isShowSticker;
                });
              },
              child: categories == null ? initialIcon : Text(categories.toString().substring(categories.toString().length - 2,categories.toString().length), style: TextStyle(fontSize: size))
          ),
        ),
      ),
    );
  }

  Widget buildSticker() {
    return EmojiPicker(
      rows: 3,
      columns: 7,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["dog", "boat"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        setState(() {
          categories = emoji;
        });
      },
    );
  }
}
