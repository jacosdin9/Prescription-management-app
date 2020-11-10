import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/authentication_files/logInPageRedirect.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/dashboard_files/dashboard.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/notifications_files/notificationPage.dart';
import 'package:project/patient_files/changeUser.dart';
import 'package:project/prescriptions_files/prescriptions.dart';
import 'package:project/authentication_files/authentication.dart';
import 'package:project/qr_files/generateQrPage.dart';
import 'package:provider/provider.dart';

User fbUser;
String deviceID = "";
String currentPatientID = "";

class MainArea extends StatefulWidget {

  @override
  _MainAreaState createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  _MainAreaState();

  int _currentIndex = 1;
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

              //if patient has been selected, show notifications tab
              currentPatientID != "" ?
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
                  SizedBox(),

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
}

Future<void> initialiseDeviceID() async {
  var deviceInfo = DeviceInfoPlugin();
  var androidDeviceInfo = await deviceInfo.androidInfo;
  FirebasePage().createDevice(androidDeviceInfo.androidId);
  deviceID = androidDeviceInfo.androidId;
}