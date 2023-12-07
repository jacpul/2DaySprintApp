import 'package:final_project/search_screen.dart';
import 'package:final_project/sounds_screen.dart';
import 'package:final_project/videos_screen.dart';
import 'package:flutter/material.dart';

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
              backgroundColor: Colors.yellow.shade400,
              appBar: AppBar(
                title: Text("Home"),
                backgroundColor: Colors.deepOrange,
              ),
              body: Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20),
                      child:SizedBox(
                        height: 100,
                        width: 200,
                        child:
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
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
                    ),
                    ),


                    Padding(
                        padding: EdgeInsets.all(20),
                        child:SizedBox(
                          height: 100,
                          width: 200,
                          child:
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.blueAccent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)
                                )
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
                    )
                    ),


                    Padding(
                      padding: EdgeInsets.all(20),
                      child: SizedBox(
                        height: 100,
                        width: 200,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blueAccent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30)),
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
                    ),
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}