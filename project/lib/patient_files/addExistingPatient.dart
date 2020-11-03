import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';

class AddExistingPatient extends StatefulWidget{
  @override
  _AddExistingPatient createState() => _AddExistingPatient();
}

class _AddExistingPatient extends State<AddExistingPatient>{

  String deviceId;
  String patientId;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    FocusNode myFocusNode;

    @override
    void initState() {
      super.initState();
      myFocusNode = FocusNode();
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
                          onSaved: (String value){deviceId=value;},
                          focusNode: myFocusNode,
                          decoration: InputDecoration(
                            labelText: "Device ID",
                            hintText: "Enter Device ID",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if(value.isEmpty){
                              return "Please enter valid device ID";
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
              onPressed: () {
                // Validate returns true if the form is valid, otherwise false.
                if (_formKey.currentState.validate()) {
                  _formKey.currentState.save();
                  print(deviceId);
                  print(patientId);
                  FirebasePage().addExistingPatient(deviceId, patientId);
                  Navigator.pop(context);
                }
              },
            ),
          ),

        ],
      ),
    );
  }
}