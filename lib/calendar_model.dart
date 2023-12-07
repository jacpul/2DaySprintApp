import 'dart:collection';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

final eventToday = DateTime.now();
late final eventFirstDay = DateTime(eventToday.year, eventToday.month - 5, eventToday.day);
late final eventLastDay = DateTime(eventToday.year, eventToday.month + 3, eventToday.day);

class Event {
  final String title;
  final String day;
  final String month;
  final String year;
  final String hours;
  final String quality;
  final String notes;

  Event(this.title, this.day, this.month, this.year, this.hours, this.quality, this.notes);

  @override
  String toString() => title;
}

/**
 * returns a custom hashcode for the hashmap
 * @param DateTime key
 * @return a value corresponding to the DateTime
 */
int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

/**
 * populates a LinkedHashMap of DateTime and List of Events
 * @param logData this a collection refrence
 * @return LinkedHashMap<DateTime, List<Event>>
 */
Future<LinkedHashMap<DateTime, List<Event>>> populateLogList(var logData) async {
  var tempLinkedMap = <DateTime, List<Event>> {};
  logData.docs.forEach((element) {
    int day = -1;
    int month = -1;
    int year = -1;
    String strDay = "Day Not Found";
    day = element['Day'];
    strDay = day.toString();
    String strMonth = "Month Not Found";
    month = element['Month'];
    strMonth = month.toString();
    String strYear = "Year Not Found";
    year = element['Year'];
    strYear = year.toString();
    String hours = "Hours Slept Not Found";
    hours = element['Hours_Slept'];
    String quality = "Quality Not Found";
    quality = element['Sleep_Quality'];
    String notes = "Notes Not Found";
    notes = element['Notes'];
    print(element.id);
    String title =  element.id;
    DateTime eventDay = DateTime(year, month, day);
    tempLinkedMap.putIfAbsent(eventDay, () => []);
    tempLinkedMap[eventDay]?.add(Event(title, strDay, strMonth, strYear, hours, quality, notes));
    debugPrint('title: $title Length of Map: ${tempLinkedMap.length}');
  });
  return LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode
  )..addAll(tempLinkedMap);
}