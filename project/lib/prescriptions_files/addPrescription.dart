import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:numberpicker/numberpicker.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/main.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:project/prescriptions_files/prescriptions.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:intl/date_symbols.dart';
import 'package:intl/date_symbol_data_local.dart';

class AddPrescription extends StatefulWidget{
  @override
  _AddPrescriptionState createState() => _AddPrescriptionState();
}

class _AddPrescriptionState extends State<AddPrescription>{

  DateTime today;
  DateTime lastRestockDate;

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
  bool silentReminders = false;

  double boxHeight;
  double boxWidth;

  //page 3 variables
  int stockNo = 0;
  int currentStock = 0;

  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    boxHeight = 200;
    boxWidth = 400;

    today = DateTime.now();
    lastRestockDate = DateTime(today.year, today.month, today.day);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                  child: Text("     Info\n(required)"),
                ),
                Tab(
                  icon: Icon(Icons.access_alarms),
                  child: Text("Reminders\n (optional)"),
                ),
                Tab(
                  icon: Icon(Icons.poll),
                  child: Text("   Stock\n(optional)"),
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
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  controller: nameController,
                                  onSaved: (String value){pName=value;},
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
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  controller: strengthController,
                                  onSaved: (String value){pStrength=double.parse(value);},
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
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  controller: strengthUnitsController,
                                  onSaved: (String value){pStrengthUnits=value;},
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
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                  controller: unitsPerDosageController,
                                  keyboardType: TextInputType.number,
                                  onSaved: (String value){pUnitsPerDosage=int.parse(value);},
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
                    body:
                        Center(
                          child: Column(
                            children: [
                              AnimatedContainer(
                                margin: const EdgeInsets.all(20.0),
                                alignment: Alignment.center,
                                padding: const EdgeInsets.all(3.0),
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  border: Border.all(color: Colors.blueAccent),
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                duration: Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn,
                                height: boxHeight,
                                width: boxWidth,
                                child: Column(
                                  children: [
                                    Text(
                                      "\nWhen should the medication be taken?",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 30,
                                      ),
                                    ),

                                    SizedBox(height: 10),

                                    Container(
                                      child: DropdownButton<String>(
                                        value: dropDownValue,
                                        icon: Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: TextStyle(
                                          color: Colors.deepPurple,
                                          fontSize: 30,
                                        ),
                                        underline: Container(
                                          height: 3,
                                          color: Colors.deepPurpleAccent,
                                        ),
                                        onChanged: (String newValue) {
                                          setState(() {
                                            dropDownValue = newValue;

                                            if(newValue == 'None'){
                                              boxHeight = 200;
                                              boxWidth = 400;
                                            }

                                            else if(newValue == 'Daily'){
                                              boxHeight = 600;
                                              boxWidth = 500;
                                            }

                                            else if(newValue == 'Specific days'){
                                              boxHeight = 650;
                                              boxWidth = 500;
                                            }

                                          });
                                        },
                                        items: ["None", "Daily", "Specific days"]
                                            .map((value) => DropdownMenuItem(
                                          child: SizedBox(
                                            width: 240.0, // for example
                                            child: Text(value + '\n', textAlign: TextAlign.center),
                                          ),
                                          value: value,
                                        )).toList(),
                                      ),
                                    ),

                                    renderFreqWidget(dropDownValue),

                                    dropDownValue != "None" ?
                                        Container(
                                          margin: const EdgeInsets.all(20.0),
                                          alignment: Alignment.center,
                                          padding: const EdgeInsets.all(3.0),
                                          decoration: BoxDecoration(
                                            color: Colors.red,
                                            border: Border.all(color: Colors.blueAccent),
                                            borderRadius: BorderRadius.all(Radius.circular(20)),
                                          ),
                                          height: 50,
                                          width: 400,

                                          child: Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              IconButton(
                                                icon: Icon(Icons.info),
                                                onPressed: () {
                                                  var popUp = PopupAlert("Silent reminders", "- You won't receive a reminder for each and every dose\n- Dose times will still be recorded to assist stock refill reminders.");

                                                  showDialog(
                                                    context: context,
                                                    barrierDismissible: true,
                                                    builder: (BuildContext context){
                                                      return popUp;
                                                    },
                                                  );
                                                },
                                              ),
                                              Text(
                                                "Automatically take ",
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: 30,
                                                ),
                                              ),
                                              Checkbox(
                                                  value: silentReminders,
                                                  onChanged: (bool newValue) {
                                                    setState(() {
                                                      silentReminders = newValue;
                                                    });
                                                  }
                                              ),
                                            ],
                                          ),
                                        )
                                     : SizedBox(),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )

                  ),

                  //PAGE 3 ----------------------------------------------------------------------------------------------------------------------
                  Scaffold(
                    body: Column(
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text("\nWould you like to set up a reminder for when stock falls below a certain level?"),

                              SizedBox(height: 200,),

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
                                  "Select stock limit\n" + stockNo.toString(),
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
                    bool nameExists = await checkIfNameExists(nameController.text);
                    // Validate returns true if the form is valid, otherwise false.
                    if (_formKey1.currentState.validate() && nameExists == false) {
                      _formKey1.currentState.save();
                      print(pName);
                      print(pStrength);
                      print(pStrengthUnits);
                      print(dropDownValue);
                      print(times);
                      print(values);
                      print(interval);
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

                      await FirebasePage().addPrescription(pName, pStrength, pStrengthUnits, pUnitsPerDosage, dropDownValue, times, values, interval, stockNo, currentStock, silentReminders, lastRestockDate);
                      createNotifications(pName, dropDownValue, times, values, interval, silentReminders, pUnitsPerDosage, currentStock, stockNo);
                      DateTime now = DateTime.now();
                      DateTime today = DateTime(now.year, now.month, now.day);
                      FirebasePage().addRecord(pName, today, currentStock);

                      if(fbUser != null){
                        await FirebasePage().updateCarerReminders();
                      }
                    }

                    else if(nameExists == true){
                      var popUp = PopupAlert("NAME ALREADY EXISTS", "Prescription name already exists for this patient.\n\nPlease try again.");
                      showDialog(
                        context: context,
                        barrierDismissible: true,
                        builder: (BuildContext context){
                          return popUp;
                        },
                      );
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
        setState(() => stockNo = value, ),
      }
    });
  }

  //Render widgets depending on freq variable
  renderFreqWidget(String freq) {
    if(freq == "None"){
      return SizedBox();
    }

    else{
      return Column(
        children: [
          renderFreqExtra(freq),
          Container(
            height: 200,
            margin: const EdgeInsets.all(20.0),
            padding: const EdgeInsets.all(3.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.blueAccent),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              color: Colors.white,

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
                              Row(
                                children: [
                                  Text(
                                    times[index].toString(),
                                    style: TextStyle(
                                      fontSize: 20,
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete_forever),
                                    onPressed: () {
                                      times.removeAt(index);
                                      setState(() {});
                                    },
                                  )
                                ],
                              ),
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

  //renders extra widget depending on freq variable
  renderFreqExtra(freq){

    final locale = Localizations.localeOf(context);
    final DateSymbols dateSymbols = dateTimeSymbolMap()['$locale'];

    if(freq == "Specific days"){
      return Column(
        children: [
          SizedBox(height: 10,),
          WeekdaySelector(
            onChanged: (int day) {
              print((dateSymbols.FIRSTDAYOFWEEK).toString());
              setState(() {
                final index = (day % 7);
                values[index] = !values[index];
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
    // else if(freq == "Days interval"){
    //   return Column(
    //     children: [
    //       Text("Select an interval of days"),
    //       NumberPicker.integer(
    //         initialValue: interval,
    //         minValue: 0,
    //         maxValue: 6,
    //         onChanged: (newValue) =>
    //             setState(() => interval = newValue)
    //       )
    //     ],
    //   );
    // }
    else{
      return SizedBox();
    }
  }
}

createNotifications(String pName, String freq, List times, List dayValues, int interval, bool silentReminders, int unitsPerDosage, int currentStock, int stockLimit) async {

  if(silentReminders == false){
    if(freq == "None"){
      print("No notifications needed");
    }

    else if(freq == "Daily"){
      int rId = await getReminderIdNo();
      for(String time  in times){
        Time t = Time(int.parse(time.split(":")[0]), int.parse(time.split(":")[1]));
        String patientName = await findPatientNameFromID(deviceID, currentPatientID);

        //This will create a reminder for the local device. Need to find a good way to link online-
        //carer to local notifications now as we don't really want it being added straight to local device
        scheduleDailyNotification(rId, pName, "Hey, " + patientName + "! It's time to take your dose of " + pName, t, currentPatientID);

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
            String patientName = await findPatientNameFromID(deviceID, currentPatientID);

            //This will create a reminder for the local device. Need to find a good way to link online-
            //carer to local notifications now as we don't really want it being added straight to local device
            scheduleWeeklyNotification(rId, pName, "Hey, " + patientName + "! It's time to take your dose of " + pName, t, day, currentPatientID);

            //add reminder to database. Works for both local and carer so this part is okay
            await FirebasePage().addReminder(currentPatientID, pName, rId, freq, time, day.toString(), interval);
            rId += 1;
          }
        }
      }
    }
  }

  //schedule reminders for stock refills only
  else if(silentReminders == true && freq != "None" && currentStock != 0){
    int stockPerDay = times.length * unitsPerDosage;
    int daysTilLimit = 0;
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(currentTimeZone));
    tz.TZDateTime today = tz.TZDateTime.now(tz.local);
    tz.TZDateTime stockRefillDay = tz.TZDateTime(tz.local, today.year, today.month, today.day, 13, 0, 0);
    int rId = await getReminderIdNo();

    //find how many days it will take for currentStock to go below stockLimit

    //if daily
    if(freq == "Daily"){
      while(currentStock > stockLimit){
        daysTilLimit += 1;
        currentStock -= stockPerDay;
      }

      stockRefillDay = stockRefillDay.add(Duration(days: daysTilLimit));
    }

    //if specific days
    else{
      List selectedDays = [];

      //get day integers from selected days
      for(int i = 0; i<dayValues.length; i++){
        if(dayValues[i] == true){

          //if Sunday, change to 7 for consistency
          if(i==0){
            selectedDays.add(7);
            continue;
          }

          selectedDays.add(i);
        }
      }

      //if user chooses Specific days but selects no days, this if statement will avoid a crash
      if(selectedDays.length != 0){

        //iterate through days until current stock falls below limit. Only consider days from dayValues.
        while (currentStock>stockLimit) {
          stockRefillDay = stockRefillDay.add(const Duration(days: 1));

          print(stockRefillDay.weekday);
          if(selectedDays.contains(stockRefillDay.weekday)){
            currentStock -= stockPerDay;
          }
        }
      }
    }

    //ensure currentStock doesn't drop below 0
    if(currentStock < 0){
      currentStock = 0;
    }

    print(stockRefillDay);
    scheduleDateTimeNotification(rId, "Stock reminder", "Stock of this med needs refilled!", stockRefillDay, "!" + currentStock.toString() + "**" + pName);

    //add reminder to database. Works for both local and carer so this part is okay
    await FirebasePage().addReminder(currentPatientID, pName, rId, "Single", "13:00", stockRefillDay.day.toString() + '/' + stockRefillDay.month.toString() + '/' + stockRefillDay.year.toString(), interval);
  }
}

//DAILY NOTIFICATION
Future<void> scheduleDailyNotification(rId, name, description, time, patientId) async {
  var androidDetails = AndroidNotificationDetails("ChannelID", "channelName", "channelDescription", importance: Importance.max, priority: Priority.high);
  var generalNotificationDetails = NotificationDetails(android: androidDetails);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  if(fbUser == null){
    await flutterLocalNotificationsPlugin.zonedSchedule(
      rId,
      name,
      description,
      nextInstanceOfTime(time),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: createPayload(name, patientId),
    );
  }

  else{
    await flutterLocalNotificationsPluginOnline.zonedSchedule(
      rId,
      name,
      description,
      nextInstanceOfTime(time),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.time,
      payload: createPayload(name, patientId),
    );
  }

}

//WEEKLY NOTIFICATION
Future<void> scheduleWeeklyNotification(rId, name, description, time, int dayV, patientId) async {
  var androidDetails = AndroidNotificationDetails("ChannelID", "channelName", "channelDescription", importance: Importance.max, priority: Priority.high);
  var generalNotificationDetails = NotificationDetails(android: androidDetails);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  if(dayV == 0){
    dayV = 7;
  }

  if(fbUser == null){
    await flutterLocalNotificationsPlugin.zonedSchedule(
      rId,
      name,
      description,
      nextInstanceOfWeekly(time, dayV),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: createPayload(name, patientId),
    );
  }

  else{

    await flutterLocalNotificationsPluginOnline.zonedSchedule(
      rId,
      name,
      description,
      nextInstanceOfWeekly(time, dayV),
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      payload: createPayload(name, patientId),
    );
  }

}

tz.TZDateTime nextInstanceOfTime(Time t) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, t.hour, t.minute, t.second);
  if (scheduledDate.isBefore(now)) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

tz.TZDateTime nextInstanceOfWeekly(Time t, int d) {
  tz.TZDateTime scheduledDate = nextInstanceOfTime(t);
  while (scheduledDate.weekday != d) {
    scheduledDate = scheduledDate.add(const Duration(days: 1));
  }
  return scheduledDate;
}

//SCHEDULE STOCK NOTIFICATION FOR SPECIFIC DATE AND TIME
Future<void> scheduleDateTimeNotification(rId, name, description, date, payload) async {
  var androidDetails = AndroidNotificationDetails("ChannelID", "channelName", "channelDescription", importance: Importance.max, priority: Priority.high);
  var generalNotificationDetails = NotificationDetails(android: androidDetails);

  tz.initializeTimeZones();
  tz.setLocalLocation(tz.getLocation(currentTimeZone));

  if(fbUser == null && date.isAfter(DateTime.now())){
    await flutterLocalNotificationsPlugin.zonedSchedule(
      rId,
      name,
      description,
      date,
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }

  else if(date.isAfter(DateTime.now())){

    await flutterLocalNotificationsPluginOnline.zonedSchedule(
      rId,
      name,
      description,
      date,
      generalNotificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
      payload: payload,
    );
  }
}

//the payload will help create the CollectionPath by creating a string that can be split up with a delimiter
String createPayload(String pName, String patientId){
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
  payload += patientId;

  //add delimiter
  payload += "**";

  //add name of prescription. We can use this to query for prescriptionID later
  payload += pName;

  return payload;

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