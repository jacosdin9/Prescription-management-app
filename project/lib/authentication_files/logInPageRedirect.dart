import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/authentication_files/authentication.dart';
import 'package:project/authentication_files/logInPage.dart';
import 'package:project/calendar_files/calendar.dart';
import 'package:project/dashboard_files/dashboard.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/main_backend/mainAreaOnline.dart';
import 'package:provider/provider.dart';

class LogInPageRedirect extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<AuthenticationService>(
          create: (_) => AuthenticationService(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<AuthenticationService>().authStateChanges,
        )
      ],

      child: Scaffold(
        body: AuthenticationWrapper(),
      )
    );
  }
}

class AuthenticationWrapper extends StatelessWidget{
  const AuthenticationWrapper({
    Key key,
  }) : super (key:key);

  @override
  Widget build(BuildContext context) {
    final firebaseUser = context.watch<User>();

    fbUser = firebaseUser;

    //if user is logged in
    if(firebaseUser != null){
      currentPatientID = "";
      deviceID = "";
      selectedRemindersList = [];
      patientName = "";
      lastSelectedEvents = [];
      print("main area online");
      return MainAreaOnline(1);
    }

    //if user is not logged in
    else{
      fbUser = null;
      print("log in page");
      return LogInPage();
    }
  }

}