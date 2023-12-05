import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
          backgroundColor: Colors.deepOrangeAccent
      ),
    );
  }
}