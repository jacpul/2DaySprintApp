import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_screen.dart';

class CalendarAdd extends StatefulWidget {

  @override
  _CalendarAdd createState() => _CalendarAdd();
}

class _CalendarAdd extends State<CalendarAdd> {
  int day = 0;
  int month = 0;
  int year = 0;
  String bookTitle = "";
  String bookIsbn = "";
  bool needReturn = false;
  int returnDay = 0;
  int returnMonth = 0;
  int returnYear = 0;
  String notes = "";

  late var bookCollection = FirebaseFirestore.instance.collection('Amazon Books');
  late List<Map<String, dynamic>> bookList;

  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _returnDayController = TextEditingController();
  final _returnMonthController = TextEditingController();
  final _returnYearController = TextEditingController();

  @override
  void initState() {
    populateBookList();

    // TODO: implement initState
    super.initState();
  }

  Future<void> populateBookList() async {
    List<Map<String, dynamic>> tempList = [];
    var logData = await bookCollection.get();
    logData.docs.forEach((element) {
      tempList.add(element.data());
    });
    bookList = tempList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Book To Calendar"),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
          actions: [

            /// Icon button to log out and bring user back to the login screen
            IconButton(
                icon: const Icon(Icons.logout_outlined),
                tooltip: 'Home',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return Home();
                      }));
                }
            )
          ]
      ),
      backgroundColor: Colors.amber,
      body: Container(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text("When do you need this book by?",style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5,)
              ,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                    child: const Icon(Icons.access_time_rounded, color: Colors.white),
                  ),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextFormField(
                      controller: _dayController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || (int.parse(value) <= 1 || int.parse(value) >= 31)) {
                          return ('Enter a day from 1 to 31');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          day = value as int;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "1 to 31",
                        labelText: "Day",
                      ),
                    ),
                  )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                    child: TextFormField(
                      controller: _monthController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || (int.parse(value) <= 1 || int.parse(value) >= 12)) {
                          return ('Enter a month from 1 to 12');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          month = value as int;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: "1 to 12",
                        labelText: "Month",
                      ),
                    ),
                  )),
                  Expanded(child: Padding(
                    padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                    child: TextFormField(
                      controller: _yearController,
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value!.isEmpty || (int.parse(value) <= 2020 || int.parse(value) >= 2030)) {
                          return ('Enter year between 2020 and 2030');
                        }
                        return null;
                      },
                      onChanged: (value) {
                        setState(() {
                          year = value as int;
                        });
                      },
                        decoration: const InputDecoration(
                          hintText: "2020 to 2030",
                          labelText: "Year",
                        ),
                    ),
                  ))
                ],
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Will this book need to be returned?",style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5,)
              ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<bool>(
                    activeColor: Colors.deepOrangeAccent,
                    value: false,
                    groupValue: needReturn,
                    onChanged: (value) {
                      setState(() {
                        needReturn = value!;
                      });
                    }),
                Text(
                  'No',
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
                Radio<bool>(
                    activeColor: Colors.deepOrangeAccent,
                    value: true,
                    groupValue: needReturn,
                    onChanged: (value) {
                      setState(() {
                        needReturn = value!;
                      });
                    }),
                Text(
                  'Yes',
                  style: TextStyle(color: Colors.deepOrangeAccent),
                ),
              ],
            ),
            if (needReturn) buildBookReturn(
              context,
              _returnDayController,
              _returnMonthController,
              _returnYearController,
              returnDay,
              returnMonth,
              returnYear,
                  (int day) {
                setState(() {
                  returnDay = day;
                  print(day);
                });
                },
                  (int month) {
                setState(() {
                  returnMonth = month;
                  print(month);
                });
                },
                  (int year) {
                setState(() {
                  returnYear = year;
                  print(year);
                });
              },
            ),
            const Padding(
              padding: EdgeInsets.all(10.0),
              child: Text("Enter the ISB13?",style: TextStyle(fontWeight: FontWeight.bold), textScaleFactor: 1.5,)
              ,),
          ],
        ),
      ),
    );
  }
}


Widget buildBookReturn(
    BuildContext context,
    TextEditingController dayControl,
    TextEditingController monthControl,
    TextEditingController yearControl,
    int returnDay,
    int returnMonth,
    int returnYear,
    Function(int) onDayChanged,
    Function(int) onMonthChanged,
    Function(int) onYearChanged,
    ) {
  return Column(
    children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top: 16.0),
        child: Text(
          "When do you need this book by?",
          style: TextStyle(fontWeight: FontWeight.bold),
          textScaleFactor: 1.5,
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 5.0),
              child: const Icon(
                Icons.access_time_rounded,
                color: Colors.white,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: TextFormField(
                  controller: dayControl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || (int.parse(value) <= 1 || int.parse(value) >= 31)) {
                      return ('Enter a day from 1 to 31');
                    }
                  },
                  onChanged: (value) {
                    onDayChanged(int.parse(value));
                  },
                  decoration: const InputDecoration(
                    hintText: "1 to 31",
                    labelText: "Day",
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 5.0),
                child: TextFormField(
                  controller: monthControl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || (int.parse(value) <= 1 || int.parse(value) >= 12)) {
                      return ('Enter a month from 1 to 12');
                    }
                    return null;
                  },
                  onChanged: (value) {
                    onMonthChanged(int.parse(value));
                  },
                  decoration: const InputDecoration(
                    hintText: "1 to 12",
                    labelText: "Month",
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 5.0, right: 10.0),
                child: TextFormField(
                  controller: yearControl,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value!.isEmpty || (int.parse(value) <= 2020 || int.parse(value) >= 2030)) {
                      return ('Enter year between 2020 and 2030');
                    }
                    return null;
                  },
                  onChanged: (value) {
                    onYearChanged(int.parse(value));
                  },
                  decoration: const InputDecoration(
                    hintText: "2020 to 2030",
                    labelText: "Year",
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

