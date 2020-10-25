import 'package:collaborative_repitition/constants/colors.dart';
import 'package:collaborative_repitition/services/functions/saveSettingsFunctions.dart';
import 'package:flutter/material.dart';
import '../../components/button.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  bool brightness = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getDarkModeSetting().then((val) {
      brightness = val;
    });
  }

  @override

  Widget build(BuildContext context) {
    getDarkModeSetting().then((val) {
      brightness = val;
    });

    var color = brightness ? darkmodeColor : lightmodeColor;

    
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: Stack(
            children: [
              Positioned(
                left: -50,
                top: -50,
                child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: color['secondaryColor'],
                        borderRadius: BorderRadius.circular(80.0)),
                    child: SizedBox()
                ),
              ),
              Positioned(
                right: -60,
                top: MediaQuery.of(context).size.height / 2 - 60,
                child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: color['secondaryColor'],
                        borderRadius: BorderRadius.circular(60.0)),
                    child: SizedBox()
                ),
              ),
              Positioned(
                left: -50,
                bottom: -50,
                child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: color['secondaryColor'],
                        borderRadius: BorderRadius.circular(60.0)),
                    child: SizedBox()
                ),
              ),
              Align(
                alignment: Alignment.topCenter,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: 40),
                    Text("WELCOME TO\nTaskCollab",
                        style: TextStyle(fontSize: 28, color: color['primaryColor'],
                            fontWeight: FontWeight.w600),
                        textAlign: TextAlign.center)
                  ],
                )
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      primaryRoundButton(color['primaryColor'], color['mainTextColor'], " LOG IN ", () { Navigator.pushNamed(context, '/login'); }, 260.0, 30.0),
                      SizedBox(height: 30),
                      primaryRoundButton(color['primaryColor'], color['mainTextColor'], "SIGN UP", () { Navigator.pushNamed(context, '/signup'); }, 260.0, 30.0),
                      SizedBox(height: 100)
                    ],
                  )
              )
            ],
          ),
        ),
      ),
    );
  }
}
