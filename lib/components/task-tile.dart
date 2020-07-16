import 'package:collaborative_repitition/models/complete_user.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'button.dart';

class EmoIcon extends StatefulWidget {
  final task;
  final puid;
  final group;
  final parent;
//
  EmoIcon(this.task, this.puid, this.group, this.parent);


  @override
  EmoIconState createState() => new EmoIconState();
}

class EmoIconState extends State<EmoIcon> {
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
                  height: expanded ? 220.0 : 60.0,
                  duration: Duration(milliseconds: 500),
                  child: Stack(
                    children: [
                      Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  padding: EdgeInsets.only(top: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        checkedValue = ! checkedValue;
                                        updateFinishedStatus(widget.task.id, checkedValue, widget.puid);

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
                                        child: Text(widget.task.icon, style: TextStyle(fontSize: 25))
                                    )
                                  ],
                                ),
                                SizedBox(width: 20),
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
                              ],
                            ),
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_down),
                              onPressed: () {
                                setState(() {
                                  expanded = !expanded;
                                });
                              },
                            )
                          ],
                        ),
                        Container(
                          height: expanded ? 170 : 0,
                          width: MediaQuery.of(context).size.width - 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text(widget.task.title, style: TextStyle(fontSize: 18)),
                                  ),
                                  Text(widget.task.icon, style: TextStyle(fontSize: 25))
                                ],
                              ),
                              SizedBox(height: 20),
                              (widget.task.repeated) ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Repeated Task on days:", style: TextStyle(fontSize: 14)),
                                  SizedBox(height: 3),
                                  Text("Mon, Tue, Wed, Thu, Fri, Sat, Sun", style: TextStyle(fontSize: 13))
                                ],
                              ) :
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Single Task on:"),
                                  SizedBox(width: 3),
                                  Text("14th of November 2010")
                                ],
                              ),
                              SizedBox(height: 10),
                              Padding(
                                padding: const EdgeInsets.only(right: 20.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    widget.task.alert_time != null ?
                                    Text("Alert at:  " + widget.task.alert_time.toString(), style: TextStyle(fontSize: 14))
                                        :
                                    Text("No alert", style: TextStyle(fontSize: 14))
                                  ],
                                ),
                              ),
                              SizedBox(height: 5),
                              widget.task.shared ?
                                  Text("This is a shared task in group ...") :
                                  Text("This is a personal task"),
                              SizedBox(height: 5),
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
