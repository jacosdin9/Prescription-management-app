import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/authentication_files/authentication.dart';
import 'package:project/authentication_files/logInPage.dart';
import 'package:project/main_backend/mainArea.dart';
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

      child: MaterialApp(
        title: "Log-in redirect",
        theme: ThemeData(
          primarySwatch: Colors.red,
        ),
        home: AuthenticationWrapper(),
      ),
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

    if(firebaseUser != null){
      return MainArea();
    }
    else{
      return LogInPage();
    }
  }

}