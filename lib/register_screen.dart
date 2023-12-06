import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
//import 'main_screen.dart';
import 'home_screen.dart';
import 'login.dart';

class RegisterPage extends StatefulWidget {
  final VoidCallback showLoginPage;
  const RegisterPage({
    Key? key,
    required this.showLoginPage,
  }) : super(key: key);

  @override
  _RegisterPage createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  /**
   * Clears the email controller and the password controller.
   *
   * Input: None
   * Output: None
   */
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }


  /**
   *
   * Allows for new users to create a account so there information can be saved.
   *
   * Inputs: must add a wanted email and password
   * Outputs: Creates a new user in the firebase
   */
  Future signUp() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    try {
      // Check if the email already exists in the authentication database
      await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);

      // Continue with the registration process
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // If no exception is thrown, the email does not exist
      String uID = FirebaseAuth.instance.currentUser!.uid.toString();
      final data = <String, String>{
        'email': email,
      };
      FirebaseFirestore db = FirebaseFirestore.instance;
      await db.collection('users').doc(uID).set(data);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => Home(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      // If an exception is thrown, the email already exists
      showEmailAlreadyExistsDialog(context);
    }
  }

  /**
   * Creates an error that the email has already been registered in the firebase.
   *
   * Inputs: None
   * Outputs: Creates a popup that tells you your login information is invalid
   *
   */
  void showEmailAlreadyExistsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Email'),
          content: Text('An account with that email already exists or you entered an invalid email. Please try again.'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(32),
        decoration: const BoxDecoration(

        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Text(
                  "Register",
                  style: const TextStyle(fontWeight: FontWeight.bold,
                      color: Colors.blueAccent),
                  textScaleFactor: 3,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: _emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  obscureText: true,
                  controller: _passwordController,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
              ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /**
                   * When clicked on it brings you back to the login screen
                   *
                   * Inputs: Tapping on the button
                   * Outputs: Brings you back to the login screen
                   *
                   */
                  InkWell(
                    onTap: () {
                      // Navigate to the login screen
                      // Replace 'YourLoginPage()' with the actual widget for the login screen
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => Loginpage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      color: Colors.blue,
                      child: Text(
                        'Return to Login',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                  /**
                   * When clicked on it creates a new account for you if
                   * the information is valid
                   *
                   * Inputs: A tap on the button
                   * Outputs: It logs you into the home screen and creates an account for
                   * you in firebase
                   */
                  InkWell(
                    onTap: () => signUp(),
                    child: Container(
                      padding: EdgeInsets.all(16.0),
                      color: Colors.blue,
                      child: Text(
                        'Register',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}