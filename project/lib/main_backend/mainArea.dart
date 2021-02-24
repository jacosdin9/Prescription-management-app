import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info/device_info.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:project/authentication_files/logInPageRedirect.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/dashboard_files/dashboard.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:project/notifications_files/notificationPage.dart';
import 'package:project/patient_files/changeUser.dart';
import 'package:project/prescriptions_files/editPrescription.dart';
import 'package:project/prescriptions_files/prescriptions.dart';
import 'package:project/authentication_files/authentication.dart';
import 'package:project/qr_files/generateQrPage.dart';
import 'package:project/report_files/graph.dart';
import 'package:provider/provider.dart';
import 'main.dart';

User fbUser;
String deviceID = "";
String currentPatientID = "";
int recentIndex = 1;
var pageView;

class MainArea extends StatefulWidget {

  int currentIndex;

  MainArea(this.currentIndex);

  @override
  _MainAreaState createState() => _MainAreaState(currentIndex);
}

class _MainAreaState extends State<MainArea> {

  int _currentIndex;
  _MainAreaState(this._currentIndex);
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

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification,
    );

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
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => LogInPageRedirect()),
                  );

                  setState(() {
                    page = viewPage(_currentIndex);
                  });
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

                  patientName = await findPatientNameFromID(deviceID, currentPatientID);

                  patientsRemindersForToday = findTodaysDosesForPatient(selectedRemindersList);
                  patientsRemindersForToday.sort((a,b) => a.get("time").compareTo(b.get("time")));

                  setState(() {
                    page = viewPage(_currentIndex);
                  });

                },
                leading: Icon(Icons.swap_horiz),
                title: Text('Select a patient'),
              ),

              //Show report graph for patient
              currentPatientID != "" ?
              ListTile(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Graph()),
                  );

                  setState(() {
                    page = viewPage(_currentIndex);
                  });

                },
                leading: Icon(Icons.bar_chart),
                title: Text('Show stock report'),
              ) : SizedBox(),
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

  Future selectNotification(String payload) async {
    var popUp;
    print("NOTIFICATION HAS BEEN SELECTED");

    //stock reminder onSelect
    if(payload[0] == '!'){
      List split = (payload.substring(1)).split("**");
      popUp = PopupAlert("STOCK REMINDER", split[1] + " has fallen below it's stock reminder. Remember to refill!\n\n Current stock: " + split[0]);
    }

    //reminder notification
    else if (payload[0] == '?') {
      debugPrint('notification payload: $payload');

      List split = (payload.substring(1)).split("**");
      CollectionReference cr;
      String prescriptionName;

      //if reminder is for a local device
      if(split[0] == "devices"){
        cr = FirebaseFirestore.instance.collection("devices").doc(split[1]).collection("patients").doc(split[2]).collection("prescriptions");
        prescriptionName = split[3];
      }
      else{
        cr = FirebaseFirestore.instance.collection("controlledPatients").doc(split[1]).collection("prescriptions");
        prescriptionName = split[2];
      }

      await FirebasePage().findStockToReduce(cr, prescriptionName);
      DateTime now = DateTime.now();
      DateTime today = DateTime(now.year, now.month, now.day);
      FirebasePage().addRecord(prescriptionName, today, tempInt);

      popUp = PopupAlert(prescriptionName + " reminder", "Reminder for " + prescriptionName + " has successfully been received.");

    }

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
  currentTimeZone = await FlutterNativeTimezone.getLocalTimezone();

  FirebasePage().createDevice(androidDeviceInfo.androidId);
  deviceID = androidDeviceInfo.androidId;

  FirebasePage().downloadOverallReminders();
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