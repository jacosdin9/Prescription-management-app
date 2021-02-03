import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/firebase_files/firebase.dart';
import 'package:project/main_backend/popupAlert.dart';
import 'package:project/prescriptions_files/editPrescription.dart';
import 'package:string_validator/string_validator.dart';
import 'package:weekday_selector/weekday_selector.dart';
import 'package:intl/date_symbols.dart';
import 'package:intl/date_symbol_data_local.dart';

class NameInput extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit Name",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "Enter a new name."),
                ),
                flex: 2,
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () async {
                            var isValid = isAlpha(_textEditingController.text);
                            bool nameExists = await checkIfNameExists(_textEditingController.text);

                            if(isValid && nameExists == false){
                              tempString = _textEditingController.text;
                              Navigator.pop(context);
                            }
                            else{
                              var popUp = PopupAlert("INCORRECT INPUT", "This field must be made up of characters A-Z. Also ensure this name isn't already used too.\n\nPlease try again.");
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return popUp;
                                },
                              );
                            }
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}

class StrengthInput extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit Strength value",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "Enter a new strength value."),
                ),
                flex: 2,
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () {
                            tempString = _textEditingController.text;
                            var isValid = isFloat(tempString);

                            if(isValid){
                              Navigator.pop(context);
                            }
                            else{
                              var popUp = PopupAlert("INCORRECT INPUT", "This field must be either a single integer or float.\n\nPlease try again.");
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return popUp;
                                },
                              );
                            }
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}

class StrengthUnitsInput extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit Strength Units",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "Enter new units for strength value."),
                ),
                flex: 2,
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () {
                            tempString = _textEditingController.text;
                            var isValid = isAlpha(tempString);

                            if(isValid){
                              Navigator.pop(context);
                            }
                            else{
                              var popUp = PopupAlert("INCORRECT INPUT", "This field must be made up of characters A-Z.\n\nPlease try again.");
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return popUp;
                                },
                              );
                            }
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}

class UnitsPerDosageInput extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit units per dosage",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "Enter new units per dosage."),
                ),
                flex: 2,
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () {
                            tempString = _textEditingController.text;
                            var isValid = isNumeric(tempString);

                            if(isValid){
                              Navigator.pop(context);
                            }
                            else{
                              var popUp = PopupAlert("INCORRECT INPUT", "This field must be an integer.\n\nPlease try again.");
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return popUp;
                                },
                              );
                            }
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}

class RemainingStockInput extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit remaining stock",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "Enter new value for remaining stock."),
                ),
                flex: 2,
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () {
                            tempString = _textEditingController.text;
                            var isValid = isNumeric(tempString);

                            if(isValid){
                              Navigator.pop(context);
                            }
                            else{
                              var popUp = PopupAlert("INCORRECT INPUT", "This field must be an integer.\n\nPlease try again.");
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return popUp;
                                },
                              );
                            }
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}

class StockReminderInput extends StatelessWidget {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit stock reminder",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child: TextFormField(
                  controller: _textEditingController,
                  decoration: InputDecoration(hintText: "Enter new value for stock reminder."),
                ),
                flex: 2,
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () {
                            tempString = _textEditingController.text;
                            var isValid = isNumeric(tempString);

                            if(isValid){
                              Navigator.pop(context);
                            }
                            else{
                              var popUp = PopupAlert("INCORRECT INPUT", "This field must be an integer.\n\nPlease try again.");
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (BuildContext context){
                                  return popUp;
                                },
                              );
                            }
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}

class ReminderFrequencyInput extends StatefulWidget {
  @override
  _ReminderFrequencyInputState createState() => _ReminderFrequencyInputState();
}

class _ReminderFrequencyInputState extends State<ReminderFrequencyInput> {

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit reminder frequency",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child: DropdownButton(
                  value: tempString,
                  icon: Icon(Icons.arrow_downward),
                  iconSize: 20,
                  elevation: 16,
                  style: TextStyle(color: Colors.deepPurple),
                  underline: Container(
                    height: 3,
                    color: Colors.deepPurpleAccent,
                  ),
                  onChanged: (String newValue) {
                    setState(() {
                      tempString = newValue;
                    });
                  },
                  items: ["None", "Daily", "Specific days", "Days interval"]
                      .map((value) => DropdownMenuItem(
                    child: SizedBox(
                      width: 240.0, // for example
                      child: Text(value, textAlign: TextAlign.center),
                    ),
                    value: value,
                  )).toList(),
                ),
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}

class ReminderTimesInput extends StatefulWidget {
  @override
  _ReminderTimesInputState createState() => _ReminderTimesInputState();
}

class _ReminderTimesInputState extends State<ReminderTimesInput> {

  List times;

  @override
  void initState() {
    super.initState();
    times = List.from(tempList);
  }
  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height:280.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                    ),
                    child: Text(
                      "Edit reminder times",
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18.0,
                        fontFamily: 'helvetica_neue_light',
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),

              SizedBox(height: 20),

              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child:
                Column(
                  children: [

                    Container(
                      height: 100,
                      margin: const EdgeInsets.all(5.0),
                      padding: const EdgeInsets.all(1.0),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.blueAccent)
                      ),
                      child: CustomScrollView(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: false,
                        slivers: <Widget>[
                          SliverPadding(
                            padding: const EdgeInsets.symmetric(vertical: 2.0),
                            sliver:
                            SliverList(
                              delegate: SliverChildBuilderDelegate(
                                    (context, index) =>

                                    Row(
                                      children: [
                                        Text(times[index].toString()),
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
                ),

              ),

              // dialog bottom
              Row(
                children: [
                  Expanded(
                    child: RaisedButton(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.orange),
                      ),
                      onPressed: () {
                        tempList = times;
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Done",
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      );
  }
}

class ReminderDaysInput extends StatefulWidget {

  final locale;

  ReminderDaysInput(this.locale);

  @override
  _ReminderDaysInputState createState() => _ReminderDaysInputState(locale);
}

class _ReminderDaysInputState extends State<ReminderDaysInput> {

  var locale;
  DateSymbols dateSymbols;
  List<bool> values;

  _ReminderDaysInputState(this.locale);

  @override
  void initState() {
    super.initState();
    dateSymbols = dateTimeSymbolMap()['$locale'];
    print(dateSymbols);
    values = List.from(tempList);
  }

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit reminder days",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Expanded(
                child: WeekdaySelector(
                  onChanged: (int day) {
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
                flex: 2,
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () {
                            tempList = values;
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}

class SilentRemindersInput extends StatefulWidget {

  @override
  _SilentRemindersInputState createState() => _SilentRemindersInputState();
}

class _SilentRemindersInputState extends State<SilentRemindersInput> {

  bool isSwitched;

  @override
  void initState() {
    super.initState();
    isSwitched = tempBool;
  }

  @override
  Widget build(BuildContext context) {
    return
      AlertDialog(
        elevation: 24.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0)),
        ),
        content: Container(
          width: 260.0,
          height: 230.0,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: const Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // dialog top
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                      ),
                      child: Text(
                        "Edit Silent Reminders",
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                          fontFamily: 'helvetica_neue_light',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(vertical: 10.0),
                height: 2.0,
                width: 18.0,
                color: Color(0xff00c6ff),
              ),
              // dialog centre
              Center(
                child:
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {
                      setState(() {
                        isSwitched = value;
                        print(isSwitched);
                      });
                    },
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
              ),

              // dialog bottom
              Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: RaisedButton(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18.0),
                            side: BorderSide(color: Colors.orange),
                          ),
                          onPressed: () {
                            tempBool = isSwitched;
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Done",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              ),
            ],
          ),
        ),
      );
  }
}