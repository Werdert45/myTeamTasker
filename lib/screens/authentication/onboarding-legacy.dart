import 'package:flutter/material.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();

}


class _OnboardingScreenState extends State<OnboardingScreen> with
    TickerProviderStateMixin{
  double screenSize;
  double screenRatio;
  AppBar appBar;
  List<Tab> tabList = List();
  TabController _tabController;
  @override
  void initState() {
    tabList.add(new Tab(
        child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: Color(0xFFc6bed2),
                borderRadius: BorderRadius.circular(60.0))
        )));
    tabList.add(new Tab(
        child: Container(
            width: 10,
            height: 10,
            decoration: BoxDecoration(
                color: Color(0xFFc6bed2),
                borderRadius: BorderRadius.circular(60.0))
        )));
    _tabController = new TabController(vsync: this, length:
    tabList.length);
    super.initState();
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    screenSize = MediaQuery.of(context).size.width;
    appBar = AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0.0,
    );
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          new Container(
            height: 300,
            width: screenSize,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: appBar,
            body:
            Stack(
              children: <Widget>[
                new Positioned(
                  child: Column(
                    children: <Widget>[
                      SingleChildScrollView(
                        child: Container(
                          color: Colors.white,
                          child: new Container(
                            height: 20.0,
                            child: new TabBarView(
                              controller: _tabController,
                              children: <Widget>[
                                Container(
                                  child: Text("Test"),
                                ),
                                Container(
                                  child: Text("Test 2"),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  width: screenSize,
                  top: 170,
                ),
                new Positioned(
                  width: screenSize,
                  bottom: 150,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: new Column(
                      children: <Widget>[
                        new Container(
                          width: 100,
//                          decoration: new BoxDecoration(color: Theme.of(context).primaryColor),
                          child: new TabBar(
                              controller: _tabController,
//                              indicatorColor: Colors.pink,
                              indicatorSize: TabBarIndicatorSize.tab,
                              indicator: BubbleTabIndicator(
                                indicatorHeight: 15.0,
                                indicatorRadius: 20,
                                indicatorColor: Color(0xFF572f8c),
                                tabBarIndicatorSize: TabBarIndicatorSize.tab,
                              ),
                              tabs: tabList
                          ),
                        ),

                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}