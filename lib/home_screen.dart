import 'package:final_project/calendar_screen.dart';
import 'package:final_project/search_screen.dart';
import 'package:final_project/sounds_screen.dart';
import 'package:final_project/videos_screen.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  String url = "https://www.kaggle.com/uzair01";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) =>
            Scaffold (
                backgroundColor: Colors.yellow.shade400,
             bottomNavigationBar: const BottomAppBar(
               color: Colors.deepOrange,
             ),

              floatingActionButton: FloatingActionButton.extended(
                label: const Text('Sources for Data'),
                icon:const Icon(Icons.source_outlined),
                tooltip: "View Sources",
                onPressed: () async{
                  if (await canLaunch(url)) {
                  await launch(
                    url,
                    forceWebView: true,
                    enableJavaScript: true,
                  );
                }}
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

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

                              child: Text('Calendar', style: const TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white),
                                  textAlign: TextAlign.center),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                  return CalendarScreen();
                                }));
                              }
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}