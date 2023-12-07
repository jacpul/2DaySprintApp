import 'package:final_project/search_screen.dart';
import 'package:final_project/sounds_screen.dart';
import 'package:final_project/videos_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          primary: Colors.blueAccent
                      ),
                      child: Text('Resources', style: const TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.white),
                          textAlign: TextAlign.center),
                      onPressed: () async {
                        const url = "https://www.kaggle.com/uzair01";

                        if (await canLaunch(url)) {
                        await launch(
                        url,
                        forceWebView: true,
                        enableJavaScript: true,
                        );
                        }
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