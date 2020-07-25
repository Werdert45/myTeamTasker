import 'package:collaborative_repitition/models/group.dart';
import 'package:flutter/material.dart';

class GroupSettings extends StatefulWidget {
  final List groups;

  GroupSettings(this.groups);

  @override
  _GroupSettingsState createState() => _GroupSettingsState();
}

class _GroupSettingsState extends State<GroupSettings> {
  @override
  Widget build(BuildContext context) {
    
    List members = [];
    
    widget.groups[0].members.forEach((k, v) => members.add(v));
    
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Column(
              children: [
                Text(widget.groups[0].name, style: TextStyle(fontSize: 24)),
                SizedBox(height: 6),
                Text(widget.groups[0].code, style: TextStyle(fontSize: 18, color: Colors.blueGrey))
              ],
            ),
          ),
          SizedBox(height: 20),
          Text("Description", style: TextStyle(fontSize: 20)),
          SizedBox(height: 6),
          Text(widget.groups[0].description),
          SizedBox(height: 20),
          Container(width: MediaQuery.of(context).size.width / 2, child: Text("Members", style: TextStyle(fontSize: 20))),
          SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Row(
              children: [
                Container(
                  height: 72,
                  width: MediaQuery.of(context).size.width - 60,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: members.length,
                      itemBuilder: (context, index) {
                        return Column(
                          children: [
                            Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Center(child: Text(members[index].substring(0,1).toUpperCase(), style: TextStyle(fontSize: 20)))
                            ),
                            SizedBox(height: 6),
                            Text(members[index])
                          ],
                        );
                      }
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
