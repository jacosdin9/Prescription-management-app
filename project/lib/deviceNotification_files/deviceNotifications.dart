import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class DeviceNotifications extends StatefulWidget{

  String name;
  String description;
  DateTime scheduledTime;

  DeviceNotifications(this.name, this.description, this.scheduledTime);

  @override
  _DeviceNotificationsState createState() => _DeviceNotificationsState(name, description, scheduledTime);
}

class _DeviceNotificationsState extends State<DeviceNotifications> {
  var flutterLocalNotificationsPlugin;
  String name;
  String description;
  DateTime scheduledTime;

  _DeviceNotificationsState(this.name, this.description, this.scheduledTime);

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var androidInitialize = AndroidInitializationSettings('android_logo');
    var initializationSettings = InitializationSettings(android: androidInitialize);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification);
  }

  Future _showNotification() async{
    var androidDetails = AndroidNotificationDetails("ChannelID", "channelName", "channelDescription", importance: Importance.max);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.schedule(1, name, description, scheduledTime, generalNotificationDetails);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Local Notifications"),
      ),
      body: Column(
        children: [
          Text("local notifications"),
          RaisedButton(onPressed: _showNotification),
        ],
      ),
    );
  }

  Future selectNotification(String payload) async {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Text("Notification clicked $payload"),
      )
    );
  }
}