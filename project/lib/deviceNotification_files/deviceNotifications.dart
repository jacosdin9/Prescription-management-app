import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project/deviceNotification_files/devNotificationPage.dart';
import 'package:project/main_backend/main.dart';
import 'package:project/main_backend/mainArea.dart';

class DeviceNotifications extends StatefulWidget{

  String name;
  String description;
  DateTime scheduledTime;

  DeviceNotifications(this.name, this.description, this.scheduledTime);

  @override
  _DeviceNotificationsState createState() => _DeviceNotificationsState(name, description, scheduledTime);
}

class _DeviceNotificationsState extends State<DeviceNotifications> {
  String name;
  String description;
  DateTime scheduledTime;

  _DeviceNotificationsState(this.name, this.description, this.scheduledTime);

  @override
  void initState() {
    super.initState();
    var androidInitialize = AndroidInitializationSettings('android_logo');
    var initializationSettings = InitializationSettings(android: androidInitialize);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: selectNotification1
    );
  }

  Future _showNotification() async{
    var androidDetails = AndroidNotificationDetails("ChannelID", "channelName", "channelDescription", importance: Importance.max);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.schedule(0, name, description, scheduledTime, generalNotificationDetails);
  }

  Future _scheduleDailyNotification() async{

    var androidDetails = AndroidNotificationDetails("ChannelID", "channelName", "channelDescription", importance: Importance.max);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.showDailyAtTime(
      0,
      name,
      description,
      Time(22,58,00),
      generalNotificationDetails,
    );
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
          RaisedButton(onPressed: _scheduleDailyNotification, child: Text("Create daily notification") ),
          RaisedButton(
            child: Text("See pending notifications"),
            onPressed: () async {
              final List<PendingNotificationRequest> pendingNotificationRequests = await flutterLocalNotificationsPlugin.pendingNotificationRequests();
              for(var p in pendingNotificationRequests){
                print(p.id);
              }
            }
          ),
          RaisedButton(
            child: Text("Delete all pending notifications"),
            onPressed: () async {
              // cancel the notification with id value of zero
              await flutterLocalNotificationsPlugin.cancelAll();
            })
        ],
      ),
    );
  }

  Future selectNotification1(String payload) async {
    showDialog(
      context: context,
      child: Text("Notification selected: "),
    );
  }
}