import 'package:flutter/material.dart';
import '../../components/button.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Padding(
          padding: const EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
          child: Stack(
            children: [
              Positioned(
                left: -60,
                top: -60,
                child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                        color: Color(0xFFc6bed2),
                        borderRadius: BorderRadius.circular(60.0)),
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
                        color: Color(0xFFc6bed2),
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
                        color: Color(0xFFc6bed2),
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
                        style: TextStyle(fontSize: 20, color: Color(0xFF572f8c),
                            fontWeight: FontWeight.w400),
                        textAlign: TextAlign.center)
                  ],
                )
              ),
              Align(
                  alignment: Alignment.bottomCenter,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      primaryRoundButton(Color(0xFF572f8c), Color(0xFFc6bed2), " LOG IN ", () { Navigator.pushNamed(context, '/login'); }, 260.0, 30.0),
                      SizedBox(height: 30),
                      primaryRoundButton(Color(0xFFc6bed2), Color(0xFF572f8c), "SIGN UP", () { Navigator.pushNamed(context, '/signup'); }, 260.0, 30.0),
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
