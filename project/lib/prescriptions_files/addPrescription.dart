import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/main.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/date_symbols.dart';
import 'package:intl/date_symbol_data_local.dart';


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
  int pUnitsPerDosage;

  TextEditingController nameController = TextEditingController();
  TextEditingController strengthController = TextEditingController();
  TextEditingController strengthUnitsController = TextEditingController();
  TextEditingController unitsPerDosageController = TextEditingController();

  //page 2 variables
  String dropDownValue = 'None';
  List times = [];
  var values = List.filled(7, true);
  int interval = 1;

  //page 3 variables
  List stockReminders = [];
  int stockNo = 0;
  int currentStock = 0;

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

                          //STRENGTH UNITS
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
                                    labelText: "Strength units",
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

                          //UNITS PER DOSAGE
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
                                  controller: unitsPerDosageController,
                                  onSaved: (String value){pUnitsPerDosage=int.parse(value);},
                                  focusNode: myFocusNode,
                                  decoration: InputDecoration(
                                    labelText: "Units per dosage",
                                    hintText: "Enter how many units are taken per dosage.",
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
                                onPressed: () async {
                                  _stockLimitNumberPicker();
                                },
                                child: Text(
                                  "Select stock limit\n",
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
                  onPressed: () async {
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
                      var popUp = PopupAlert("SUCCESS", "Prescription has successfully been added");
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context){
                          return popUp;
                        },
                      );
                      Navigator.pop(context);

                      FirebasePage().addPrescription(pName, pStrength, pStrengthUnits, pUnitsPerDosage, dropDownValue, times, values, interval, stockReminders, currentStock);
                      createNotifications(dropDownValue, times, values, interval);
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
        stockReminders.add(value),
        setState(() => stockNo = value, ),
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
                //ensure TimePicker is always in 24-hour time format
                builder: (BuildContext context, Widget child) {
                  return MediaQuery(
                    data: MediaQueryData(alwaysUse24HourFormat: true),
                    child: child,
                  );
                },
              );
              if(await selectedTime != null){
                times.add((await selectedTime).format(context));
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

    final locale = Localizations.localeOf(context);
    final DateSymbols dateSymbols = dateTimeSymbolMap()['$locale'];

    if(freq == "Specific days"){
      return Column(
        children: [
          WeekdaySelector(
            onChanged: (int day) {
              print((dateSymbols.FIRSTDAYOFWEEK).toString());
              setState(() {
                print(day);
                final index = (day % 7);
                values[index] = !values[index];
                //print(index);
                print(values);
              });
            },
            values: values,
            firstDayOfWeek: dateSymbols.FIRSTDAYOFWEEK + 1,
            shortWeekdays: dateSymbols.STANDALONENARROWWEEKDAYS,
            weekdays: dateSymbols.STANDALONEWEEKDAYS,
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

  createNotifications(String freq, List times, List dayValues, int interval) async {
    if(freq == "None"){
      print("No notifications needed");
    }

    else if(freq == "Daily"){
      int rId = await getReminderIdNo();
      for(String time  in times){
        Time t = Time(int.parse(time.split(":")[0]), int.parse(time.split(":")[1]));

        //This will create a reminder for the local device. Need to find a good way to link online-
        //carer to local notifications now as we don't really want it being added straight to local device
        _scheduleDailyNotification(rId, pName, "Hey, " + currentPatientID + "! It's time to take your dose of " + pName, t);

        //add reminder to database. Works for both local and carer so this part is okay
        await FirebasePage().addReminder(currentPatientID, pName, rId, freq, time, "all", interval);
        rId += 1;
      }
    }

    else if(freq == "Specific days"){
      int rId = await getReminderIdNo();

      //for dayV in day values
      for(int day = 0; day<dayValues.length; day++){
        if(dayValues[day] == true){
          for(String time  in times){
            Time t = Time(int.parse(time.split(":")[0]), int.parse(time.split(":")[1]));

            //This will create a reminder for the local device. Need to find a good way to link online-
            //carer to local notifications now as we don't really want it being added straight to local device
            _scheduleWeeklyNotification(rId, pName, "Hey, " + currentPatientID + "! It's time to take your dose of " + pName, t, day);

            //add reminder to database. Works for both local and carer so this part is okay
            await FirebasePage().addReminder(currentPatientID, pName, rId, freq, time, day.toString(), interval);
            rId += 1;
          }
        }
      }
    }
  }

  //DAILY
  Future<void> _scheduleDailyNotification(rId, name, description, time) async {
    var androidDetails = AndroidNotificationDetails("ChannelID", "channelName", "channelDescription", importance: Importance.max, priority: Priority.high);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    await flutterLocalNotificationsPlugin.zonedSchedule(
        rId,
        name,
        description,
        _nextInstanceOfTime(time),
        generalNotificationDetails,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
        UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
        payload: createPayload(),
    );
  }

  tz.TZDateTime _nextInstanceOfTime(Time t) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, t.hour, t.minute, t.second);
    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  //WEEKLY
  Future<void> _scheduleWeeklyNotification(rId, name, description, time, dayV) async {
    var androidDetails = AndroidNotificationDetails("ChannelID", "channelName", "channelDescription", importance: Importance.max, priority: Priority.high);
    var generalNotificationDetails = NotificationDetails(android: androidDetails);

    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));

    if(dayV == 0){
      dayV = 7;
    }

    print(_nextInstanceOfWeekly(time, dayV));
    
    await flutterLocalNotificationsPlugin.zonedSchedule(
      rId,
      name,
      description,
      _nextInstanceOfWeekly(time, dayV),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: createPayload(),
    );
  }

  tz.TZDateTime _nextInstanceOfWeekly(Time t, int d) {
    tz.TZDateTime scheduledDate = _nextInstanceOfTime(t);
    while (scheduledDate.weekday != d) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }
    return scheduledDate;
  }

  //the payload will help create the CollectionPath by creating a string that can be split up with a delimiter
  String createPayload(){
    String payload = "?";

    //does prescription belong to controlledPatients or device patients
    deviceID != "" ? payload += "devices" : payload += "controlledPatients";

    //add delimiter
    payload += "**";

    if(deviceID != ""){
      payload += deviceID;
      payload += "**";
    }

    //add patientID
    payload += currentPatientID;

    //add delimiter
    payload += "**";

    //add name of prescription. We can use this to query for prescriptionID later
    payload += pName;

    return payload;

  }
}

Day findDayFromDayValue(int dayV){
  switch(dayV){
    case 0:{
      return Day.monday;
    }
    case 1:{
      return Day.tuesday;
    }
    case 2:{
      return Day.wednesday;
    }
    case 3:{
      return Day.thursday;
    }
    case 4:{
      return Day.friday;
    }
    case 5:{
      return Day.saturday;
    }
    case 6:{
      return Day.sunday;
    }
    default:{
      return null;
    }
  }
}

String findDayStringFromDayValue(int dayV){
  switch(dayV){
    case 0:{
      return "Monday";
    }
    case 1:{
      return "Tuesday";
    }
    case 2:{
      return "Wednesday";
    }
    case 3:{
      return "Thursday";
    }
    case 4:{
      return "Friday";
    }
    case 5:{
      return "Saturday";
    }
    case 6:{
      return "Sunday";
    }
    default:{
      return null;
    }
  }
}