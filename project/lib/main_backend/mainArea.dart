import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:project/authentication_files/logInPageRedirect.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/dashboard_files/dashboard.dart';
import 'package:project/deviceNotification_files/devNotificationPage.dart';
import 'package:project/deviceNotification_files/onSelectPage.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:project/notifications_files/notificationPage.dart';
import 'package:project/patient_files/changeUser.dart';
import 'package:project/prescriptions_files/prescriptions.dart';
import 'package:project/authentication_files/authentication.dart';
import 'package:project/qr_files/generateQrPage.dart';
import 'package:provider/provider.dart';

import 'main.dart';

User fbUser;
String deviceID = "";
String currentPatientID = "";
int recentIndex = 1;

class MainArea extends StatefulWidget {

  int currentIndex;

  MainArea(this.currentIndex);

  @override
  _MainAreaState createState() => _MainAreaState(currentIndex);
}

class _MainAreaState extends State<MainArea> {

  int _currentIndex;
  _MainAreaState(this._currentIndex);

  final List<Widget> _children = [
    CalendarPage(),
    DashboardPage(),
    PrescriptionPage(),
  ];

  @override
  initState() {
    super.initState();
    fbUser = FirebaseAuth.instance.currentUser;
    if(fbUser==null){
      initialiseDeviceID();
    }

    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    var androidInitialize = AndroidInitializationSettings('android_logo');
    var initializationSettings = InitializationSettings(android: androidInitialize);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: fbUser == null ? Text('PRESCRIPTION MANAGEMENT') : Text("LOGGED IN AS: " + fbUser.email.toString()),
        ),

        //DRAWER MENU
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.blue,
                ),
                child: Text(
                  'Menu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),

              //ensure notifications tabs only shows if either: (carer is logged in) OR (offline mode AND patient selected)
              fbUser == null ?
              (currentPatientID != "" ?
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()),
                  );
                },
              ) :
              SizedBox()) :
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()),
                  );
                },
              ),

              // //if patient has been selected, show notifications tab
              // currentPatientID != "" ?
              // ListTile(
              //   leading: Icon(Icons.notifications),
              //   title: Text('Notifications'),
              //   onTap: () {
              //     Navigator.push(
              //       context,
              //       MaterialPageRoute(builder: (context) => NotificationsPage()),
              //     );
              //   },
              // ) :
              //     SizedBox(),

              //if patient has been selected, show my details tab
              currentPatientID != "" ?
              ListTile(
                leading: Icon(Icons.person),
                title: Text('My details'),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GenerateQrPage()),
                  );
                }
              ) :
                  SizedBox(),

              //if patient has been selected, show reminders tab
              currentPatientID != "" ?
              ListTile(
                  leading: Icon(Icons.alarm_add),
                  title: Text('Reminders'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DevNotificationPage()),
                    );
                  }
              ) :
              SizedBox(),

              //if not signed in, show sign in button and if signed in, show sign out button.
              fbUser == null ?
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPageRedirect()),
                  );
                },
                leading: Icon(Icons.login),
                title: Text('Log in as carer'),
              ) :
              ListTile(
                onTap: () {
                  context.read<AuthenticationService>().signOut();
                  currentPatientID = "";
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPageRedirect()),
                  );
                },
                leading: Icon(Icons.logout),
                title: Text('Log out'),
              ),

              //Choose a patient
              ListTile(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeUserPage()),
                  );
                },
                leading: Icon(Icons.swap_horiz),
                title: Text('Select a patient'),
              ),
            ],
          ),
        ),

        //WHAT IS CURRENTLY BEING DISPLAYED
        body: _children[_currentIndex],

        //TAB SWITCHER
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: new Icon(Icons.calendar_today),
              label: "Calendar",
            ),
            BottomNavigationBarItem(
              icon: new Icon(Icons.home),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              label: 'Prescriptions',
            )
          ],
        ),
      ),
    );
  }
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  Future selectNotification(String payload) async {
    print("NOTIFICATION HAS BEEN SELECTED");
    if (payload != null) {
      debugPrint('notification payload: $payload');
    }

    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => OnSelectPage()),
    // );

    var popUp = PopupAlert("SUCCESS", "Notification has been pressed");
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return popUp;
      },
    );

  }
}

Future<void> initialiseDeviceID() async {
  var deviceInfo = DeviceInfoPlugin();
  var androidDeviceInfo = await deviceInfo.androidInfo;
  FirebasePage().createDevice(androidDeviceInfo.androidId);
  deviceID = androidDeviceInfo.androidId;
}
