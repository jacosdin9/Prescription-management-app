import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'mainArea.dart';

String currentTimeZone;

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
AndroidInitializationSettings androidInitialize = AndroidInitializationSettings('android_logo');
InitializationSettings initializationSettings = InitializationSettings(android: androidInitialize);

FlutterLocalNotificationsPlugin flutterLocalNotificationsPluginOnline = FlutterLocalNotificationsPlugin();
AndroidInitializationSettings androidInitializeOnline = AndroidInitializationSettings('android_logo');
InitializationSettings initializationSettingsOnline = InitializationSettings(android: androidInitializeOnline);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(StartApp());
}

class StartApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainArea(recentIndex),
    );
  }
}