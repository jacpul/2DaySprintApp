import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

class Loginpage extends StatefulWidget {

  @override
  _Loginpage createState() => _Loginpage();
}

class _Loginpage extends State<Loginpage>  {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) =>
            Scaffold (
              appBar: AppBar(
                title: Text("Login"),
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
                        child: Text('Login', style: const TextStyle(fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.white),
                            textAlign: TextAlign.center),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (BuildContext context) {
                            return Home();
                          }));
                        },
                    )
                  ],
                ),
              ),
            ),
      ),
    );
  }
}