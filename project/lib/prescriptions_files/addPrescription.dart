import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:weekday_selector/weekday_selector.dart';

class AddPrescription extends StatefulWidget{
  @override
  _AddPrescriptionState createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription> with AutomaticKeepAliveClientMixin<AddPrescription>{

  @override
  bool get wantKeepAlive => true;

  //page 1 variables
  String pName;
  double pStrength;
  String pStrengthUnits;

  //page 2 variables
  String dropDownValue = 'None';
  List times = [];
  var values = List.filled(7, true);
  int interval = 1;

  //page 3 variables
  List stockReminders = [];
  int stockNo = 0;
  TimeOfDay stockTime;
  int currentStock = 0;

  TextEditingController nameController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController strengthUnitsController = TextEditingController();

  final _formKey1 = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
                physics: NeverScrollableScrollPhysics(),
                children: [

                  //PAGE1 ----------------------------------------------------------------------------------------------------------------------
                  Scaffold(
                    body: Form(
                      key: _formKey1,
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
                                  controller: nameController,
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

                          //STRENGTH
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
                                  controller: strengthController,
                                  onSaved: (String value){pStrength=double.parse(value);},
                                  focusNode: myFocusNode,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Strength",
                                    hintText: "Enter strength of prescription",
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
                                  controller: strengthUnitsController,
                                  onSaved: (String value){pStrengthUnits=value;},
                                  focusNode: myFocusNode,
                                  decoration: InputDecoration(
                                    labelText: "Units",
                                    hintText: "Enter strength units",
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
                        ],
                      ),
                    ),
                  ),

                  //PAGE2------------------------------------------------------------------------------------------------------------------
                  Scaffold(
                    body: Column(
                      children: [
                        Center(
                          child: Text(
                            "How frequently would you like to receive reminders?",
                          ),
                        ),
                        Container(
                          child: DropdownButton<String>(
                            value: dropDownValue,
                            icon: Icon(Icons.arrow_downward),
                            iconSize: 24,
                            elevation: 16,
                            style: TextStyle(color: Colors.deepPurple),
                            underline: Container(
                              height: 3,
                              color: Colors.deepPurpleAccent,
                            ),
                            onChanged: (String newValue) {
                              setState(() {
                                dropDownValue = newValue;
                              });
                            },
                            items: <String>["None", "Daily", "Specific days", "Days interval"]
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),

                        renderFreqWidget(dropDownValue),
                      ],
                    ),
                  ),

                  //PAGE 3 ----------------------------------------------------------------------------------------------------------------------
                  Scaffold(
                    body: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text("Would you like to set up a reminder for when stock falls below a certain level?"),
                              Container(
                                height: 200,
                                margin: const EdgeInsets.all(50.0),
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent)
                                ),
                                child: CustomScrollView(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: false,
                                  slivers: <Widget>[
                                    SliverPadding(
                                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                                      sliver: SliverList(
                                        delegate: SliverChildBuilderDelegate(
                                              (context, index) =>
                                              Text(stockReminders[index].toString()),
                                          childCount: stockReminders.length,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              //Select current stock number
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red),
                                ),
                                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                                onPressed: () {
                                  _currentStockNumberPicker();
                                },
                                child: Text(
                                  "Select current stock number\n" + currentStock.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),

                              //select stock limit number
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red),
                                ),
                                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                                onPressed: () {
                                  _stockLimitNumberPicker();
                                },
                                child: Text(
                                  "Select stock limit\n" + stockNo.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),

                              //select stock reminder time
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red),
                                ),
                                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                                onPressed: () async {
                                  Future<TimeOfDay> selectedTime = showTimePicker(
                                    initialTime: TimeOfDay.now(),
                                    context: context,
                                  );
                                  if(await selectedTime != null){
                                      stockTime = (await selectedTime);
                                      print(stockTime);
                                      setState(() {});
                                  }
                                },
                                child: Text(
                                  "Select time for stock reminder\n" + stockTime.toString(),
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),

                              //add reminder to list
                              RaisedButton(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.red),
                                ),
                                padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
                                onPressed: () {
                                  setState(() {
                                    stockReminders.add(stockNo.toString() + "***" + stockTime.toString());
                                  });
                                },
                                child: Text(
                                  "Add stock reminder",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
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
                    if (_formKey1.currentState.validate()) {
                      _formKey1.currentState.save();
                      print(pName);
                      print(pStrength);
                      print(pStrengthUnits);
                      print(dropDownValue);
                      print(times);
                      print(values);
                      print(interval);
                      print(stockReminders);
                      print(stockNo);
                      FirebasePage().addPrescription(pName, pStrength, pStrengthUnits, dropDownValue, times, values, interval, stockReminders, stockNo);
                      var popUp = PopupAlert("SUCCESS", "Prescription has successfully been added");
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
          ),
        ),
      ),
    );
  }

  _currentStockNumberPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 10000,
            title: Text("Current stock value"),
            initialIntegerValue: currentStock,
          );
        }
    ).then((value) => {
      if(value != null){
        setState(() => currentStock = value),
      }
    });
  }

  _stockLimitNumberPicker() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return NumberPickerDialog.integer(
            minValue: 0,
            maxValue: 10000,
            title: Text("Stock reminder value"),
            initialIntegerValue: stockNo,
          );
        }
    ).then((value) => {
      if(value != null){
        setState(() => stockNo = value),
      }
    });
  }

  renderFreqWidget(String freq) {
    if(freq == "None"){
      return Text("NONE SELECTED");
    }

    else{
      return Column(
        children: [
          renderFreqExtra(freq),
          Container(
            height: 200,
            margin: const EdgeInsets.all(50.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blueAccent)
            ),
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                          Text(times[index].toString()),
                      childCount: times.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
          RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
              side: BorderSide(color: Colors.red),
            ),
            padding: EdgeInsets.fromLTRB(30, 30, 30, 30),
            onPressed: () async {
              Future<TimeOfDay> selectedTime = showTimePicker(
                initialTime: TimeOfDay.now(),
                context: context,
              );
              if(await selectedTime != null){
                times.add((await selectedTime).toString());
                setState(() {});
              }
            },
            child: Text(
              "Add time",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
          ),
        ],
      );
    }
  }

  renderFreqExtra(freq){
    if(freq == "Specific days"){
      return Column(
        children: [
          WeekdaySelector(
            onChanged: (int day) {
              setState(() {
                final index = day % 7;
                values[index] = !values[index];
              });
            },
            values: values,
          ),
        ],
      );
    }
    else if(freq == "Days interval"){
      return Column(
        children: [
          Text("Select an interval of days"),
          NumberPicker.integer(
            initialValue: interval,
            minValue: 0,
            maxValue: 6,
            onChanged: (newValue) =>
                setState(() => interval = newValue)
          )
        ],
      );
    }
    else{
      return SizedBox();
    }
  }
}

