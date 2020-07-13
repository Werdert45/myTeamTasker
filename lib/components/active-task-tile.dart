import 'package:collaborative_repitition/models/complete_user.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'button.dart';

class ActiveTask extends StatefulWidget {
  final task;
  final puid;
  final group;
  final parent;
//
  ActiveTask(this.task, this.puid, this.group, this.parent);


  @override
  ActiveTaskState createState() => new ActiveTaskState();
}

class ActiveTaskState extends State<ActiveTask> {
  TimeOfDay _time = TimeOfDay.now();
  DateTime _dateTime = DateTime.now();
  DatabaseService database = DatabaseService();


  var repeated = false;
  var shared = false;
  var setAlert;
  var task_name;


  // Helper function:
  List days = ['MON','TUE','WED','THU','FRI','SAT','SUN'];
  Map months_in_year = {1: "Jan", 2: "Feb", 3: "Mar", 4: "Apr", 5: "May", 6: "Jun", 7: "Jul", 8: "Aug", 9: "Sep", 10: "Okt", 11: "Nov", 12: "Dec"};
  bool isShowSticker;
  var days_show;
  bool checkedValue = false;
  var expanded = false;
  TextEditingController _controller;

  Emoji categories;

  @override
  void initState() {
    super.initState();

    widget.task.days == null ? repeated = false : repeated = true;

    if (repeated) {
      days_show = widget.task.days;
    }

    widget.task.alert_time != null ? setAlert = true : setAlert = false;
    isShowSticker = false;
    categories = Emoji(name: 'Sailboat', emoji: widget.task.icon);
    checkedValue = widget.task.finished;
    task_name = widget.task.title;
    _controller = new TextEditingController(text: task_name);
    _dateTime = DateTime.now();

    if (widget.task.title == "New Task") {
      expanded = true;
    }

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
      initialTime: _time,
    );

