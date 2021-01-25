import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:project/authentication_files/logInPageRedirect.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/dashboard_files/dashboard.dart';
import 'package:project/deviceNotification_files/devNotificationPage.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:project/notifications_files/notificationPage.dart';
import 'package:project/patient_files/changeUser.dart';
import 'package:project/prescriptions_files/prescriptions.dart';
import 'package:project/authentication_files/authentication.dart';
import 'package:project/qr_files/generateQrPage.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'mainArea.dart';

class MainAreaOnline extends StatefulWidget {

  int currentIndex;

  MainAreaOnline(this.currentIndex);

  @override
  _MainAreaOnlineState createState() => _MainAreaOnlineState(currentIndex);
}

class _MainAreaOnlineState extends State<MainAreaOnline> {

  int _currentIndex;
  _MainAreaOnlineState(this._currentIndex);
  var page;

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

    _currentIndex = 1;
    page = _children[_currentIndex];
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
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()),
                  );

                  setState(() {
                    page = viewPage(_currentIndex);
                  });
                },
              ) :
              SizedBox()) :
              ListTile(
                leading: Icon(Icons.notifications),
                title: Text('Notifications'),
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NotificationsPage()),
                  );

                  setState(() {
                    page = viewPage(_currentIndex);
                  });
                },
              ),

              //if patient has been selected, show my details tab
              currentPatientID != "" ?
              ListTile(
                  leading: Icon(Icons.person),
                  title: Text('My details'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GenerateQrPage()),
                    );
                    setState(() {
                      page = viewPage(_currentIndex);
                    });
                  }
              ) :
              SizedBox(),

              //if patient has been selected, show reminders tab
              currentPatientID != "" ?
              ListTile(
                  leading: Icon(Icons.alarm_add),
                  title: Text('Reminders'),
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DevNotificationPage()),
                    );

                    setState(() {
                      page = viewPage(_currentIndex);
                    });
                  }
              ) :
              SizedBox(),

              //if not signed in, show sign in button and if signed in, show sign out button.
              fbUser == null ?
              ListTile(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPageRedirect()),
                  );

                  setState(() {
                    page = viewPage(_currentIndex);
                  });
                },
                leading: Icon(Icons.login),
                title: Text('Log in as carer'),
              ) :
              ListTile(
                onTap: () async {
                  context.read<AuthenticationService>().signOut();
                  currentPatientID = "";
                  var deviceInfo = DeviceInfoPlugin();
                  var androidDeviceInfo = await deviceInfo.androidInfo;
                  currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();
                  deviceID = androidDeviceInfo.androidId;

                  Navigator.pop(context);
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPageRedirect()),
                  );
                },
                leading: Icon(Icons.logout),
                title: Text('Log out'),
              ),

              //Choose a patient
              ListTile(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChangeUserPage()),
                  );

                  setState(() {
                    page = viewPage(_currentIndex);
                  });

                },
                leading: Icon(Icons.swap_horiz),
                title: Text('Select a patient'),
              ),
            ],
          ),
        ),

        //WHAT IS CURRENTLY BEING DISPLAYED
        body: page,

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
      page = _children[index];
    });
  }

}

viewPage (int i){
  switch(i){
    case 0:{
      return CalendarPage();
    }
    case 1:{
      return DashboardPage();
    }
    case 2:{
      return PrescriptionPage();
    }
    default:{
      return DashboardPage();
    }
  }
}