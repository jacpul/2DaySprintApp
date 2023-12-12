import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/calendar_screen.dart';
import 'package:final_project/videos_screen.dart';
import 'package:flutter/material.dart';
import 'compare_screen.dart';
import 'home_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {
  // Disposes text editing controllers used for the search
  @override
  void dispose() {
    _searchBarController.dispose();

    super.dispose();
  }

  // used to initialize the book list
  @override
  void initState() {
    _functionCounter();
    super.initState();
  }

  // Used to determine how we are searching
  String _searchMethod = "Title";
  String _searchBarText = "";
  bool isLoaded = false;
  bool bookExist = false;

  final _searchBarController = TextEditingController();

  late var bookCollection =
      FirebaseFirestore.instance.collection('Amazon Books');
  late List<Map<String, dynamic>> bookList = [];
  late List<Map<String, dynamic>> updatedList = [];

  _functionCounter() async {
    List<Map<String, dynamic>> tempList = [];
    var logData = await bookCollection.get();
    logData.docs.forEach((element) {
      tempList.add(element.data());
    });
    bookList = tempList;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF826145),
      appBar: AppBar(
          title: const Text(" "),
          centerTitle: true,
          backgroundColor: const Color(0xFF3A391D),
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
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return CalendarScreen();
                  }));
                })
          ]),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            color: const Color(0xFFD3C9B6),
          ),
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2.0, right: 5.0),
                      child: Text(
                        'Search Method:',
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
                    updateList(_searchBarText);
                    setState(() {});
                  },
                  style: ElevatedButton.styleFrom(
                    primary: Color(0xFF826145),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.search, color: Color(0xFFD3C9B6)), // Add your desired icon
                      SizedBox(width: 8.0), // Adjust the spacing between icon and text
                      Text('Search', style: TextStyle(color: Color(0xFFD3C9B6))),
                    ],
                  ),
                ),
                Expanded(
                  child: isLoaded ? getListOfBooks() : const Text(" "),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  getListOfBooks() {
    return ListView.builder(
        itemCount: updatedList.length,
        itemBuilder: (content, index) {
          String publishedDate = "";

          if (updatedList[index]["publish_date"] == null) {
            publishedDate = "No Publish Date Found.";
          } else {
            publishedDate =
                timeStampToString(updatedList[index]["publish_date"]);
          }
          return Card(
              color: Color(0xFF3A391D),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 5, color: Color(0xFFB1782B)),
                  borderRadius: BorderRadius.circular(5),
                ),
                leading: const CircleAvatar(
                    backgroundColor: Color(0xFFC39F67),
                    child: Icon(Icons.library_books, color: Color(0xFFD3C9B6),)),
                title: Text(updatedList[index]["title"].toString(), style: TextStyle(color: Color(0xFFD3C9B6)),),
                subtitle: bookExist
                    ? Text("Author: " +
                        updatedList[index]["author"].toString() + " " +
                        "Edition: " +
                        updatedList[index]["edition"].toString() + " " +
                        "Published: " +
                        publishedDate + " " +
                        "Rating: " +
                        updatedList[index]["rating"].toString() + " " +
                        "Price: " +
                        updatedList[index]["price"], style: TextStyle(color: Color(0xFFD3C9B6)),)
                    : const Text("** NO DATA **"),
              ));
        });
  }

  String timeStampToString(Timestamp t) {
    DateTime date = t.toDate();
    String month = date.month.toString();
    String day = date.day.toString();
    String year = date.year.toString();
    String fullDate = '$month/$day/$year';
    return fullDate;
  }

  void updateList(String item) {
    // Used to get the database field
    String firebaseField = item;

    //print(item);
    isLoaded = true;
    updatedList.clear();

    switch (_searchMethod) {
      case 'Title':
        firebaseField = "title";
        break;
      case 'Author':
        firebaseField = "author";
        break;
      case 'ISBN':
        firebaseField = 'isbn13';
        break;
      default:
        break;
    }

    for (var i = 0; i < bookList.length; i++) {
      if (bookList[i][firebaseField].toString().toLowerCase().contains(item.toLowerCase())) {
        updatedList.add(bookList[i]);
        //print("found book");
        //print(bookList[i]["publish_date"]);
        bookExist = true;
      }
    }
  }
}
