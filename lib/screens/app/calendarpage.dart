import 'package:collaborative_repitition/components/task-tile.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/services/auth.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/date-functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_clean_calendar/flutter_clean_calendar.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {
  final Streams streams = Streams();

  List months = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Okt", "Nov", "Dec"];

  void _handleNewDate(date) {
    setState(() {
      _selectedDay = date;
      _selectedEvents = _events[_selectedDay] ?? [];
    });
    print(_selectedEvents);
  }

  List _selectedEvents;
  DateTime _selectedDay;

  final Map<DateTime, List> _events = {};

  final AuthService _auth = AuthService();

  @override
  void initState() {
    super.initState();
    var now = DateTime.now();
    var today = DateTime(now.year, now.month, now.day);

    _selectedDay = today;


    _selectedEvents = _events[_selectedDay] ?? [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var current_user = Provider.of<User>(context);

    Map<String, dynamic> per_day = new Map();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: streams.getCalendar(current_user.uid),
            builder: (context, snapshot) {
                var today = DateTime.now();

                Map<DateTime, dynamic> calendar = Map<DateTime, dynamic>.from(snapshot.data);
                calendar.forEach((k,v) => _events[k] = v);

                _selectedEvents = _events[_selectedDay];

                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            color: boxColor,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 50, top: 18, bottom: 6, right: 35),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(months[today.month].toUpperCase(), style: TextStyle(fontSize: 28, color: mainTextColor)),
                                      Text(today.day < 10 ? "0" + today.day.toString() : today.day.toString(), style: TextStyle(fontSize: 48, color: mainTextColor))
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.topRight,
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: Text("Today you have\n4 things to do", style: TextStyle(fontSize: 26, color: mainTextColor)),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 15),
                          child: Calendar(
                            startOnMonday: true,
                            weekDays: ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"],
                            events: _events,
                            hideTodayIcon: true,
                            onRangeSelected: (range) =>
                                print("Range is ${range.from}, ${range.to}"),
                            onDateSelected: (date) => _handleNewDate(date),
                            isExpandable: false,
                            eventDoneColor: Colors.green,
                            selectedColor: boxColor,
                            todayColor: Colors.blue,
                            eventColor: Colors.grey,
                            dayOfWeekStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 11),
                          ),
                        ),
                      ),
                      _buildEventList(current_user)
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }

  Widget _buildEventList(user) {
    return _selectedEvents == null ?
        Padding(
          padding: const EdgeInsets.only(top: 50.0),
          child: _selectedDay.difference(DateTime.now()).inMilliseconds < 0 ?
            Center(
                child: Container(
                    width: 200,
                    child: Center(child: Text("You don't need to look in the past, look in the future instead", style: (TextStyle(fontSize: 18)), textAlign: TextAlign.center)
                    )
                )
            ) :
            Center(
                child: Container(
                    width: 200,
                    child: Text("No Tasks, for now, add one using the big button below", style: (TextStyle(fontSize: 18)), textAlign: TextAlign.center)
                )
            ),
        )
        :
     Expanded(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          if (_selectedEvents.isNotEmpty) {
            return Container(
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(width: 1.5, color: Colors.black12),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
              child: EmoIcon(_selectedEvents[index]['task'], user.uid, _selectedEvents[index]['groups'], this, _selectedEvents[index]['tasks_history_pers'], _selectedEvents[index]['total_tasks'], isDone: _selectedEvents[index]['isDone'])
            );
          }
          else {
            return SizedBox(
              child: Text("DONT BE AFRAID MY CHILD"),
            );
          }
        },
        itemCount: _selectedEvents != null ? _selectedEvents.length : 0,
      ),
    );
  }
}