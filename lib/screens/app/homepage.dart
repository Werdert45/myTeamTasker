import 'package:collaborative_repitition/components/add_task.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/screens/app/partials/bottombaritem.dart';
import 'package:collaborative_repitition/screens/app/profilepage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'dashboard.dart';
import 'statisticspage.dart';
import 'calendarpage.dart';
import 'taskmanagerpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;


  var _page = 1;

  var pages = <Widget>[
    DashboardPage(),
    CalendarScreen(),
    TaskManagerPage(),
    StatisticsPage(),
  ];


  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 4, vsync: this);

    _page = 1;
  }


  void _selectPage(int index) {
    setState(() {
      _page = index;
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: FABBottomAppBar(
        onTabSelected: _selectPage,
        notchedShape: CircularNotchedRectangle(),
        items: [
          FABBottomAppBarItem(iconData: Icons.home, text: "Home"),
          FABBottomAppBarItem(iconData: Icons.calendar_today, text: "Calendar"),
          FABBottomAppBarItem(iconData: Icons.account_balance, text: "Manager"),
          FABBottomAppBarItem(iconData: Icons.insert_chart, text: "Statistics")
        ],
      ),
      body: pages[_page],
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: primaryColor,
        heroTag: "add_task",
        onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => AddTask()));
  },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        );
  }
}
