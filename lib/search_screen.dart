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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text("Search"),
          centerTitle: true,
          backgroundColor: Colors.deepOrangeAccent,
          actions: [
            IconButton(
                icon: const Icon(Icons.logout_outlined),
                tooltip: 'Home',
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return Home();
                  }));
                }
            )
          ]
      ),
      body: Container(
        color: Colors.orangeAccent.shade100,
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
          ],
        ),
      ),
    );
  }
}