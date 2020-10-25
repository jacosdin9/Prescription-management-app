import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/authentication_files/authentication.dart';
import 'package:provider/provider.dart';

class LogInPage extends StatelessWidget {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //EMAIL INPUT
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email Address",
                    hintText: "Enter email address",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Please enter a valid email address.";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),

          //PASSWORD INPUT
          Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius: new BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 15, right: 15, top: 5),
                child: TextFormField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    hintText: "Enter password",
                    border: InputBorder.none,
                  ),
                  validator: (value) {
                    if(value.isEmpty){
                      return "Please enter a valid password";
                    }
                    return null;
                  },
                ),
              ),
            ),
          ),

          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red),
            ),
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            onPressed: () {
              context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              );
            },
            child: Text(
              "LOG IN",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      )
    );
  }

}