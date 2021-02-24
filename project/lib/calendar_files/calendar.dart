import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project/deviceNotification_files/reminderPopup.dart';
import 'package:project/main_backend/mainArea.dart';
import 'package:table_calendar/table_calendar.dart';

DateTime lastSelectedDay = DateTime.now();
List lastSelectedEvents = [];


class CalendarPage extends StatefulWidget {
  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage>{

  CalendarController _controller;
  Map<DateTime, List> _events;
  List _selectedEvents;
  List remindersList;

  void setStateIfMounted() {
    if (mounted) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    recentIndex = 0;
    _controller = CalendarController();
    _selectedEvents = lastSelectedEvents;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      remindersList = await downloadRemindersList();
      _events = createCalendar(remindersList);
      setStateIfMounted();
    });

  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _onDaySelected(DateTime day, List events, List holidays) async {
    print('CALLBACK: _onDaySelected');
    lastSelectedDay = day;
    lastSelectedEvents = events;
    events.sort((a,b) => a.get("time").compareTo(b.get("time")));
    setState(() {
      _selectedEvents = events;
    });
  }

  void _onCalendarCreated(
    DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  void _onVisibleDaysChanged(
    DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TableCalendar(
          calendarController: _controller,
          startingDayOfWeek: StartingDayOfWeek.monday,
          initialCalendarFormat: CalendarFormat.week,
          events: _events,
          onDaySelected: _onDaySelected,
          onCalendarCreated: _onCalendarCreated,
          onVisibleDaysChanged: _onVisibleDaysChanged,
          initialSelectedDay: lastSelectedDay,
          endDay: DateTime.now().add(Duration(days: 80)),

          //customise selected date
          calendarStyle: CalendarStyle(
            todayColor: Colors.grey,
            selectedColor: Colors.red,
          ),

          //customise header
          headerStyle: HeaderStyle(
            formatButtonTextStyle:
            TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
            formatButtonDecoration: BoxDecoration(
              color: Colors.deepOrange[400],
              borderRadius: BorderRadius.circular(16.0),
            ),
          ),
          availableCalendarFormats: const {
            CalendarFormat.month: 'Show Month',
            CalendarFormat.week: 'Show Week',
          }
        ),

        //events displayed here below calendar
        Expanded(
          child: Container(
            child: CustomScrollView(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              slivers: <Widget>[
                SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                          (context, index) =>
                              GestureDetector(
                                onTap: () {
                                  var popUp = ReminderPopup(_selectedEvents[index].id, _selectedEvents[index].get('frequency'), _selectedEvents[index].get('id'), _selectedEvents[index].get('patientId'), _selectedEvents[index].get('time'), _selectedEvents[index].get('day'), _selectedEvents[index].get('interval'), _selectedEvents[index].get('prescription'));
                                  showDialog(
                                    context: context,
                                    barrierDismissible: true,
                                    builder: (BuildContext context){
                                      return popUp;
                                    },
                                  );
                                },
                                child: Container(
                                  height: 50,
                                  margin: const EdgeInsets.all(15.0),
                                  padding: const EdgeInsets.all(10.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.blueAccent, width: 6),
                                    borderRadius: BorderRadius.all(Radius.circular(20)),
                                    color: Colors.grey,
                                  ),
                                  child: Text(_selectedEvents[index].get("time") + " - " + _selectedEvents[index].get("patientId") + " - " + _selectedEvents[index].get("prescription")),
                                ),
                              ),
                      childCount: _selectedEvents.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

//returns a list of reminders from current device/carer
downloadRemindersList() async {
  //if logged in, show carer's reminders list. else show local device's patients.
  CollectionReference cr = fbUser != null ?
  FirebaseFirestore.instance.collection('carers').doc(fbUser.uid).collection('overallReminders')
      :
  FirebaseFirestore.instance.collection('devices').doc(deviceID).collection('reminders')
  ;

  QuerySnapshot querySnapshot = await cr.get();
  return querySnapshot.docs;
}

//creates the events calendar using the list of reminders
createCalendar(List reminders){
  Map<DateTime, List> events = {};

  for(QueryDocumentSnapshot rem in reminders){
    DateTime dateToAdd;

    //if reminder if for a specific day
    if(rem.get("frequency") == "Specific days"){
      dateToAdd = findNextInstanceOfDay(int.parse(rem.get("day")));

      for(int i=0; i<10; i++){
        events.putIfAbsent(dateToAdd, () => List());
        events[dateToAdd].add(rem);
        dateToAdd = dateToAdd.add(Duration(days: 7));
      }
    }

    //if reminder is to be daily
    else if(rem.get("frequency") == "Daily"){
      var nowFull = DateTime.now();
      dateToAdd = DateTime(nowFull.year, nowFull.month, nowFull.day);

      for(int i=0; i<70; i++){
        events.putIfAbsent(dateToAdd, () => List());
        events[dateToAdd].add(rem);
        dateToAdd = dateToAdd.add(Duration(days: 1));
      }
    }

    //if reminder is a one off
    else if(rem.get("frequency") == "Single"){
      String day = rem.get("day");
      List daySplit = day.split('/');
      dateToAdd = DateTime(int.parse(daySplit[2]), int.parse(daySplit[1]), int.parse(daySplit[0]));

      events.putIfAbsent(dateToAdd, () => List());
      events[dateToAdd].add(rem);
    }

    //if reminder is every *interval* days
    else if(rem.get("frequency") == "Days interval"){
      var nowFull = DateTime.now();
      dateToAdd = DateTime(nowFull.year, nowFull.month, nowFull.day);
      int i = 0;
      int interval = rem.get("interval");

      while(i < 70){
        events.putIfAbsent(dateToAdd, () => List());
        events[dateToAdd].add(rem);
        dateToAdd = dateToAdd.add(Duration(days: interval));
        i += interval;
      }
    }
  }

  return events;
}

//finds the next date of the requested day
findNextInstanceOfDay(int day){
  var nowFull = DateTime.now();
  DateTime now = DateTime(nowFull.year, nowFull.month, nowFull.day);

  if(day == 0){
    day = 7;
  }

  while(now.weekday!=(day))
  {
    now=now.add(Duration(days: 1));
  }

  return now;
}
