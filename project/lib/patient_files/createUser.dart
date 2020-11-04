import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/mainArea.dart';

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
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.assignment_turned_in),
                  child: Text("Required"),
                ),
                Tab(
                  icon: Icon(Icons.access_alarms),
                  child: Text("Optional"),
                ),
                Tab(
                  icon: Icon(Icons.directions_bike),
                  child: Text("Optional"),
                ),
              ],
            ),
            title: Text('Create User'),
          ),
          body: Stack(
            children: <Widget>[
              //CURRENT TAB PAGE VIEW
              TabBarView(
                children: [
                  //PAGE1
                  Scaffold(
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
                                  focusNode: myFocusNode,
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
                                  focusNode: myFocusNode,
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
                                  focusNode: myFocusNode,
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
                                  focusNode: myFocusNode,
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

                  //PAGE2
                  Icon(Icons.directions_transit),

                  //PAGE 3
                  Icon(Icons.directions_bike),
                ],
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

                      Navigator.pop(context);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}