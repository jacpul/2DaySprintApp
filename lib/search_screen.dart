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
  //late var bookCollection = FirebaseFirestore.instance.collection('Amazon Books');
  List<String> tempList = [
    '1',
    '1',
    '1',
    '2',
    '3',
    '4',
    '5',
  ];
  List<String> updatedList = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                        updateList(searchText.text);
                        print("list is: ${updatedList.length}");
                        /*
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text('Results'),
                              // Retrieve the text the that user has entered by using the
                              // TextEditingController.
                              content: listOfBooks,
                            );
                          },
                        );


                         */
                      },
                      child: const Text('SEARCH')),
                ]
            )
        )
    );
  }

  late var listOfBooks = ListView.builder(
    itemCount: tempList.length,
    itemBuilder: (content, index) {
      return Card(
        color: Colors.yellow.shade800,
        child: ListTile(
          shape: RoundedRectangleBorder(
            side: const BorderSide(width: 2),
            borderRadius: BorderRadius.circular(20),
          ),
          leading: const CircleAvatar(
            backgroundColor: Colors.blueAccent,
            child: Icon(Icons.library_books)
          ),
          title: Row(
            children: [
              Text(updatedList[index].toString()),
            ],
          )
        )
      );
    }
  );

  void updateList(String item) {
    print(item);
    for (var i = 0; i < tempList.length; i++) {
      if(tempList[i] == item) {
        print('true');
        updatedList.add(tempList[i]);
      }
    }
  }
}