import 'dart:collection';
import 'package:final_project/calendar_add.dart';
import 'package:final_project/videos_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'calendar_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:table_calendar/table_calendar.dart';

import 'compare_screen.dart';
import 'home_screen.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreen createState() => _CalendarScreen();
}

class _CalendarScreen extends State<CalendarScreen> {

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  late ValueNotifier<List<Event>> _selectedEvents;
  late String dataUser;
  late CollectionReference userData;
  LinkedHashMap<DateTime, List<Event>>? _eventStorage;
  bool _initialized = false; // Flag to track initialization

  @override
  void initState() {
    _initialized = false;

    _selectedEvents = ValueNotifier([]);
    _selectedDay = _focusedDay;
    getUserData();
    super.initState();
  }

  /**
   * async initialize function for firestore communication and parsing
   */
  void getUserData() async {
    dataUser = FirebaseAuth.instance.currentUser!.uid; // gets the current user
    userData = FirebaseFirestore.instance.collection('users').doc(dataUser).collection('Events'); // gets an instance of the logs documents from the current user
    var usersData = await userData.get(); // puts log docs into the data
    debugPrint("dataUser: $dataUser, log: ${userData.id}, event: ${_eventStorage?.length}");
    _eventStorage = await populateLogList(usersData); // calls populateLogList from calendar_model and waits for it to return
    //sets state once everything is finished, to update the app
    setState(() {
      _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
      _initialized = true; // Set the initialization flag
    });
  }

  /**
   * gets all events stored on a day
   * @param DateTime day
   * @return A list of events for DateTime
   */
  List<Event> _getEventsForDay(DateTime day) {
    if (_initialized) {
      return _eventStorage?[day] ?? [];
    } else {
      return [];
    }
  }

