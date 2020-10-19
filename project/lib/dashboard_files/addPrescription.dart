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
      home: Scaffold(
        appBar: AppBar(
          title: Text("Add Prescription"),
        ),
        body: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              //PRESCRIPTION NAME
              TextFormField(
                onSaved: (String value){pName=value;},
                focusNode: myFocusNode,
                decoration: InputDecoration(
                  labelText: "Prescription name",
                  hintText: "Enter prescription name"
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return "Please enter some text";
                  }
                  return null;
                },
              ),

              //DOSAGE
              TextFormField(
                onSaved: (String value){pDosage=double.parse(value);},
                focusNode: myFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Dosage",
                  hintText: "Enter required dosage",
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return "Please enter a value";
                  }
                  return null;
                },
              ),

              //MEASUREMENT
              TextFormField(
                onSaved: (String value){pMeasurement=value;},
                focusNode: myFocusNode,
                decoration: InputDecoration(
                  labelText: "Measurement",
                  hintText: "Enter measurement",
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return "Please enter a valid measurement";
                  }
                  return null;
                },
              ),

              //NO OF REMINDERS
              TextFormField(
                onSaved: (String value){pNoOfReminders=int.parse(value);},
                focusNode: myFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "No. of reminders",
                  hintText: "Enter required no. of reminders",
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return "Please enter a value";
                  }
                  return null;
                },
              ),

              //STOCK
              TextFormField(
                onSaved: (String value){pStock=double.parse(value);},
                focusNode: myFocusNode,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Stock",
                  hintText: "Enter stock number",
                ),
                validator: (value) {
                  if(value.isEmpty){
                    return "Please enter a value";
                  }
                  return null;
                },
              ),
              RaisedButton(
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
                child: Text('Submit'),
              )
            ],
          ),
        ),
      ),
    );



  }

}