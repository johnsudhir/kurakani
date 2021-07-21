import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:kurakani/constants.dart';

class ChatScreen extends StatefulWidget {
  static const String id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late FirebaseAuth _authentication;
  late FirebaseFirestore _firebaseFirestore;
  User? loggedIn;
  late String message;
  bool _initialized = false;
  final _controller = TextEditingController();
  void initialization() async {
    try {
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      setState(() {});
    }
  }



  void initState() {
    initialization();
    _authentication = FirebaseAuth.instance;
    _firebaseFirestore = FirebaseFirestore.instance;
    getCurrentUser();
    super.initState();
  }
  void getCurrentUser() {
    loggedIn = _authentication.currentUser;
    if (loggedIn != null) {
      print(loggedIn!.email);
    }
  }
  void messageStream() async{
    await for(var snapshot in _firebaseFirestore.collection('messages').snapshots()){
      for(var message in snapshot.docs){
        print(message.data()['text']);
      }
    }
  }
  void clearText(){
    _controller.clear();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                // Navigator.pop(context);
                messageStream();
              }),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            StreamBuilder<QuerySnapshot>(
              stream: _firebaseFirestore.collection('messages').snapshots(),
              builder: (context, snapshot){
                if(!snapshot.hasData){
                  return Center(
                    child: Text('Loading...')
                  );
                }
                  final messages = snapshot.data!.docs;
                  List<Text> messageWidgets = [];
                  for(var message in messages){
                    final messageText = message['text'];
                    final messageSender = message['sender'];
                    final messageWidget = Text(
                        '$messageText from $messageSender',
                      style: TextStyle(color: Colors.white),
                    );
                    messageWidgets.add(messageWidget);
                  }
                  return Column(
                    children: messageWidgets,
                  );





              },
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      //Implement send functionality.
                      _firebaseFirestore.collection('messages').add({
                        'text': message,
                        'sender': loggedIn!.email,
                      });
                      clearText();
                    },

                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,

                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
