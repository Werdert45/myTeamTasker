import 'package:flutter/material.dart';

class ThemeBuilder extends StatefulWidget {

  final Widget Function(BuildContext context, Brightness brightness) builder;
  final Brightness defaultBrightness;


  ThemeBuilder({this.builder, this.defaultBrightness});

  @override
  _ThemeBuilderState createState() => _ThemeBuilderState();


  static _ThemeBuilderState of(BuildContext context) {
    return context.findAncestorStateOfType<_ThemeBuilderState>();
  }
}

class _ThemeBuilderState extends State<ThemeBuilder> {
  Brightness _brightness;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _brightness = widget.defaultBrightness;

    if (mounted) {
      setState(() {

      });
    }
  }

  void changeTheme(Brightness brightnessType)
  {

    setState(() {
      _brightness = brightnessType;
    });
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, _brightness);
  }
}
