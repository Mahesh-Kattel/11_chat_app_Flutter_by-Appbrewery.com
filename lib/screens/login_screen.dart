import 'package:angelachatapp/components/components.dart';
import 'package:angelachatapp/constants.dart';
import 'package:angelachatapp/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static String id = 'login_screen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String? email;
  String? password;
  final _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Container(
                height: 200.0,
                child: Image.asset('assets/logo.png'),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                onChanged: (value) {
                  email = value;
                  //Do something with the user input.
                },
                decoration:
                    KTextFieldDecoration.copyWith(hintText: 'Email Here...'),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                obscureText: true,
                onChanged: (value) {
                  password = value;
                  //Do something with the user input.
                },
                decoration:
                    KTextFieldDecoration.copyWith(hintText: 'Password Here...'),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  onPress: () async {
                    try {
                      final user = await _auth.signInWithEmailAndPassword(
                          email: email!, password: password!);
                      if (user != null) {
                        Navigator.pushNamed(context, ChatScreen.id);
                      }
                    } catch (e) {
                      print(e.toString());
                    }
                  },
                  color: Colors.lightBlueAccent,
                  title: 'Login')
            ],
          ),
        ),
      ),
    );
  }
}
