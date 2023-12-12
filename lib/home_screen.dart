import 'package:final_project/calendar_screen.dart';
import 'package:final_project/search_screen.dart';
import 'package:final_project/compare_screen.dart';
import 'package:final_project/videos_screen.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {

  final Uri url  = Uri.parse("https://www.kaggle.com/uzair01");

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) =>
            Scaffold (
              backgroundColor: const Color(0xFFD3C9B6),
              bottomNavigationBar: const BottomAppBar(
                color: Color(0xFF3A391D),
              ),

              floatingActionButton: FloatingActionButton.extended(
                  backgroundColor: Color(0xFF826145),
                  label: const Text('Sources for Data'),
                  icon:const Icon(Icons.source_outlined),
                  tooltip: "View Sources",
                  onPressed: () async{
                    if (await launchUrl(url)) {
                      throw Exception('could not launch');
                    }}
              ),
              floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,

              appBar: AppBar(
                title: const Text("Your CS Library",
                  style: TextStyle(color: Color(0xFFD3C9B6)),),
                backgroundColor: Color(0xFF3A391D),
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
                padding: const EdgeInsets.all(32),

                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/library.png'),
                    fit: BoxFit.cover,
                  ),
                ),

                child: Column(
                  children: <Widget>[
                    Expanded(
                      child:
                      Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child:SizedBox(
                          height: 100,
                          width: 200,
                          child:
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Color(0xFFC39F67),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30)
                                ),
                              ),
                              child: const Text('Search', style: TextStyle(fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color(0xFFD3C9B6)),
                                  textAlign: TextAlign.center),
                              onPressed: () {
                                Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                  return SearchScreen();
                                }));
                              }
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child:
                      Padding(
                          padding: EdgeInsets.only(bottom: 60),
                          child:SizedBox(
                            height: 100,
                            width: 200,
                            child:
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFFB1782B),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    )
                                ),

                                child: Text('Compare', style: const TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFFD3C9B6)),
                                    textAlign: TextAlign.center),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return CompareScreen();
                                  }));
                                }
                            ),
                          )
                      ),
                    ),

                    Expanded(
                      child:
                      Padding(
                        padding: EdgeInsets.only(bottom: 60),
                        child: SizedBox(
                          height: 100,
                          width: 200,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Color(0xFF7D491A),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            child: Text('Videos', style: const TextStyle(fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: Color(0xFFD3C9B6)),
                                textAlign: TextAlign.center),
                            onPressed: () {
                              Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                return VideoResource();
                              }));
                            },
                          ),
                        ),
                      ),
                    ),

                    Expanded(
                      child:
                      Padding(
                          padding: EdgeInsets.only(bottom: 60),
                          child:SizedBox(
                            height: 100,
                            width: 200,
                            child:
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: Color(0xFF3A391D),
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30)
                                    )
                                ),

                                child: Text('Calendar', style: const TextStyle(fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                    color: Color(0xFFD3C9B6)),
                                    textAlign: TextAlign.center),
                                onPressed: () {
                                  Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                                    return CalendarScreen();
                                  }));
                                }
                            ),
                          )
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