import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kurakani/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:kurakani/screens/chat_screen.dart';
import 'package:kurakani/screens/loading.dart';
import '../RoundedButton.dart';
class RegistrationScreen extends StatefulWidget {
  static const String id = 'RegistrationScreen';
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  late String email;
  late String password;
  late FirebaseAuth _authentication;
  bool _initialized = false;
  bool _error = false;
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
        _error = true;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return _showSlider? Loading():Scaffold(
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
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Colors. black),
              onChanged: (value) {
                email = value;

              },
                textAlign: TextAlign.center,
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your email')
            ),
            SizedBox(
              height: 8.0,
            ),
            TextField(
              textAlign: TextAlign.center,
              obscureText: true,
              style: TextStyle(color: Colors. black),
              onChanged: (value) {
                password = value;
              },
              decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
            ),
            SizedBox(
              height: 24.0,
            ),
            RoundedButton(
              title: 'Register',
              color: Colors.blueAccent,
              onPressed: () async{
                  print(email);
                  print(password);
                  try{
                    final newUser = await _authentication.createUserWithEmailAndPassword(email: email, password: password);
                    if(newUser != null){
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

