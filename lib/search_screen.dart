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
                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                    return Home();
                  }));
                }
            )
          ]
      ),
    );
  }
}