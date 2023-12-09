import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'home_screen.dart';
import 'login.dart';

class SoundsScreen extends StatefulWidget {
  @override
  _SoundsScreen createState() => _SoundsScreen();
}

class _SoundsScreen extends State<SoundsScreen> {

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