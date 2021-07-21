import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:kurakani/RoundedButton.dart';
import 'package:kurakani/screens/login_screen.dart';
import 'package:kurakani/screens/registration_screen.dart';


class WelcomeScreen extends StatefulWidget {
  static const String id = 'WelcomeScreen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin{
  late AnimationController controller;
  late Animation animation;
  bool _initialized = false;
  bool _error = false;
  @override
  void initState() {
    initialization();
    super.initState();
    controller = AnimationController(
      duration: Duration(seconds: 3),
        vsync: this,
    );
    //CurverAnimation, ColorTween or in broad Tween animation etc.
    animation = CurvedAnimation(
      parent: controller,
      curve: Curves.ease,
    );
    controller.forward();
    controller.addListener(() {
      setState(() {

      });
    });
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
    return Scaffold(
      backgroundColor: Colors.white.withOpacity(1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Hero(
                    tag: 'logo',
                    child: Container(
                      child: Image(
                        image: AssetImage('images/logo.png'),
                      ),
                      height: animation.value * 100,
                    ),
                  ),
                ),
                Text(
                  'Kura Kani',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              color: Colors.blue,
              onPressed: (){
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              title: 'Register',
              color: Colors.blue,
              onPressed: (){
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}