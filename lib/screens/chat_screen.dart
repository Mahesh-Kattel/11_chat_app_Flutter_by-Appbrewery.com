import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:angelachatapp/constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

final _fireStore = FirebaseFirestore.instance;
User? loggedInuser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController messegeController = TextEditingController();
  String? messegeText;

  final _auth = FirebaseAuth.instance;

  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInuser = user;
        print(loggedInuser!.email);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void messegesStream() async {
    await for (var snapshot in _fireStore.collection('messeges').snapshots()) {
      //here
      for (var messege in snapshot.docs) {
        print(messege.data());
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () {
                // messegesStream();
                _auth.signOut();
                Navigator.pop(context);
                //Implement logout functionality
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const MessegesStream(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messegeController,
                      onChanged: (value) {
                        messegeText = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  CupertinoButton(
                    onPressed: () {
                      messegeController.clear();
                      _fireStore.collection('messeges').add({
                        'text': messegeText,
                        'sender': loggedInuser!.email,
                      });
                      //Implement send functionality.
                    },
                    child: const Text(
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

class MessegesStream extends StatelessWidget {
  const MessegesStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _fireStore.collection('messeges').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator(
            backgroundColor: Colors.lightBlue,
          );
        }
        final messeges = snapshot.data!.docs.reversed;
        List<MessegeBubble> messegeBubble = [];
        for (var messege in messeges) {
          final messegetext = messege['text'];
          final messegesender = messege['sender'];
          final currentUser = loggedInuser!.email;
          if (currentUser == messegesender) {}
          final messegeWidget = MessegeBubble(
            text: messegetext,
            sender: messegesender,
            isMe: currentUser == messegesender,
          );
          messegeBubble.add(messegeWidget);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            padding: const EdgeInsets.all(15),
            children: messegeBubble,
          ),
        );

        return Container();
      },
    );
  }
}

class MessegeBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  MessegeBubble({required this.text, required this.sender, required this.isMe});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            '$sender',
            style: const TextStyle(fontSize: 13, color: Colors.black),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  )
                : BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.lightBlue : Colors.lightGreen,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text(
                '$text',
                style: const TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
