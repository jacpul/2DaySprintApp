import 'login.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'home_screen.dart';

final navigatorKey = GlobalKey<NavigatorState>();

void main() async {
WidgetsFlutterBinding.ensureInitialized();
await Firebase.initializeApp();
runApp(MyApp());
}

// Run MyApp so we are able to use the navigator everywhere in the app
class MyApp extends StatelessWidget {
@override
Widget build(BuildContext context) {
return Loginpage();
}
}