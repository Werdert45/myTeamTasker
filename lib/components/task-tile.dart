import 'package:circular_check_box/circular_check_box.dart';
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

class EmoIcon extends StatefulWidget {
  final task;
  final puid;
  final group;
  final parent;
  final tasks_history_pers;
  final total_tasks;
//
  EmoIcon(this.task, this.puid, this.group, this.parent, this.tasks_history_pers, this.total_tasks);


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
    if (checkedValue) {
      if (shared) {
        await database.addToSharedTaskHistory(puid, taskID, widget.group.code, widget.group.tasks_history);
      }
      else {
        await database.addToPersonalTaskHistory(puid, taskID, widget.tasks_history_pers, widget.total_tasks);
      }
    }
    else {
      if (shared) {
        await database.removeFromSharedTaskHistory(puid, taskID, widget.group.code, widget.group.tasks_history, widget.task.repeated);
      }

      else {
        await database.removeFromPersonalTaskHistory(puid, taskID, widget.tasks_history_pers, widget.total_tasks, widget.task.repeated);
      }
    }

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
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
      child: Container(
        child: Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () {
                  },
                  child: ClipPath(
                    clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(10))
                        )
                    ),
                    child: AnimatedContainer(
                        width: MediaQuery.of(context).size.width - 40,
                        height: expanded ? 280.0 : 60.0,
                        duration: Duration(milliseconds: 500),
                        decoration: BoxDecoration(
                          color: Color(0xFFE8EDED),
                            border: checkedValue ? Border(
                                bottom: BorderSide(
                                    color: Colors.green,
                                    width: 5.0
                                )
                            ) : null
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                                            Column(
                                              children: [
                                                SizedBox(height: 6),
                                                Container(
                                                    child: checkedValue ? Text(widget.task.icon, style: TextStyle(fontSize: 25, color: Colors.grey)) : Text(widget.task.icon, style: TextStyle(fontSize: 25))
                                                )
                                              ],
                                            ),
                                            SizedBox(width: 20),
                                            Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(height: 10),
                                                  (task_name != null ? Container(width: 160, child: Text(task_name.length <= 16 ? task_name : task_name.substring(0,13) + "...", style: TextStyle(color: primaryColor, fontSize: 20, decoration: checkedValue ? TextDecoration.lineThrough : null))) : Text("Loading ...")),
//                      SizedBox(height: 3),
                                                  checkedValue ? Text("Completed", style: TextStyle(color: secondaryColor, fontSize: 12)) : Text("8 AM to 12 AM", style: TextStyle(color: secondaryColor, fontSize: 12))
                                                ]
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(top: 5.0),
                                          child: IconButton(
                                            icon: Icon(Icons.keyboard_arrow_down, size: 30),
                                            onPressed: () {
                                              setState(() {
                                                expanded = !expanded;
                                              });
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      height: expanded ? 200 : 0,
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
                                          SizedBox(height: 10),
//                                          (widget.task.finished_by != {}) ? Text("Completed by: " + widget.task.finished_by.values.toList()[0].toString(), style: TextStyle(color: Colors.grey)) : SizedBox(),
                                          Divider(),
                                          SizedBox(height: 5),
                                          Text("Information", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
                                          SizedBox(height: 10),
                                          widget.task.shared ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Belongs to group: "),
                                              Text(widget.group.name)
                                            ],
                                          ) : SizedBox(),
                                          SizedBox(height: 15),
                                          (widget.task.repeated) ? Row(
                                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text("Repeated on:", style: TextStyle(fontSize: 14)),
                                              SizedBox(height: 10),
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
                                          SizedBox(height: 30),
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
                // Sticker
                (isShowSticker ? buildSticker() : Container()),
              ],
            ),
          ],
        ),
      ),
      actions: !checkedValue ? <Widget>[
        IconSlideAction(
          color: Colors.transparent,
          iconWidget: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.green,
            ),
            child: Icon(Icons.check, color: Colors.white),
          ),
          onTap: () {
            setState(() {
              checkedValue = true;
              updateFinishedStatus(widget.task.id, checkedValue, widget.puid);
            });
          },
        ),
      ] : [],
      secondaryActions: checkedValue ? <Widget>[
        IconSlideAction(
          color: Colors.transparent,
          iconWidget: Container(
              width: 80,
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.red,
              ),
              child: Center(
                child: Text("Undo", style: TextStyle(color: Colors.white, fontSize: 18)),
              )
          ),
          onTap: () {
            setState(() {
              checkedValue = false;
              updateFinishedStatus(widget.task.id, checkedValue, widget.puid);
            });
          },
        ),
      ] :
      [
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
            setState(() {
              Navigator.push(context, MaterialPageRoute(builder: (context) => EditTask(widget.task)));
//              checkedValue = false;
//              updateFinishedStatus(widget.task.id, checkedValue, widget.puid);
            });
          },
        )
      ]
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
