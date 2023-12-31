import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'main.dart';
//import 'main_screen.dart';
import 'register_screen.dart';




Future goToSignUp(BuildContext context) async {
  Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => RegisterPage(showLoginPage: () {  },),
      )
  );
}

class Loginpage extends StatefulWidget {

  @override
  _Loginpage createState() => _Loginpage();

}

class _Loginpage extends State<Loginpage>  {


  void showInvalidLoginDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Information'),
          content: Text('You have entered an incorrect email and or password. Please try again.'),
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


  void showInvalidForgotPass(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Invalid Email'),
          content: Text('You have entered an incorrect email. Please try again.'),
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

  void showValidForgotPass(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Valid Email'),
          content: Text('You have entered a correct email. Please check your email.'),
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
    final _emailController = TextEditingController();
    final _passwordController = TextEditingController();



    Future signIn(BuildContext context) async {
      try {
        print('login button tapped');
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => Home(),
          ),
        );
      } on FirebaseAuthException catch (e) {
        // If an exception is thrown, show the invalid login dialog
        showInvalidLoginDialog(context);
      }
    }

    Future resetPassword(BuildContext context) async{
      try {
        await FirebaseAuth.instance.sendPasswordResetEmail(
            email: _emailController.text.trim());
            showValidForgotPass(context);
      } on FirebaseAuthException catch (e){
        showInvalidForgotPass(context);
      }
    }

    @override
    void dispose(){
      _passwordController.dispose();
      super.dispose();
    }

    return MaterialApp(
      home: Builder(
        builder: (context) =>
            Scaffold (
              backgroundColor: Color(0xFFD3C9B6),
              appBar: AppBar(
                title: Text("Login",
                style: TextStyle(color: Color(0xFFD3C9B6)),),
                backgroundColor: Color(0xFF7D491A),
              ),
              body: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(32),
                decoration: const BoxDecoration(

                ),
                child: Column(
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                        child: Text(
                          "Login",
                          style: const TextStyle(fontWeight: FontWeight.bold,
                              color: Color(0xFF826145)),
                          textScaleFactor: 3,
                        ),
                      ),

                      // Username Textfield
                      Padding (
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Email'),
                          controller: _emailController,

                        ),
                      ),

                      // Password Textfield
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          decoration: InputDecoration(labelText: 'Password'),
                          controller: _passwordController,
                          obscureText: true, // Hide the password input
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [

                          InkWell(
                            onTap: () => goToSignUp(context),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              color: Color(0xFFB1782B),
                              child: const Text(
                                'Register',
                                style: TextStyle(
                                  color: Color(0xFFD3C9B6),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),


                          InkWell(
                            onTap: () => resetPassword(context),
                            child: Container(
                              padding: const EdgeInsets.all(16.0),
                              color: Color(0xFF7D491A),
                              child: const Text(
                                'Forgot Password',
                                style: TextStyle(
                                  color: Color(0xFFD3C9B6),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () => signIn(context),
                            child: Container(
                              padding: EdgeInsets.all(16.0),
                              color: Color(0xFFB1782B),
                              child: const Text(
                                'Login',
                                style: TextStyle(
                                  color: Color(0xFFD3C9B6),
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ]
                ),
              ),
            ),
      ),
    );
  }
}