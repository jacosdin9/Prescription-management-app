import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'mainArea.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StartApp());
}

class StartApp extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MainArea(signedInBool,fbUser),
    );
  }

}