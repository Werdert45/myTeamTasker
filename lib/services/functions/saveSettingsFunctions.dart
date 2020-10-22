import 'package:shared_preferences/shared_preferences.dart';

// Saving the following settings:
// Dark/light mode
// Language
// Notification settings (TODO just make it a slider button, yes or no)

// Possible values
// Dark/light mode: true/false
// language: en
// notification settings: true/false


// Functions for saving
darkModeToSF(bool DarkModeSet) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('dark_mode', DarkModeSet);

  print('Dark mode is set to: ' + DarkModeSet.toString());
}

languageToSF(String language) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('language', language);

  print('Language is set to: ' + language);
}

notificationsToSF(bool NotificationOn) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setBool('notifications', NotificationOn);

  print('Notification settings are set to: ' + NotificationOn.toString());
}

// Functions for retrieving
getDarkModeSetting() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool dark_mode = prefs.getBool('dark_mode') ?? false;
  return dark_mode;
}

// Retrieve all settings for settings page
initSettings() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool dark_mode = prefs.getBool('dark_mode') ?? false;
  String language = prefs.getString('language') ?? 'en';
  bool notifications = prefs.getBool('notifications') ?? true;

  return [dark_mode, language, notifications];
}