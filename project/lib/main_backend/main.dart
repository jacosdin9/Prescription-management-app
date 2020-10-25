import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:project/authentication_files/logInPageRedirect.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(LogInPageRedirect());
}
