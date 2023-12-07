import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';
import 'login.dart';

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

  // Used to determine how we are searching
  String _searchMethod = "Title";
  String _searchBarText = "";

  final _searchBarController = TextEditingController();

  TextEditingController searchText = TextEditingController();
  late var bookCollection = FirebaseFirestore.instance.collection('Amazon Books');
  late List<Map<String, dynamic>> bookList;
  bool isLoaded = false;

  _functionCounter() async {
    List<Map<String, dynamic>> tempList = [];
    var logData = await bookCollection.get();
    logData.docs.forEach((element) {
      tempList.add(element.data());
    });
    bookList = tempList;
    setState(() {

    });
  }

  bool bookExist = false;

  late List<Map<String, dynamic>> updatedList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.yellow.shade300,
        appBar: AppBar(
            title: Text("Search"),
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
                print(bookList.length);
                updateList(_searchBarController.text);
                print("list is: ${updatedList.length}");
                setState(() {});
              },
              child: const Text('SEARCH')),
            Expanded(
              child: isLoaded ? getListofBooks() : Text(" "),
            ),
          ],
        ),
      ),
    );
  }

  getListofBooks() {
    return ListView.builder(
        itemCount: updatedList!.length,
        itemBuilder: (content, index) {
          return Card(
              color: Colors.yellow.shade600,
              child: ListTile(
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 2),
                  borderRadius: BorderRadius.circular(20),
                ),
                leading: const CircleAvatar(
                    backgroundColor: Colors.blueAccent,
                    child: Icon(Icons.library_books)
                ),
                title:
                Text(updatedList[index]["title"].toString()),
                subtitle:
                bookExist ? Text("Author: " + updatedList[index]["author"] + " "
                    + "Edition: " + updatedList[index]["edition"].toString() + " "
                    + "Published: " + updatedList[index]["publish_data"].toString() + " "
                    + "Rating: " + updatedList[index]["rating"].toString() + " "
                    + "Price: " + updatedList[index]["price"]) : Text("** NO DATA **"),
              )
          );
        }
    );
  }

  void updateList(String item) {
    // Used to get the database field
    String firebaseField = item;

    print(item);
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
      if (bookList[i][firebaseField].toString() == item) {
        updatedList.add(bookList[i]);
        print("found book");
        bookExist = true;
      }
    }
  }
}
