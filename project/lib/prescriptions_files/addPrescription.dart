import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';

class AddPrescription extends StatefulWidget{
  @override
  _AddPrescriptionState createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription>{
  String pName;
  double pDosage;
  String pMeasurement;
  int pNoOfReminders;
  double pStock;

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
      title: "Add Prescription",
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
            title: Text('Add Prescription'),
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

                          //PRESCRIPTION NAME
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
                                  onSaved: (String value){pName=value;},
                                  focusNode: myFocusNode,
                                  decoration: InputDecoration(
                                    labelText: "Prescription name",
                                    hintText: "Enter prescription name",
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

                          //DOSAGE
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
                                  onSaved: (String value){pDosage=double.parse(value);},
                                  focusNode: myFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Dosage",
                                    hintText: "Enter required dosage",
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
                                  onSaved: (String value){pMeasurement=value;},
                                  focusNode: myFocusNode,
                                  decoration: InputDecoration(
                                    labelText: "Measurement",
                                    hintText: "Enter measurement",
                                    border: InputBorder.none,
                                  ),
                                  validator: (value) {
                                    if(value.isEmpty){
                                      return "Please enter a valid measurement";
                                    }
                                    return null;
                                  },
                                ),
                              ),
                            ),
                          ),

                          //NO OF REMINDERS
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
                                  onSaved: (String value){pNoOfReminders=int.parse(value);},
                                  focusNode: myFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "No. of reminders",
                                    hintText: "Enter required no. of reminders",
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

                          //STOCK
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
                                  onSaved: (String value){pStock=double.parse(value);},
                                  focusNode: myFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Stock",
                                    hintText: "Enter stock number",
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
                      print(pName);
                      print(pDosage);
                      print(pMeasurement);
                      print(pNoOfReminders);
                      print(pStock);
                      FirebasePage().addPrescription(pName, pDosage, pMeasurement, pNoOfReminders, pStock);
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