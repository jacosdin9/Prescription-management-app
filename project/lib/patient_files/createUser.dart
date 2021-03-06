import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/main_backend/popupAlert.dart';

class CreateUser extends StatefulWidget{
  @override
  _CreateUserState createState() => _CreateUserState();
}

class _CreateUserState extends State<CreateUser>{

  String uName;
  int uAge;
  double uWeight;
  String uMeasurement;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text("Add new patient"),
            ),
            body: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  //USER NAME
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
                          onSaved: (String value){uName=value;},
                          decoration: InputDecoration(
                            labelText: "User name",
                            hintText: "Enter user name",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if(value.isEmpty){
                              return "Please enter some text";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  //AGE
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
                          onSaved: (String value){uAge=int.parse(value);},
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Age",
                            hintText: "Enter user's age",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if(value.isEmpty){
                              return "Please enter a value";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  //WEIGHT
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
                          onSaved: (String value){uWeight=double.parse(value);},
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            labelText: "Weight",
                            hintText: "Enter weight",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if(value.isEmpty){
                              return "Please enter a valid weight";
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                  ),

                  //MEASUREMENT
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
                          onSaved: (String value){uMeasurement=value;},
                          decoration: InputDecoration(
                            labelText: "Measurement",
                            hintText: "Enter valid measurement",
                            border: InputBorder.none,
                          ),
                          validator: (value) {
                            if(value.isEmpty){
                              return "Please enter a value";
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

                  //if not logged in, create local patient to deviceID. else, created controlled patient with user as carer
                  fbUser == null ?
                  FirebasePage().createPatient(deviceID, uName, uAge, uWeight, uMeasurement)
                      :
                  FirebasePage().createControlledPatient(fbUser.uid, uName, uAge, uWeight, uMeasurement)
                  ;
                  var popUp = PopupAlert("SUCCESS", "Patient has successfully been added");
                  showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (BuildContext context){
                      return popUp;
                    },
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ),
        ],
      )


    );
  }
}