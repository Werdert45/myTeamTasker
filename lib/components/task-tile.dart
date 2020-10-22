import 'package:circular_check_box/circular_check_box.dart';
import 'package:collaborative_repitition/components/edit_task.dart';
import 'package:collaborative_repitition/models/repeated_task.dart';
import 'package:collaborative_repitition/models/single_task.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class EmoIcon extends StatefulWidget {
  final Function() notifyParent;
  final task;
  final puid;
  final group;
  final parent;
  final tasks_history_pers;
  final total_tasks;
  final count;
  final Map color;
  final isDone;
  final user_data;
//
  EmoIcon(this.user_data, this.notifyParent, this.task, this.puid, this.group, this.parent, this.tasks_history_pers, this.total_tasks, this.count, this.color, {this.isDone});


  @override
  EmoIconState createState() => new EmoIconState();
}

class EmoIconState extends State<EmoIcon> {
  TimeOfDay _time = TimeOfDay.now();
  DateTime _dateTime = DateTime.now();
  DatabaseService database = DatabaseService();


  bool repeated;
  bool shared;
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

  bool brightness = false;

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
    repeated = widget.task.repeated;
    shared = widget.task.shared;

    return FutureBuilder(
      future: getDarkModeSetting(),
      builder: (context, snapshot) {
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
                                  color: widget.color['taskColor'],
                                  border: widget.isDone == null ? checkedValue ? Border(
                                      bottom: BorderSide(
                                          color: Colors.green,
                                          width: 5.0
                                      )
                                  ) : null : null
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
                                                        (task_name != null ? Container(width: 160, child: Text(task_name.length <= 16 ? task_name : task_name.substring(0,13) + "...", style: TextStyle(color: widget.color['primaryColor'], fontSize: 20, decoration: (widget.isDone == null) ? (checkedValue ? TextDecoration.lineThrough : null) : (widget.isDone) ? TextDecoration.lineThrough : null))) : Text("Loading ...")),
//                      SizedBox(height: 3),
                                                        (widget.isDone == null) ? checkedValue ? (
                                                          widget.task.shared ? Text("Finished by: " + widget.task.finished_by.values.toList()[0], style: TextStyle(color: widget.color['secondaryColor'], fontSize: 12)) :
                                                          Text("Completed", style: TextStyle(color: widget.color['secondaryColor'], fontSize: 12))) :
                                                      Text("Not finished", style: TextStyle(color: widget.color['secondaryColor'], fontSize: 12)) :
                                                          SizedBox()
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
                                            height: expanded ? 220 : 0,
                                            width: MediaQuery.of(context).size.width - 50,
                                            child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                              Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(top: 10.0),
                                                      child: Text(widget.task.title, style: TextStyle(fontSize: 20)),
                                                    ),
                                                    Container(
                                                      width: MediaQuery.of(context).size.width * 0.6,
                                                      child: Text(widget.task.description, style: TextStyle(color: Colors.grey)),
                                                    )
                                                  ],
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                ),
                                                Text(widget.task.icon, style: TextStyle(fontSize: 40))
                                              ],
                                            ),
                                            SizedBox(height: 5),
                                            Divider(),
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("ALERT AT", style: TextStyle(fontSize: 14)),
                                                    Text(widget.task.alert_time, style: TextStyle(fontSize: 24))
                                                  ],
                                                ),
                                                (widget.isDone == null) ? checkedValue ? (widget.task.shared ?
                                                Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("FINISHED BY", style: TextStyle(fontSize: 14)),
                                                    Text(widget.task.finished_by.values.toList()[0])
                                                  ],
                                                ) :
                                                    Text("FINISHED", style: TextStyle(fontSize: 14))) :
                                                    Text("NOT FINISHED") : SizedBox()
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 2 - 100,
                                                  height: 1,
                                                  color: Colors.grey,
                                                ),
                                                Text("REPEATED ON"),
                                                Container(
                                                  width: MediaQuery.of(context).size.width / 2 - 100,
                                                  height: 1,
                                                  color: Colors.grey,
                                                )
                                              ],
                                            ),
                                            SizedBox(height: 10),
                                            Container(
                                              width: MediaQuery.of(context).size.width - 40,
                                              height: 40,
                                              child: ListView.builder(
                                                physics: NeverScrollableScrollPhysics(),
                                                scrollDirection: Axis.horizontal,
                                                itemCount: days_show.length,
                                                itemBuilder: (context, index) {
                                                  return Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width / 120),
                                                    child: Container(
                                                      width: MediaQuery.of(context).size.width / 10.5,
                                                      height: MediaQuery.of(context).size.width / 10.5,
                                                      decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(5),
                                                        color: days_show[index] ? widget.color['selectedColor'] : widget.color['unselectedColor'],
                                                      ),
                                                      child: Center(child: Text(days[index].substring(0,1))),
                                                    ),
                                                  );
                                                },
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
                      // Sticker
                      (isShowSticker ? buildSticker() : Container()),
                    ],
                  ),
                ],
              ),
            ),
            actions: (widget.isDone == null && !checkedValue) ? <Widget>[
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

//
//                // Set the count of completed tasks to add one
//                widget.notifyParent();
                  });
                },
              ),
            ] : [],
            secondaryActions: widget.isDone == null ? checkedValue ? <Widget>[
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

//                // Set the count of completed tasks to remove one
//                widget.notifyParent();

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
                    Navigator.push(context, MaterialPageRoute(builder: (context) => EditTask(widget.task, widget.user_data)));
//              checkedValue = false;
//              updateFinishedStatus(widget.task.id, checkedValue, widget.puid);
                  });
                },
              )
            ] : null
        );
      }
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
