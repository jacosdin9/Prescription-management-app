import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/dashboard_files/dashboard.dart';
import 'package:project/prescriptions_files/prescriptions.dart';

class MainArea extends StatefulWidget {
  @override
  _MainAreaState createState() => _MainAreaState();
}

class _MainAreaState extends State<MainArea> {
  int _currentIndex = 1;
  final List<Widget> _children = [
    CalendarPage(),
    DashboardPage(),
    PrescriptionPage(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // Show error message if initialization failed
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('PRESCRIPTION MANAGEMENT'),
        ),

        //DRAWER MENU
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
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
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Users'),
              ),
              ListTile(
                leading: Icon(Icons.format_paint),
                title: Text('Customisation'),
              ),
              ListTile(
                leading: Icon(Icons.settings),
                title: Text('Settings'),
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

