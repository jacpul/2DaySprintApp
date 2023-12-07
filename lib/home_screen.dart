import 'package:final_project/search_screen.dart';
import 'package:final_project/sounds_screen.dart';
import 'package:final_project/videos_screen.dart';
import 'package:flutter/material.dart';
import 'login.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) =>
            Scaffold (
              appBar: AppBar(
                title: Text("Home"),
                backgroundColor: Colors.deepOrange,
                actions: [
                  IconButton(
                      icon: const Icon(Icons.logout_outlined),
                      tooltip: 'Logout',
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                          return Loginpage();
                        }));
                      }
                  )
                ],
              ),
              body: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.blueAccent
                      ),
                    child: Text('Search', style: const TextStyle(fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Colors.white),
                        textAlign: TextAlign.center),
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                        return SearchScreen();
                      }));
                    }
                    ),

                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent
                        ),
                        child: Text('Sounds', style: const TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                            textAlign: TextAlign.center),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                            return SoundsScreen();
                          }));
                        }
                    ),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent
                      ),
                      child: Text('Videos', style: const TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                          textAlign: TextAlign.center),
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                          return VideoResource();
                        }));
                      },
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}