  /**
   * called by the table calendar, sets the selected and focused day
   * @param DateTime selectedDay
   * @param DateTime focusedDay
   */
  Future<void> _onDaySelected(DateTime selectedDay, DateTime focusedDay) async {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  /**
   * Deletes a selected Event and reloads the calendar
   * @param selected DateTime day
   * @param index of the Event in the List<Event>
   */
  void deleteEvent(DateTime day, int index) async {
    var listData = await userData.get();
    if (_eventStorage!.containsKey(day)) {
      List<Event>? events = _eventStorage?[day];
      listData.docs.forEach((element) {
        if(element.id.toString() == events?[index].toString()) {
          userData.doc(element.id).delete();
        }
      });
    }
    setState(() {
      _initialized = false;
      initState();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
            tooltip: "Create Event",
            shape: RoundedRectangleBorder(),
            backgroundColor: Color(0xFF3A391D),
            onPressed: () async{
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CalendarAdd(),
                  ));
              },
            child: Icon(Icons.add_rounded),
        ),
        appBar: AppBar(
            title: Text(" ", style: TextStyle(color: Color(0xFFD3C9B6)),),
            centerTitle: true,
            backgroundColor: Color(0xFF3A391D),
            actions: [

              /// Icon button to log out and bring user back to the login screen
              IconButton(
                  icon: const Icon(Icons.home, color: Color(0xFFD3C9B6)),
                  tooltip: 'Home',
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return Home();
                    }));
                  }),

              /// Icon button to log out and bring user back to the search screen
              IconButton(
                  icon: const Icon(Icons.search_outlined, color: Color(0xFFD3C9B6)),
                  tooltip: 'Search',
                  onPressed: () {}),

              /// Icon button to log out and bring user back to the compare screen
              IconButton(
                  icon: const Icon(Icons.compare, color: Color(0xFFD3C9B6)),
                  tooltip: 'Compare',
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return CompareScreen();
                    }));
                  }),

              /// Icon button to log out and bring user back to the video screen
              IconButton(
                  icon: const Icon(Icons.play_arrow_outlined, color: Color(0xFFD3C9B6),),
                  tooltip: 'Videos',
                  onPressed: () {
                    Navigator.of(context)
                        .push(MaterialPageRoute(builder: (BuildContext context) {
                      return VideoResource();
                    }));
                  }),

              IconButton(
                  icon: const Icon(Icons.calendar_month, color: Color(0xFFD3C9B6),),
                  tooltip: 'Calendar',
                  onPressed: () {
                  })
            ]),
        backgroundColor: Color(0xFFD3C9B6),

        body: Column(
            children: [
              _initialized ? TableCalendar<Event>(
                headerStyle: const HeaderStyle(
                  titleTextStyle:
                  TextStyle(color: Color(0xFFD3C9B6), fontSize: 20.0),
                  decoration: BoxDecoration(
                      color: Color(0xFF7D491A),
                      borderRadius: BorderRadius.only()),
                  formatButtonTextStyle:
                  TextStyle(color: Color(0xFF3A391D), fontSize: 16.0),
                  formatButtonDecoration: BoxDecoration(
                    color: Color(0xFFD3C9B6),
                  ),
                  leftChevronIcon: Icon(
                    Icons.chevron_left,
                    color: Color(0xFFD3C9B6),
                    size: 28,
                  ),
                  rightChevronIcon: Icon(
                    Icons.chevron_right,
                    color: Color(0xFFD3C9B6),
                    size: 28,
                  ),
                ),
                daysOfWeekStyle: const DaysOfWeekStyle(
                    weekdayStyle: TextStyle(color: Color(0xFF3A391D)),
                    weekendStyle: TextStyle(color: Color(0xFF7D491A))
                ),
                calendarStyle: const CalendarStyle(
                  weekendTextStyle: TextStyle(color: Color(0xFF7D491A)),
                  weekNumberTextStyle: TextStyle(color: Color(0xFF3A391D)),
                  outsideTextStyle: TextStyle(color: Color(0xFFB1782B)),
                  todayDecoration: BoxDecoration(
                    color: Color(0xFFC39F67),
                    shape: BoxShape.circle,
                  ),
                  // highlighted color for selected day
                  selectedDecoration: BoxDecoration(
                    color: Color(0xFF826145),
                    shape: BoxShape.circle,
                  ),
                ),

                firstDay: eventFirstDay,
                lastDay: eventLastDay,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                eventLoader: _getEventsForDay,
                startingDayOfWeek: StartingDayOfWeek.sunday,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: _onDaySelected,
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    // Call `setState()` when updating calendar format
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  // No need to call `setState()` here
                  _focusedDay = focusedDay;
                },

              ): CircularProgressIndicator(),
              const SizedBox(height: 7.0),
              Expanded(
                child: ValueListenableBuilder<List<Event>>(
                  valueListenable: _selectedEvents,
                  builder: (context, value, _) {
                    if (_selectedEvents.value == null) {
                      return CircularProgressIndicator();
                    } else {
                      return ListView.builder(
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          return Card(
                              child: ListTile(
                                tileColor: Color(0xFF3A391D),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  side: const BorderSide(
                                    color: Color(0xFF7D491A), // Set the color of the border here
                                    width: 3.5,
                                  ),
                                ),
                                leading: const CircleAvatar(
                                  backgroundColor: Color(0xFFB1782B),
                                  child: Icon(Icons.edit_calendar,
                                      color: Color(0xFFD3C9B6)),
                                ),
                                title: Row(
                                  children: [
                                    Text('${value[index].needReturn} : ${value[index].month}-${value[index].day}-${value[index].year}',
                                        style: TextStyle(color: Color(0xFFD3C9B6))
                                    )
                                  ],
                                ),
                                subtitle:
                                Text('${value[index].title} \nPrice: ${value[index].price}    Notes: ${value[index].notes}',
                                    style: TextStyle(color: Color(0xFFD3C9B6))
                                ),
                                trailing:
                                Icon(Icons.delete,
                                    color: Color(0xFFD3C9B6)),
                                onTap: () {
                                  showDialog(context: context, builder: (context) =>
                                      AlertDialog(
                                        title: Text("Would You Like Delete This Event?"),
                                        actions: [
                                          TextButton(
                                              onPressed: () => Navigator.pop(context),
                                              child: Text('NO')),
                                          TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteEvent(_selectedDay!, index);
                                              },
                                              child: Text('YES')),
                                        ],
                                      ));
                                },
                              )
                          );
                        },
                      );}},
                ),
              ),
            ]
        )

    );

  }
}