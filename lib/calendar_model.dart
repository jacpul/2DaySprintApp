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
  final String isbn13;
  final String needReturn;
  final String notes;
  final String price;
  final String id;

  Event(this.title, this.day, this.month, this.year, this.isbn13, this.needReturn, this.notes, this.price, this.id);

  @override
  String toString() => id;
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
    String title = element['title'];
    int day = element['day'];
    int month = element['month'];
    int year = element['year'];
    String isbn13 = element['isbn13'];
    String needReturn = element['return'];
    String notes = element['notes'];
    String price = element['price'];
    String id = element.id;
    DateTime eventDay = DateTime(year, month, day);
    tempLinkedMap.putIfAbsent(eventDay, () => []);
    tempLinkedMap[eventDay]?.add(Event(title, day.toString(), month.toString(), year.toString(), isbn13, needReturn, notes, price, id));
    debugPrint('title: $title Length of Map: ${tempLinkedMap.length}');
  });
  return LinkedHashMap<DateTime, List<Event>>(
      equals: isSameDay,
      hashCode: getHashCode
  )..addAll(tempLinkedMap);
}