    if (picked != null && picked != _time) {
      setState(() {
        _time = picked;
      });
    }
  }

  updateFinishedStatus(taskID, status) async {
    if (widget.task is repeated_task) {
      await database.updateFinishedStatusRepeated(taskID, status);
    }

    else if (widget.task is single_task) {
      await database.updateFinishedStatusSingle(taskID, status);
    }

    else {
      print('Houston we have a problem');
    }
  }

  updateTaskDB(repeated, title, icon, id, days, init_days, alertTime, puid, date, group, shared, init_shared, init_repeated) async {
    // Remove all from the specific task
    await database.completeReplacementTask(id, group, puid, repeated, shared, init_repeated, init_shared);

    // Check the conditions and add accordingly
    if (repeated && shared) {
      // add to repeated in group
      await database.createRepeatedTask(id, alertTime, puid, puid, days, icon, title, shared);
      await database.addRepeatedTask(id, puid, group, shared);
    }

    else if (repeated && !shared) {
      // add to repeated in user
      await database.createRepeatedTask(id, alertTime, puid, puid, days, icon, title, shared);
      await database.addRepeatedTask(id, puid, group, shared);
    }

    else if (!repeated && shared) {
      // add to single in group
      await database.createSingleTask(id, alertTime, date, icon, puid, title, puid, shared);
      await database.addSingleTask(id, puid, group, shared);
    }

    else if (!repeated && !shared) {
      // add to single in user
      await database.createSingleTask(id, alertTime, date, icon, puid, title, puid, shared);
      await database.addSingleTask(id, puid, group, shared);
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

  @override
  Widget build(BuildContext context) {
    editTask() {
      setState(() {
        expanded = ! expanded;
      });

    }

    saveTask() {
      setState(() {
        expanded = ! expanded;
      });
    }
    var init_days = widget.task.days;



    return Stack(
      children: <Widget>[
        Column(
          children: <Widget>[
            GestureDetector(
              onTap: () {
              },
              child: AnimatedContainer(
                  width: MediaQuery.of(context).size.width - 30,
                  height: expanded ? 400.0 : 60.0,
                  duration: Duration(milliseconds: 500),
                  child: Stack(
                      children: [
                        Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        checkedValue = ! checkedValue;

                                        updateFinishedStatus(widget.task.id, checkedValue);

                                      });
                                    },
                                    child: Container(
                                      height: 30,
                                      width: 30,
                                      decoration: BoxDecoration(
                                          color: checkedValue ? Colors.green : Colors.grey,
                                          border: Border.all(width: 3, color: Colors.blueGrey),
                                          borderRadius: new BorderRadius.all(
                                              Radius.circular(6)
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    SizedBox(height: 15),
                                    Container(
                                        child: buildInput("t", 25.0)
                                    )
                                  ],
                                ),
                                SizedBox(width: 25),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 10),
                                      (task_name != null ? Container(width: 160, child: Text(task_name.length <= 16 ? task_name : task_name.substring(0,13) + "...", style: TextStyle(color: Color(0xFF572f8c), fontSize: 20))) : Text("Loading ...")),
//                      SizedBox(height: 3),
                                      Text("8 AM to 12 AM", style: TextStyle(color: Color(0xFFc6bed2), fontSize: 12))
                                    ]
                                ),
                                FlatButton(
                                  onPressed: editTask,
                                  child: expanded ? GestureDetector(
                                      child: Text("SAVE"),
                                      onTap: () async {
                                        var title = task_name;
                                        var icon = categories.toString().substring(categories.toString().length - 2,categories.toString().length);
                                        var id = widget.task.id;
                                        var alertTime = _time.hour.toString() + ":" + _time.minute.toString();
                                        var puid = widget.puid;
                                        var date = _dateTime.millisecondsSinceEpoch.toString();
                                        var group = widget.group.code;
                                        var init_shared = widget.task.shared;
                                        var init_repeated = widget.task.repeated;

                                        await updateTaskDB(repeated, title, icon, id, days_show, init_days, alertTime, puid, date, group, shared, init_shared, init_repeated);
                                        await saveTask();

//                                  Navigator.pushReplacementNamed(
//                                      context, '/homepage');
                                      }) : Text("EDIT"),
                                )
                              ],
                            ),
                            Container(
                              height: expanded ? 340 : 0,
                              width: MediaQuery.of(context).size.width - 50,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        width: MediaQuery.of(context).size.width / 1.5,
                                        child: TextField(
                                          autofocus: false,
                                          onChanged: (val) {
                                            setState(() => task_name = val);
                                          },
                                          controller: _controller,
                                          decoration: InputDecoration(
                                            hintText: "Task Name",
                                            border: InputBorder.none,
                                            focusedBorder: InputBorder.none,
                                            enabledBorder: InputBorder.none,
                                            errorBorder: InputBorder.none,
                                            disabledBorder: InputBorder.none,
                                          ),
                                        ),
                                      ),
                                      buildInput('t', 25.0)
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  SizedBox(height: 5),
                                  Row(
                                      children: [
                                        Text("Single Time Task"),
                                        Switch(
                                          activeColor: Colors.grey,
                                          onChanged: (bool value) {
                                            setState(() {
                                              repeated = ! repeated;

                                              if (repeated) {
                                                days_show = [false, false, false, false, false, false, false];
                                              }
                                              else {
                                                days_show = null;
                                              }
                                            });

                                          },
                                          value: repeated,
                                        ),
                                        Text("Repeated Task"),
                                      ]
                                  ),
                                  Container(
                                    child: repeated ? Row(
                                      children: [
                                        Column(
                                          children: [
                                            Text("Mon"),
                                            Checkbox(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  days_show[0] = value;
                                                });
                                              },
                                              value: days_show[0],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Tue"),
                                            Checkbox(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  days_show[1] = value;
                                                });
                                              },
                                              value: days_show[1],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Wed"),
                                            Checkbox(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  days_show[2] = value;
                                                });
                                              },
                                              value: days_show[2],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Thu"),
                                            Checkbox(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  days_show[3] = value;
                                                });
                                              },
                                              value: days_show[3],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Fri"),
                                            Checkbox(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  days_show[4] = value;
                                                });
                                              },
                                              value: days_show[4],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Sat"),
                                            Checkbox(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  days_show[5] = value;
                                                });
                                              },
                                              value: days_show[5],
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Text("Sun"),
                                            Checkbox(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  days_show[6] = value;
                                                });
                                              },
                                              value: days_show[6],
                                            ),
                                          ],
                                        )
                                      ],
                                    ) :
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Text("Task date: " + _dateTime.day.toString() + " " + months_in_year[_dateTime.month] + " " + _dateTime.year.toString()),
                                        GestureDetector(
                                          child: Text("EDIT"),
                                          onTap: () {selectDate(context);},
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(right: 20.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Checkbox(
                                              onChanged: (bool value) {
                                                setState(() {
                                                  setAlert = value;
                                                });
                                              },
                                              value: setAlert,
                                            ),
                                            SizedBox(width: 5),
                                            Text("Receive alert:  " + (setAlert ? _time.hour.toString() + ":" + _time.minute.toString() : "")),
                                          ],
                                        ),
                                        GestureDetector(
                                          onTap: () {
                                            selectTime(context);
                                          },
                                          child: Text("EDIT"),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5),
                                  Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                      crossAxisAlignment: CrossAxisAlignment.center,

                                      children: [
                                        Text("Personal Task"),
                                        Switch(
                                          activeColor: Colors.grey,
                                          onChanged: (bool value) {
                                            setState(() {
                                              shared = !shared;
                                            });
                                          },
                                          value: shared,
                                        ),
                                        Text("Shared Task"),
                                      ]
                                  ),
                                  SizedBox(height: 5),
                                  RaisedButton(
                                    onPressed: () {
                                      if (repeated) {
                                        database.removeRepeatedTask(widget.task.id);
                                        database.removeRepeatedTaskFromGroup(widget.task.id, widget.group.code);
                                        widget.parent.setState(() {
                                          widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                                        });
                                      }
                                      else {
                                        database.removeSingleTask(widget.task.id);
                                        database.removeSingleTaskFromGroup(widget.task.id, widget.group.code);
                                      }
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width - 50,
                                      child: Row(
                                        children: [
                                          Icon(Icons.delete),
                                          SizedBox(width: 8),
                                          Text("Delete Task")
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                        (checkedValue ? Padding(padding: EdgeInsets.only(top: 30, left: 40, right: 10), child: Container(color: Colors.pink, width: MediaQuery.of(context).size.width, height: 3)) : SizedBox()),
                      ]
                  )
              ),
            ),


            // Sticker
            (isShowSticker ? buildSticker() : Container()),
          ],
        ),
      ],
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
      rows: 4,
      columns: 6,
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
