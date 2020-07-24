import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/screens/app/profilepage.dart';
import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

import 'dashboard.dart';
import 'statisticspage.dart';
import 'calendarpage.dart';
import 'groups.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 5, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      bottomNavigationBar: new Material(
        color: primaryColor,
        child: TabBar(
          controller: tabController,
          tabs: <Widget>[
            new Tab(icon: Icon(Icons.home)),
            new Tab(icon: Icon(Icons.calendar_today)),
            new Tab(icon: Icon(Icons.account_balance)),
            new Tab(icon: Icon(Icons.equalizer)),
            new Tab(icon: Icon(Icons.group))
          ],
        ),
      ),
      body: new TabBarView(
        controller: tabController,
        children: <Widget>[
          DashboardPage(),
          CalendarScreen(),
          TaskManagerPage(),
          StatisticsPage(),
          ProfilePage()
        ],
      ),
        );
  }
}
