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

    //if user is logged in
    if(firebaseUser != null){
      signedInBool = true;
      fbUser = firebaseUser;
      return MainArea(signedInBool, fbUser);
    }

    //if user is not logged in
    else{
      signedInBool = false;
      fbUser = null;
      return LogInPage();
    }
  }

}