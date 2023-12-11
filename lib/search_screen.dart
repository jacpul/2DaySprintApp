import 'package:cloud_firestore/cloud_firestore.dart';
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
      backgroundColor: Colors.yellow.shade300,
      appBar: AppBar(
          title: const Text("Search"),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
          actions: [
            /// Icon button to log out and bring user back to the login screen
            IconButton(
                icon: const Icon(Icons.home),
                tooltip: 'Home',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return Home();
                  }));
                }),

            /// Icon button to log out and bring user back to the search screen
            IconButton(
                icon: const Icon(Icons.search_outlined),
                tooltip: 'Search',
                onPressed: () {}),

            /// Icon button to log out and bring user back to the compare screen
            IconButton(
                icon: const Icon(Icons.compare),
                tooltip: 'Compare',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return CompareScreen();
                  }));
                }),

            /// Icon button to log out and bring user back to the video screen
            IconButton(
                icon: const Icon(Icons.play_arrow_outlined),
                tooltip: 'Videos',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return VideoResource();
                  }));
                })
          ]),
      body: Container(
        color: Colors.yellow.shade400,
        margin: const EdgeInsets.all(8.0),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Radio<String>(
                    activeColor: Colors.blue,
                    value: "Title",
                    groupValue: _searchMethod,
                    onChanged: (value) {
                      setState(() {
                        _searchMethod = value!;
                      });
                    }),
                const Text(
                  'Title',
                  style: TextStyle(color: Colors.blue),
                ),
                Radio<String>(
                    activeColor: Colors.blue,
                    value: "Author",
                    groupValue: _searchMethod,
                    onChanged: (value) {
                      setState(() {
                        _searchMethod = value!;
                      });
                    }),
                const Text(
                  'Author',
                  style: TextStyle(color: Colors.blue),
                ),
                Radio<String>(
                    activeColor: Colors.blue,
                    value: "ISBN",
                    groupValue: _searchMethod,
                    onChanged: (value) {
                      setState(() {
                        _searchMethod = value!;
                      });
                    }),
                const Text(
                  'ISBN Number',
                  style: TextStyle(color: Colors.blue),
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
                  //print(bookList.length);
                  updateList(_searchBarText);
                  //print("list is: ${updatedList.length}");
                  setState(() {});
                },
                child: const Text('SEARCH')),
            Expanded(
              child: isLoaded ? getListOfBooks() : const Text(" "),
            ),
          ],
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
              color: Colors.yellow.shade600,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.library_books)),
                title: Text(updatedList[index]["title"].toString()),
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
                        updatedList[index]["price"])
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
