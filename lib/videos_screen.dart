import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:final_project/search_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import 'calendar_screen.dart';
import 'compare_screen.dart';
import 'home_screen.dart';

class VideoResource extends StatefulWidget {
  @override
  _VideoResource createState() => _VideoResource();
}

class _VideoResource extends State<VideoResource> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB1782B),
      appBar: AppBar(
          title: Text("Video Resources", style: TextStyle(color: Color(0xFFD3C9B6)),),
          centerTitle: true,
          backgroundColor: Color(0xFF7D491A),
          actions: [
            /// Icon button to log out and bring user back to the login screen
            IconButton(
                icon: const Icon(Icons.home, color: Color(0xFFD3C9B6)),
                tooltip: 'Home',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return Home();
                      }));
                }
            ),
            /// Icon button to log out and bring user back to the search screen
            IconButton(
                icon: const Icon(Icons.search_outlined, color: Color(0xFFD3C9B6)),
                tooltip: 'Search',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return SearchScreen();
                      }));
                }
            ),
            /// Icon button to log out and bring user back to the compare screen
            IconButton(
                icon: const Icon(Icons.compare, color: Color(0xFFD3C9B6)),
                tooltip: 'Compare',
                onPressed: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (BuildContext context) {
                        return CompareScreen();
                      }));
                }
            ),
            /// Icon button to log out and bring user back to the video screen
            IconButton(
                icon: const Icon(Icons.play_arrow_outlined, color: Color(0xFFD3C9B6)),
                tooltip: 'Videos',
                onPressed: () {

                }
            ),
            IconButton(
                icon: const Icon(Icons.calendar_month, color: Color(0xFFD3C9B6),),
                tooltip: 'Calendar',
                onPressed: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (BuildContext context) {
                    return CalendarScreen();
                  }));
                })
          ]
      ),

      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('Video Resources').snapshots(),
          builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot){
            if(!snapshot.hasData){
              return Center(
                  child: Text("No Data Available")
              );
            }

            return ListView(
              children: snapshot.data!.docs.map((document){
                return Center(
                  child: Container(
                      width: MediaQuery.of(context).size.width /1.2,
                      height: MediaQuery.of(context).size.height/5,
                      child: Column(
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top: 10.0),
                            ),
                            Text(document["title"], style: const TextStyle(fontWeight: FontWeight.bold,
                              fontSize: 22,
                              color: Color(0xFF3A391D)
                            )),
                            //Text("URL: "+ document["url"]),
                            /**
                             * When clicked on the button will bring you to a
                             * screen that will show you a video resource.
                             *
                             * Input: A tap on the button on a screen
                             * Output: It will bring you to a video on youtube
                             */
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFD3C9B6)
                                ),
                                child: Text('Open Link',  style: const TextStyle(fontWeight: FontWeight.normal,
                                    fontSize: 18,
                                    color: Color(0xFF3A391D)),
                                    textAlign: TextAlign.center),
                                onPressed: () async {
                                  final url = document["url"];

                                  if (await canLaunch(url)) {
                                    await launch(
                                      url,
                                      forceWebView: true,
                                      enableJavaScript: true,
                                    );
                                  }
                                }
                            ),
                            Divider(
                              color: Color(0xFFD3C9B6),
                              thickness: 5,
                            )
                          ]
                      )
                  ),
                );
              }).toList(),
            );
          }
      ),
    );
  }
}