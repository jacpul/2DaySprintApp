import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  String isbn13 = "";

  late var currentUser = FirebaseAuth.instance.currentUser!.uid;
  late CollectionReference dataRef = FirebaseFirestore.instance
      .collection('users')
      .doc(currentUser)
      .collection('Events');
  late var bookCollection = FirebaseFirestore.instance.collection('Amazon Books');
  late List<Map<String, dynamic>> bookList;
  late List<Map<String, dynamic>> updatedList = [];

  final _dayController = TextEditingController();
  final _monthController = TextEditingController();
  final _yearController = TextEditingController();
  final _returnDayController = TextEditingController();
  final _returnMonthController = TextEditingController();
  final _returnYearController = TextEditingController();
  final _isbn13Controller = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void initState() {
    populateBookList();

    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _dayController.dispose();
    _monthController.dispose();
    _yearController.dispose();
    _returnDayController.dispose();
    _returnMonthController.dispose();
    _returnYearController.dispose();
    _isbn13Controller.dispose();
    _notesController.dispose();

    super.dispose();
  }

  Future<void> populateBookList() async {
    List<Map<String, dynamic>> tempList = [];
    var logData = await bookCollection.get();
    logData.docs.forEach((element) {
      tempList.add(element.data());
    });
    bookList = tempList;
  }

  void createCalendarEvent() {
    if (year == 0 || month == 0 || day == 0 || notes == "") {
      return;
    }
    print("BEfor");
    for (var i = 0; i < bookList.length; i++) {
      print(bookList[i]);
      if (bookList[i]["isbn13"].contains(isbn13)) {
        updatedList.add(bookList[i]);
      }
    }

    print(isbn13);
    print(updatedList.length);
    print(bookList.length);

    if (updatedList.length == 1) {
    dataRef.add({
      'month': month,
      'day': day,
      'year': year,
      'notes': notes,
      'isbn13': isbn13,
      'title': updatedList[0]["title"],
      'price': updatedList[0]["price"],
      'return': needReturn ? "Need By" : "N/A"
    });
    if (needReturn) {
      if (returnYear == 0 || returnMonth == 0 || returnDay == 0) {
        return;
      }
      dataRef.add({
        'month': returnMonth,
        'day': returnDay,
        'year': returnYear,
        'notes': notes,
        'isbn13': isbn13,
        'title': updatedList[0]["title"],
        'price': updatedList[0]["price"],
        'return': "Return By"
      });
    }
    print("success");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Add Book To Calendar", style: TextStyle(color: Color(0xFFD3C9B6)),),
          centerTitle: true,
          backgroundColor: Color(0xFF3A391D),
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
      backgroundColor: Color(0xFFD3C9B6),
      body: Container(
        child: Column(
          children: <Widget>[
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text("When do you need this book by?",style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A391D)), textScaleFactor: 1.5,)
              ,),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 10.0, right: 5.0),
                    child: const Icon(Icons.access_time_rounded, color: Color(0xFFB1782B)),
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
                          day = int.parse(value);
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
                          month = int.parse(value);
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
                          year = int.parse(value);
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
              child: Text("Will this book need to be returned?",style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A391D)), textScaleFactor: 1.5,)
              ,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<bool>(
                    activeColor: Color(0xFFB1782B),
                    value: false,
                    groupValue: needReturn,
                    onChanged: (value) {
                      setState(() {
                        needReturn = value!;
                      });
                    }),
                Text(
                  'No',
                  style: TextStyle(color: Color(0xFFB1782B)),
                ),
                Radio<bool>(
                    activeColor: Color(0xFFB1782B),
                    value: true,
                    groupValue: needReturn,
                    onChanged: (value) {
                      setState(() {
                        needReturn = value!;
                      });
                    }),
                Text(
                  'Yes',
                  style: TextStyle(color: Color(0xFFB1782B)),
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
              child: Text("Now enter the ISBN13 number:",style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A391D)), textScaleFactor: 1.5,)
              ,),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 30.0),
              child: TextFormField(
                controller: _isbn13Controller,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                maxLength: 14,
                onChanged: (value) {
                  setState(() {
                    isbn13 = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'xxx-xxxxxxxxxx',
                  labelText: 'ISBN13 Number',
                  icon: Icon(Icons.book_outlined),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 30.0, left: 30.0),
              child: TextFormField(
                controller: _notesController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                maxLength: 100,
                onChanged: (value) {
                  setState(() {
                    notes = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'type your hopes and dreams',
                  labelText: 'Notes for this event',
                  icon: Icon(Icons.book_outlined),
                ),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF826145),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onPressed: () {
                createCalendarEvent();
              },

              child: Text('Submit Event'),

            ),
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
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3A391D)),
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
                color: Color(0xFFB1782B),
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

