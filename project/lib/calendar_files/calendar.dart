import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
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
  DateTime _selectedDay;


  @override
  void initState() {
    super.initState();
    _controller = CalendarController();
    _selectedEvents = lastSelectedEvents;
    _selectedDay = lastSelectedDay;

    //test events
    _events = {
      DateTime.now().add(Duration(days: 1)): [
        'Event A0',
        'Event B0',
        'Event C0'
      ],
      DateTime.now().add(Duration(days: 2)): [
        'Event A1',
        'Event A2'
      ],
      DateTime.now().add(Duration(days: 3)): [
        'Event A2',
        'Event B2',
        'Event C2',
        'Event D2'
      ],
    };
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events, List holidays) {
    print('CALLBACK: _onDaySelected');
    lastSelectedDay = day;
    lastSelectedEvents = events;
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
          child: new Container(
            child: new CustomScrollView(
              scrollDirection: Axis.vertical,
              shrinkWrap: false,
              slivers: <Widget>[
                new SliverPadding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 24.0),
                  sliver: new SliverList(
                    delegate: new SliverChildBuilderDelegate(
                          (context, index) =>
                      new Text(_selectedEvents.toString()),
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