import 'package:collaborative_repitition/components/add_task.dart';
import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/models/user.dart';
import 'package:collaborative_repitition/notifications_lib/functions/notification_functions.dart';
import 'package:collaborative_repitition/screens/app/partials/bottombaritem.dart';
import 'package:collaborative_repitition/services/database.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  final Streams streams = Streams();


  var _page = 1;

  var pages = <Widget>[
    DashboardPage(),
    CalendarScreen(),
    StatisticsPage(),
    TaskManagerPage(),
  ];


  @override
  void initState() {
    super.initState();
    tabController = new TabController(length: 4, vsync: this);

    _page = 0;

    getDarkModeSetting().then((val) {
      brightness = val;
    });

  }


  void _selectPage(int index) {
    setState(() {
      _page = index;
    });
  }

  bool brightness = false;

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<User>(context);

    getDarkModeSetting().then((val) {
      brightness = val;
    });

    var color = brightness ? darkmodeColor : lightmodeColor;

    return FutureBuilder(
      future: streams.getCompleteUser(user.uid),
      builder: (context, snapshot) {
        var user_data = snapshot.data;
        return FutureBuilder(
              future: setNotifications(snapshot.data.tasks),
              builder: (context, snapshot2) {
                if (snapshot2.connectionState == ConnectionState.active) {
                  return CircularProgressIndicator();
                }
                else {
                  return Scaffold(
                    bottomNavigationBar: FABBottomAppBar(
                      onTabSelected: _selectPage,
                      color: Colors.black,
                      selectedColor: color['foregroundColor'],
                      notchedShape: CircularNotchedRectangle(),
                      items: [
                        FABBottomAppBarItem(iconData: Icons.home, text: "Home"),
                        FABBottomAppBarItem(iconData: Icons.calendar_today, text: "Calendar"),
                        FABBottomAppBarItem(iconData: Icons.insert_chart, text: "Statistics"),
                        FABBottomAppBarItem(iconData: Icons.edit, text: "Manager"),
                      ],
                    ),
                    body: pages[_page],
                    floatingActionButton: button(user_data, color),
                    floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
                  );
                }
              }
          );
      }
    );
  }

  Widget button(user_data, color) {
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: color['primaryColor'],
      heroTag: "add_task",
      onPressed: () {

        List<ListItem> _groups = [];

        int group_length = user_data.groups.length;
        for (int i=0; i<group_length; i++) {
          _groups.add(ListItem(
              i, user_data.groups[i].name
          ));
        }

        List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
          List<DropdownMenuItem<ListItem>> items = List();
          for (ListItem listItem in listItems) {
            items.add(
              DropdownMenuItem(
                child: Text(listItem.name),
                value: listItem,
              ),
            );
          }
          return items;
        }

        List<DropdownMenuItem<ListItem>> dropdownItems;

        dropdownItems = buildDropDownMenuItems(_groups);


        Navigator.push(context, MaterialPageRoute(builder: (context) =>  InheritedUserData(user_data: dropdownItems, child: AddTask(user_data))));
      },
    );
  }
}

class InheritedUserData extends InheritedWidget {
  final user_data;

  InheritedUserData({this.user_data, Widget child}) : super(child: child);

  static InheritedUserData of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<InheritedUserData>();
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;


}