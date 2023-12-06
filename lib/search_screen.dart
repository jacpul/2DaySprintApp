import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';
import 'login_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreen createState() => _SearchScreen();
}

class _SearchScreen extends State<SearchScreen> {

  TextEditingController searchText = TextEditingController();
  late var bookCollection = FirebaseFirestore.instance.collection(
      'Amazon Books');
  late List<Map<String, dynamic>> bookList;
  bool isLoaded = false;

  _functionCounter() async {
    List<Map<String, dynamic>> tempList = [];
    var logData = await bookCollection.get();
    logData.docs.forEach((element) {
      tempList.add(element.data());
    });
    bookList = tempList;
  }

  bool bookExist = false;

  late List<Map<String, dynamic>> updatedList = [];

  Map<String, dynamic> noBookFound =
  {
    'title': "No Book Found"
  };

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
        body: Center(
            child: Column(
                children: <Widget>[
                  TextFormField(
                    decoration: const InputDecoration(
                      icon: Icon(Icons.search),
                      hintText: 'Enter search term...',
                    ),
                    controller: searchText,
                  ),
                  ElevatedButton(
                      onPressed: () {
                        _functionCounter();
                        isLoaded = false;
                        print(bookList.length);
                        updateList(searchText.text);
                        print("list is: ${updatedList.length}");
                        setState(() {

                        });
                      },
                      child: const Text('SEARCH')),
                  Expanded(
                    child: isLoaded ? getListofBooks() : Text(" "),
                  ),
                ]
            )
        )
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
    print(item);
    isLoaded = true;
    updatedList.clear();
    for (var i = 0; i < bookList.length; i++) {
      if (bookList[i]["isbn13"].toString() == item) {
        updatedList.add(bookList[i]);
        print("found book");
        bookExist = true;
      }
    }
  }
}
