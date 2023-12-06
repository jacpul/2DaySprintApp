import 'package:final_project/login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async{
  await Firebase.initializeApp(
    name: 'CodingOmegaFinal',
    options: FirebaseOptions(
      apiKey: "AIzaSyDf0Q9fYr0Fo8QnjADYn4XCrZMZrE7YTFg",
      projectId: "codingomegafinal",
      appId: "1:900504350663:android:bf86c81b4c769d941a73e2",
      messagingSenderId: "900504350663",
    ),
  );
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
      return MaterialApp(
        home: Loginpage(),
      );
    }
}
