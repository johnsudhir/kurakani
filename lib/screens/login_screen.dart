import 'dart:ui';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kurakani/RoundedButton.dart';
import 'package:kurakani/constants.dart';
import 'package:kurakani/screens/chat_screen.dart';
import 'package:kurakani/screens/loading.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late String _email;
  late String _password;
  late FirebaseAuth _authentication;
  bool _initialized = false;
  bool _error = true;
  bool _showSlider = false;
  bool _isVisible = false;
  @override
  void initState() {
    initialization();
    _authentication = FirebaseAuth.instance;
    super.initState();
  }

  void initialization() async{
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });

    }
    catch(e){
      setState(() {
        _error = false;
      });

    }
  }
  @override
  Widget build(BuildContext context) {
    return _showSlider?Loading():Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Hero(
              tag: 'logo',
              child: Container(
                height: 200.0,
                child: Image.asset('images/logo.png'),
              ),
            ),
            SizedBox(
              height: 48.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors. black),
              onChanged: (value) {
                _email = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email'),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(
              height: 8.0,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                textAlign: TextAlign.center,
                obscureText: true,
                style: TextStyle(color: Colors. black),
                onChanged: (value) {
                  _password = value;
                },
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
            ),
            SizedBox(
              height: 24.0,
            ),
           RoundedButton(
             title: 'Log In',
             color: Colors.blueAccent,
             onPressed: () async{
                try{
                  final user = await _authentication.signInWithEmailAndPassword(email: _email, password: _password);
                  if(user != null){
                    setState(() {
                      _showSlider = true;
                    });
                    Navigator.pushReplacementNamed(context, ChatScreen.id);
                  }
                }
                catch(e){
                  _showSlider = false;
                  setState(() {
                    _isVisible = true;
                  });
                  print(e);
                }
             },
           ),
            Visibility(
              visible: _isVisible,
              child: Text(
                'Cannot Register with these details',
                style: TextStyle(
                  color: Colors.red,
                ),

              ),
            )
          ],
        ),
      ),
    );
  }
}