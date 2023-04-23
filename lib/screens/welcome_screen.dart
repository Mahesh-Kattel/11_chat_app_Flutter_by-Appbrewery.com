import 'package:angelachatapp/screens/login_screen.dart';
import 'package:angelachatapp/screens/registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';

import '../components/components.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  Animation? animation;
  AnimationController? controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    controller =
        AnimationController(duration: const Duration(seconds: 1), vsync: this);
    controller!.forward();
    // animation = CurvedAnimation(parent: controller!, curve: Curves.decelerate);
    animation =
        ColorTween(begin: Colors.red, end: Colors.white).animate(controller!);
    controller!.addListener(() {
      setState(() {});
      // print(animation!.value);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation!.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('assets/logo.png'),
                    height: 60,
                  ),
                ),
                TypewriterAnimatedTextKit(
                  speed: Duration(milliseconds: 200),
                  isRepeatingAnimation: false,
                  textStyle: const TextStyle(
                    color: Colors.red,
                    fontSize: 43.0,
                    fontWeight: FontWeight.w900,
                  ),
                  text: const ['Flash Chat'],
                ),
              ],
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              color: Colors.lightBlueAccent,
              title: 'Login',
              onPress: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
                onPress: () {
                  Navigator.pushNamed(context, RegistrationScreen.id);
                },
                color: Colors.lightBlue,
                title: 'Register')
          ],
        ),
      ),
    );
  }
}
