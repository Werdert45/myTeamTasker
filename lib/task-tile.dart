import 'package:flutter/material.dart';
import 'package:emoji_picker/emoji_picker.dart';
import 'components/button.dart';

class EmoIcon extends StatefulWidget {
  @override
  EmoIconState createState() => new EmoIconState();
}

enum Answers{YES,NO,MAYBE}


class EmoIconState extends State<EmoIcon> {
  bool isShowSticker;
  bool checkedValue;
  var expanded = false;

  var repeated = false;
  TextEditingController _controller;
  var task_name = "Walk the dog 1";
  List days = ['MON','TUE','WED','THU','FRI','SAT','SUN'];
  List days_show = [false,false,false,false,false,false,false];

  Emoji categories;

  @override
  void initState() {
    super.initState();
    isShowSticker = false;
    categories = Emoji(name: 'Sailboat', emoji: '😇');
    checkedValue = false;
    _controller = new TextEditingController(text: task_name);
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

    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              GestureDetector(
                onTap: () {
                },
                child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width - 30,
                    height: expanded ? 260.0 : 60.0,
                    duration: Duration(milliseconds: 500),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: EdgeInsets.only(top: 15),
                              child: GestureDetector(
                                  onTap: () {
                                    checkedValue ? checkedValue = false : checkedValue = true;
                                    print(checkedValue);
                                  },
                                  child: checkbox(30.0, Colors.grey, Colors.blueGrey, checkedValue)
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
                                  Container(width: 160, child: Text(task_name.length <= 16 ? task_name : task_name.substring(0,13) + "...", style: TextStyle(color: Color(0xFF572f8c), fontSize: 20))),
//                      SizedBox(height: 3),
                                  Text("8 AM to 12 AM", style: TextStyle(color: Color(0xFFc6bed2), fontSize: 12))
                                ]
                            ),
                            FlatButton(
                              onPressed: editTask,
                              child: expanded ? GestureDetector(child: Text("SAVE"), onTap: saveTask) : Text("EDIT"),
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
                                children: [
                                  Container(
                                    width: MediaQuery.of(context).size.width / 1.5,
                                    child: TextField(
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
                              Row(
                                  children: [
                                    Text("Repeat on days:"),
                                    Checkbox(
                                      onChanged: (bool value) {
                                        setState(() {
                                          repeated = value;
                                        });
                                      },
                                      value: repeated,
                                    ),
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
                                ) : SizedBox(),
                              )
                            ],
                          ),
                        )
                      ],
                    )
                ),
              ),


              // Sticker
              (isShowSticker ? buildSticker() : Container()),
            ],
          ),
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
      rows: 4,
      columns: 6,
      buttonMode: ButtonMode.MATERIAL,
      recommendKeywords: ["dog", "boat"],
      numRecommended: 10,
      onEmojiSelected: (emoji, category) {
        print(emoji);
        setState(() {
          categories = emoji;
        });
      },
    );
  }
}
