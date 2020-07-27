import 'package:collaborative_repitition/components/edit_task.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/complete_user.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
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

  updateFinishedStatus(taskID, status, puid) async {
    if (widget.task is repeated_task) {
      await database.updateFinishedStatusRepeated(taskID, status, puid);
    }

    else if (widget.task is single_task) {
      await database.updateFinishedStatusSingle(taskID, status, puid);
    }

    else {
      print('Houston we have a problem');
    }
  }

  updateTaskDB(repeated, title, icon, id, days, init_days, alertTime, puid, date, group, shared, init_shared, init_repeated, group_code, group_name) async {
    // Remove all from the specific task
    await database.completeReplacementTask(id, group, puid, repeated, shared, init_repeated, init_shared);

    // Check the conditions and add accordingly
    if (repeated && shared) {
      // add to repeated in group
      await database.createRepeatedTask(id, alertTime, puid, puid, days, icon, title, shared, group_code, group_name);
      await database.addRepeatedTask(id, puid, group, shared);
    }

    else if (repeated && !shared) {
      // add to repeated in user
      await database.createRepeatedTask(id, alertTime, puid, puid, days, icon, title, shared, group_code, group_name);
      await database.addRepeatedTask(id, puid, group, shared);
    }

    else if (!repeated && shared) {
      // add to single in group
      await database.createSingleTask(id, alertTime, date, icon, puid, title, puid, shared, group_code, group_name);
      await database.addSingleTask(id, puid, group, shared);
    }

    else if (!repeated && !shared) {
      // add to single in user
      await database.createSingleTask(id, alertTime, date, icon, puid, title, puid, shared, group_code, group_name);
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



    return Slidable(
      // Set the slidable to be able to be accepted when not checked, when checked show undo
        actionPane: SlidableDrawerActionPane(),
        actionExtentRatio: 0.2,
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                  },
                  // Add a slider, to remove task
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ClipPath(
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                      ),
                      child: AnimatedContainer(
                          width: MediaQuery.of(context).size.width - 30,
                          height: expanded ? 400.0 : 60.0,
                          color: Color(0xFFE8EDED),
                          duration: Duration(milliseconds: 500),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 5),
                            child: Stack(
                                children: [
                                  Column(
                                    children: [
                                      Row(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Column(
                                            children: [
                                              SizedBox(height: 12),
                                              Container(
                                                  child: Text(widget.task.icon, style: TextStyle(fontSize: 28))
                                              )
                                            ],
                                          ),
                                          SizedBox(width: 25),
                                          Column(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                SizedBox(height: 10),
                                                (task_name != null ? Container(width: 160, child: Text(task_name.length <= 16 ? task_name : task_name.substring(0,13) + "...", style: TextStyle(color: primaryColor, fontSize: 20))) : Text("Loading ...")),
                                                Text("8 AM to 12 AM", style: TextStyle(color: secondaryColor, fontSize: 12))
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
                                                  var date = _dateTime.millisecondsSinceEpoch;
                                                  var group = widget.group.code;
                                                  var init_shared = widget.task.shared;
                                                  var init_repeated = widget.task.repeated;
                                                  var group_code = widget.group.code;
                                                  var group_name = widget.group.name;

                                                  await updateTaskDB(repeated, title, icon, id, days_show, init_days, alertTime, puid, date, group, shared, init_shared, init_repeated, group_code, group_name);
                                                  await saveTask();
                                                }) : Padding(
                                              padding: const EdgeInsets.only(top: 8.0),
                                              child: Text("MORE INFO"),
                                            ),
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
                                              ],
                                            ),
                                            Container(
                                              child: repeated ? Row(
                                                children: [
                                                  Column(
                                                    children: [
                                                      Text("Mon"),
                                                      Checkbox(
                                                        onChanged: null,
                                                        value: days_show[0],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Tue"),
                                                      Checkbox(
                                                        onChanged: null,
                                                        value: days_show[1],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Wed"),
                                                      Checkbox(
                                                        onChanged: null,
                                                        value: days_show[2],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Thu"),
                                                      Checkbox(
                                                        onChanged: null,
                                                        value: days_show[3],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Fri"),
                                                      Checkbox(
                                                        onChanged: null,
                                                        value: days_show[4],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Sat"),
                                                      Checkbox(
                                                        onChanged: null,
                                                        value: days_show[5],
                                                      ),
                                                    ],
                                                  ),
                                                  Column(
                                                    children: [
                                                      Text("Sun"),
                                                      Checkbox(
                                                        onChanged: null,
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
                                            Padding(
                                              padding: const EdgeInsets.only(right: 17.0),
                                              child: Row(
                                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                children: [
                                                  RaisedButton(
                                                    color: Colors.red,
                                                    onPressed: () async {
                                                      if (repeated) {
                                                        if (widget.task.shared) {
                                                          await database.removeRepeatedTask(widget.task.id);
                                                          await database.removeRepeatedTaskFromGroup(widget.task.id, widget.group.code);
                                                          widget.parent.setState(() {
                                                            widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                                                          });
                                                        }
                                                        else {
                                                          await database.removeRepeatedTask(widget.task.id);
                                                          await database.removeRepeatedTaskFromUser(widget.task.id, widget.puid);
                                                          widget.parent.setState(() {
                                                            widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                                                          });
                                                        }
                                                      }
                                                      else {
                                                        if (widget.task.shared) {
                                                          await database.removeSingleTask(widget.task.id);
                                                          await database.removeSingleTaskFromGroup(widget.task.id, widget.group.code);
                                                          widget.parent.setState(() {
                                                            widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                                                          });
                                                        }

                                                        else {
                                                          await database.removeSingleTask(widget.task.id);
                                                          await database.removeSingleTaskFromUser(widget.task.id, widget.puid);
                                                          widget.parent.setState(() {
                                                            widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                                                          });
                                                        }
                                                      }
                                                    },
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width / 3 - 20,
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.delete),
                                                          SizedBox(width: 8),
                                                          Text("Delete task")
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  RaisedButton(
                                                    color: Colors.blue,
                                                    onPressed: () {
                                                      print("Showing EditTask");

                                                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditTask(widget.task)));
                                                    },
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width / 3 - 20,
                                                      child: Row(
                                                        children: [
                                                          Icon(Icons.edit),
                                                          SizedBox(width: 8),
                                                          Text("Edit task")
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ]
                            ),
                          )
                      ),
                    ),
                  ),
                ),


                // Sticker
                (isShowSticker ? buildSticker() : Container()),
              ],
            ),
          ],
        ),
        secondaryActions: <Widget>[
          IconSlideAction(
            color: Colors.transparent,
            iconWidget: Container(
                width: 80,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.blue,
                ),
                child: Center(
                  child: Text("Edit", style: TextStyle(color: Colors.white, fontSize: 18)),
                )
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditTask(widget.task)));
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: IconSlideAction(
              color: Colors.transparent,
              iconWidget: Container(
                  width: 80,
                  height: 60,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.red,
                  ),
                  child: Center(
                    child: Text("Delete", style: TextStyle(color: Colors.white, fontSize: 18)),
                  )
              ),
              onTap: () async {
                if (repeated) {
                  if (widget.task.shared) {
                    await database.removeRepeatedTask(widget.task.id);
                    await database.removeRepeatedTaskFromGroup(widget.task.id, widget.group.code);
                    widget.parent.setState(() {
                      widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                    });
                  }
                  else {
                    await database.removeRepeatedTask(widget.task.id);
                    await database.removeRepeatedTaskFromUser(widget.task.id, widget.puid);
                    widget.parent.setState(() {
                      widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                    });
                  }
                }
                else {
                  if (widget.task.shared) {
                    await database.removeSingleTask(widget.task.id);
                    await database.removeSingleTaskFromGroup(widget.task.id, widget.group.code);
                    widget.parent.setState(() {
                      widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                    });
                  }

                  else {
                    await database.removeSingleTask(widget.task.id);
                    await database.removeSingleTaskFromUser(widget.task.id, widget.puid);
                    widget.parent.setState(() {
                      widget.parent.tasks.removeWhere((item) => item == widget.task.id);
                    });
                  }
                }
              },
            ),
          ),
        ]
    );
  }

  Widget buildInput(initialIcon, size) {
    return Container(
      width: size,
      height: size + 20,
      color: Colors.transparent,
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
