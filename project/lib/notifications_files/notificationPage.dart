import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/notifications_files/carerRequestNotification.dart';

class NotificationsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    //if logged in, look for carers notifications else look for device's notifications
    CollectionReference notifications = fbUser != null ?
      FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('notifications') :
        FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('patients').doc(currentPatientID).collection('notifications');

    return MaterialApp(
      title: "Notifications page",
      home: Scaffold(
        appBar: AppBar(
          title: Text("Notifications page"),
        ),
        body: StreamBuilder<QuerySnapshot>(
            stream: notifications.snapshots(),
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
                Column(
                    children: [
                      //If no patients created yet, ask user to create one. Else display users
                      results.length != 0 ?
                      Expanded(
                        child: new Container(
                          child: new CustomScrollView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: false,
                            slivers: <Widget>[
                              new SliverPadding(
                                padding: const EdgeInsets.symmetric(vertical: 24.0),
                                sliver: new SliverList(
                                  delegate: new SliverChildBuilderDelegate(
                                        (context, index) =>
                                        GestureDetector(
                                          onTap: () {
                                            if(results[index].get('type')=="carer_request"){
                                              var popUp = CarerRequestNotification(results[index].get("carerId"), results[index].id, results[index].get('patientId'));
                                              showDialog(
                                                context: context,
                                                barrierDismissible: true,
                                                builder: (BuildContext context){
                                                  return popUp;
                                                },
                                              );
                                            }
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
                      ) :
                        Center(
                          child: Text("YOU HAVE 0 NOTIFICATIONS"),
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
                            MaterialPageRoute(builder: (context) => MainArea(recentIndex)),
                          );
                        },
                        child: Text(
                          "BACK",
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ]
                );
            }
        ),
      ),
    );
  }

}