import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:qrscan/qrscan.dart' as scanner;

int sent;
var newPopUp;

class AddExistingPatient extends StatefulWidget{
  @override
  _AddExistingPatient createState() => _AddExistingPatient();
}

class _AddExistingPatient extends State<AddExistingPatient>{

  String deviceId;
  String patientId;
  TextEditingController deviceController = TextEditingController();
  TextEditingController patientController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode;

    @override
    void initState() {
      super.initState();
      myFocusNode = FocusNode();
      sent = 2;
    }

    @override
    void dispose() {
      myFocusNode.dispose();
      super.dispose();
    }

    return MaterialApp(
      title: "Add Existing Patient",
      home: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              title: Text("Add Existing Patient"),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //Device ID
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
                          controller: deviceController,
                          onSaved: (String value){deviceId=value;},
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                            labelText: "Device ID",
                            hintText: "Enter Device ID",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if(value.isEmpty){
                              deviceId = "";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  //Patient ID
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
                          controller: patientController,
                          onSaved: (String value){patientId=value;},
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                            labelText: "Patient ID",
                            hintText: "Enter patient ID",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if(value.isEmpty){
                              return "Please enter a valid patient ID";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  //QR code scan button
                  RaisedButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: BorderSide(color: Colors.red),
                    ),
                    padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                    onPressed: () async {
                      String scanResult = await scanner.scan();
                      var scanSplit = scanResult.split("***");
                      deviceController.text = scanSplit[0];
                      patientController.text = scanSplit[1];

                    },
                    child: Text(
                      "Scan QR code",
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),

          //CANCEL BUTTON
          Positioned(
            left: 20,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: "FAB1",
              backgroundColor: Colors.red,
              child: Icon(Icons.cancel),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),

          //DONE BUTTON
          Positioned(
            right: 20,
            bottom: 20,
            child: FloatingActionButton(
              heroTag: "FAB2",
              backgroundColor: Colors.green,
              child: Icon(Icons.done),
              onPressed: () async {
                // Validate returns true if the form is valid, otherwise false.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  await FirebasePage().createCarerRequest(fbUser.uid, deviceId, patientId);
                  Navigator.pop(context);
                  sentState(sent);
                }
              },
            ),
          ),
        ],
      ),
    );
  }
  sentState(int state){
    switch(state){
      case 1: {
        newPopUp = PopupAlert("SUCCESS", "CARER REQUEST SENT SUCCESSFULLY");
      }
      break;

      case 2: {
        newPopUp = PopupAlert("ERROR", "PATIENT NOT FOUND");
      }
      break;

      case 3: {
        newPopUp = PopupAlert("ERROR", "PATIENT ALREADY EXISTS");
      }
      break;
    }

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context){
        return newPopUp;
      },
    );
  }
}
