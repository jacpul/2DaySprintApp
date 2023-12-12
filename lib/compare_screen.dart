import 'package:final_project/search_screen.dart';
import 'package:final_project/videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'calendar_screen.dart';
import 'home_screen.dart';

class CompareScreen extends StatefulWidget {
  @override
  _CompareScreenState createState() => _CompareScreenState();
}

class _CompareScreenState extends State<CompareScreen> {
  String _searchMethod = "Title";
  String _searchBarText = "";
  TextEditingController _searchBarController = TextEditingController();
  List<Map<String, dynamic>> bookList = [];
  List<Map<String, dynamic>> updatedList = [];
  List<Map<String, dynamic>> compareList = [];

  bool isLoaded = false;

  @override
  void initState() {
    super.initState();
    _functionCounter();
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    super.dispose();
  }

  _functionCounter() async {
    List<Map<String, dynamic>> tempList = [];
    var logData = await FirebaseFirestore.instance.collection('Amazon Books').get();
    logData.docs.forEach((element) {
      tempList.add(element.data());
    });
    bookList = tempList;
    setState(() {});
  }

  bool bookExist = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF3A391D),
      appBar: AppBar(
        title: Text("Compare", style: TextStyle(color: Color(0xFFD3C9B6)),),
        centerTitle: true,
        backgroundColor: const Color(0xFF7D491A),
        actions: [
          /// Icon button to log out and bring user back to the login screen
          IconButton(
              icon: const Icon(Icons.home, color: Color(0xFFD3C9B6)),
              tooltip: 'Home',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return Home();
                    }));
              }
          ),
          /// Icon button to log out and bring user back to the search screen
          IconButton(
              icon: const Icon(Icons.search_outlined, color: Color(0xFFD3C9B6)),
              tooltip: 'Search',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return SearchScreen();
                    }));
              }
          ),
          /// Icon button to log out and bring user back to the compare screen
          IconButton(
              icon: const Icon(Icons.compare, color: Color(0xFFD3C9B6)),
              tooltip: 'Compare',
              onPressed: () {

              }
          ),
          /// Icon button to log out and bring user back to the video screen
          IconButton(
              icon: const Icon(Icons.play_arrow_outlined, color: Color(0xFFD3C9B6)),
              tooltip: 'Videos',
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (BuildContext context) {
                      return VideoResource();
                    }));
              }
          ),
          IconButton(
              icon: const Icon(Icons.calendar_month, color: Color(0xFFD3C9B6),),
              tooltip: 'Calendar',
              onPressed: () {
                Navigator.of(context)
                    .push(MaterialPageRoute(builder: (BuildContext context) {
                  return CalendarScreen();
                }));
              })
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0xFFD3C9B6),
          ),
          margin: const EdgeInsets.all(8.0),
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 2.0, right: 5.0),
                    child: Text(
                      'Compare Search Method:',
                      style: TextStyle(fontSize: 18, color: Color(0xFF3A391D)),
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: DropdownButton<String>(
                      value: _searchMethod,
                      onChanged: (String? value) {
                        setState(() {
                          _searchMethod = value!;
                        });
                      },
                      items: <String>['Title', 'Author', 'ISBN'].map((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: TextStyle(color: Color(0xFF826145)),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _searchBarController,
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.next,
                onChanged: (value) {
                  setState(() {
                    _searchBarText = value;
                  });
                },
                decoration: InputDecoration(
                  hintText: 'Enter Details Here',
                  labelText: _searchMethod,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  _functionCounter();
                  isLoaded = false;
                  updateList(_searchBarController.text);
                  setState(() {});
                },
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF826145),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: const Text('Add to Compare'),
              ),
              isLoaded
                  ? compareList.length == 2
                  ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: getBookDetailsWidget(compareList[0]),
                  ),
                  Expanded(
                    child: getBookDetailsWidget(compareList[1]),
                  ),
                ],
              )
                  : Expanded(child: getListofBooks())
                  : Text(" "),
            ],
          ),
        ),
      ),
    );
  }

  Widget getBookDetailsWidget(Map<String, dynamic> book) {
    return Card(
      color: Color(0xFF3A391D),
      child: ListTile(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 5, color: Color(0xFFB1782B)),
          borderRadius: BorderRadius.circular(5),
        ),
        title: Text(
          "Title: ${book["title"]}",
          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFD3C9B6)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Author: ${book["author"]}", style: TextStyle(color: Color(0xFFD3C9B6)),),
            Text("Edition: ${book["edition"]}", style: TextStyle(color: Color(0xFFD3C9B6)),),
            Text("Published: ${timeStampToString(book["publish_date"])}", style: TextStyle(color: Color(0xFFD3C9B6)),),
            Text("Rating: ${book["rating"]}", style: TextStyle(color: Color(0xFFD3C9B6)),),
            Text("Price: ${book["price"]}", style: TextStyle(color: Color(0xFFD3C9B6)),),
          ],
        ),
      ),
    );
  }

  String timeStampToString(Timestamp t) {
    DateTime date = t.toDate();
    String month = date.month.toString();
    String day = date.day.toString();
    String year = date.year.toString();
    String full_date = month + '/' + day + '/' + year;
    return full_date;
  }

  void updateList(String item) {
    isLoaded = true;
    updatedList.clear();
    for (var i = 0; i < bookList.length; i++) {
      if (_searchMethod == "Title" &&
          bookList[i]["title"].toString().toLowerCase().contains(item.toLowerCase())) {
        updatedList.add(bookList[i]);
        bookExist = true;
      } else if (_searchMethod == "Author" &&
          bookList[i]["author"].toString().toLowerCase().contains(item.toLowerCase())) {
        updatedList.add(bookList[i]);
        bookExist = true;
      } else if (_searchMethod == "ISBN" &&
          bookList[i]["isbn13"].toString().toLowerCase() == item.toLowerCase()) {
        updatedList.add(bookList[i]);
        bookExist = true;
      }
    }

    if (compareList.length == 2) {
      compareList.clear();
    }

    if (updatedList.isNotEmpty) {
      compareList.add(updatedList[0]);
    }
  }


  getListofBooks() {
    return ListView.builder(
      itemCount: updatedList!.length,
      itemBuilder: (content, index) {
        return Card(
          color: Color(0xFF3A391D),
          child: ListTile(
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 5, color: Color(0xFFB1782B)),
              borderRadius: BorderRadius.circular(5),
            ),
            title: Text(updatedList[index]["title"].toString(), style: TextStyle(color: Color(0xFFD3C9B6)),),
            subtitle: bookExist
                ? Text(
              "Author: " +
                  updatedList[index]["author"] +
                  "\n" +
                  "Edition: " +
                  updatedList[index]["edition"].toString() +
                  "\n" +
                  "Published: " + timeStampToString(updatedList[index]["publish_date"]) +
                  "\n" +
                  "Rating: " +
                  updatedList[index]["rating"].toString() +
                  "\n" +
                  "Price: " +
                  updatedList[index]["price"],
            style: TextStyle(color: Color(0xFFD3C9B6)),)
                : Text("** NO DATA **"),
          ),
        );
      },
    );
  }
}
