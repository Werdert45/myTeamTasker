import 'dart:convert';

import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/models/user_db.dart';
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
    _selectedEvents = _events[_selectedDay] ?? [];
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    Map<String, dynamic> per_day = new Map();

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: FutureBuilder(
            future: streams.getCalendar(user.uid),
            builder: (context, snapshot) {

                Map<DateTime, dynamic> calendar = Map<DateTime, dynamic>.from(snapshot.data);
                calendar.forEach((k,v) => _events[k] = v);

                return Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      SizedBox(height: 20),
                      IconButton(
                        icon: Icon(Icons.exit_to_app, color: Colors.white, size: 30),
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.pushReplacementNamed(context, '/landingpage');
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width - 30,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(left: 50, top: 8, bottom: 8, right: 35),
                            child: Stack(
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("June", style: TextStyle(fontSize: 24, color: Colors.deepPurple)),
                                      Text("02", style: TextStyle(fontSize: 48, color: Colors.deepPurple))
                                    ],
                                  ),
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text("Today you have\n4 things to do", style: TextStyle(fontSize: 22, color: Colors.deepPurple)),
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
                            onRangeSelected: (range) =>
                                print("Range is ${range.from}, ${range.to}"),
                            onDateSelected: (date) => _handleNewDate(date),
                            isExpandable: true,
                            eventDoneColor: Colors.green,
                            selectedColor: Colors.pink,
                            todayColor: Colors.blue,
                            eventColor: Colors.grey,
                            dayOfWeekStyle: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 11),
                          ),
                        ),
                      ),
                      _buildEventList()
                    ],
                  ),
                );
              }
          ),
        ),
      ),
    );
  }

  Widget _buildEventList() {
    return Expanded(
      child: ListView.builder(
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {

          return Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(width: 1.5, color: Colors.black12),
              ),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 0.0, vertical: 4.0),
            child: ListTile(
              leading: Text(_selectedEvents[index]['icon'], style: TextStyle(fontSize: 28)),
              title: Text(_selectedEvents[index]['name']),
              subtitle: (_selectedEvents[index]['days'] != null) ? Text("Repeated")  : Text("One Time"),
              trailing: Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: (_selectedEvents[index]['alert_time'] != null) ? Text("Alert at: " + _selectedEvents[index]['alert_time'].toString()) : Text("No Alert"),
              ),
              onTap: () {
                print(_selectedDay);
                print(_selectedEvents[index]);
              },
            ),
          );
        },
        itemCount: _selectedEvents.length,
      ),
    );
  }
}