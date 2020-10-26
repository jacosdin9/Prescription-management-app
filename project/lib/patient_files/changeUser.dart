import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';
import 'createUser.dart';

class ChangeUserPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    CollectionReference localPatientsRef = FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients');
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Switch user"),
        ),
        body: StreamBuilder<QuerySnapshot>(
          stream: localPatientsRef.snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {

            //IF THERE'S AN ERROR:
            if (snapshot.hasError) {
              return Text('Something went wrong');
            }

            //LOADING STATE:
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            var results = snapshot.data.docs;

            //PRINT DATABASE CONTENTS
            return
              //If no patients created yet, ask user to create one. Else display users
              results.length != 0 ?
              Column(
                children: [
                  Expanded(
                    child: new Container(
                      child: new CustomScrollView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        slivers: <Widget>[
                          new SliverPadding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 24.0),
                            sliver: new SliverList(
                              delegate: new SliverChildBuilderDelegate(
                                    (context, index) =>
                                    GestureDetector(
                                      onTap: () {
                                        currentPatientID = results[index].id;
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => MainArea(signedInBool, fbUser)),
                                        );
                                      },
                                      child: Container(
                                        height: 30,
                                        margin: new EdgeInsets.symmetric(vertical: 8.0),
                                        color: Colors.grey,
                                        child: Text(results[index].id),
                                      ),
                                    ),
                                childCount: results.length,
                              ),
                            ),
                          ),
                        ],
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
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => CreateUser()),
                      );
                    },
                    child: Text(
                      "CREATE USER",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  ),
                ]
              ) :
                Column(
                  children:[
                    Text("PLEASE CREATE A USER"),
                    RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red),
                      ),
                      padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => CreateUser()),
                        );
                      },
                      child: Text(
                        "CREATE USER",
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ],
                );
          }
        ),
      ),
    );
  }
}