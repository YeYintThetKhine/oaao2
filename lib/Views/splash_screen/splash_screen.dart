import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/animation.dart';
import '../../Views/landing_page/home_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../../Auth/auth.dart';

class SplashScreen extends StatefulWidget {
  final AuthFunction authFunction;
  SplashScreen({this.authFunction});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  Animation splashLogoAnimation, splashTextAnimation;
  AnimationController animationController;
  var flutterLocalNotificationsPlugin = new FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1200));
    splashLogoAnimation = Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: animationController, curve: Curves.elasticOut));
    animationController.forward();
    super.initState();
    var initializationSettingsAndroid =
        new AndroidInitializationSettings('launcher_icon');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        initializationSettingsAndroid, initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
    startTime();
  }

  Future onSelectNotification(String payload) async {
    if (payload != null) {
      debugPrint('notification payload: ' + payload);
      await Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HomeScreen(
                    authFunction: Authentic(),
                  )));
    }
  }

  startTime() async {
    var _duration = new Duration(milliseconds: 1500);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (BuildContext context) => HomeScreen(
              authFunction: Authentic(),
            )));
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    return AnimatedBuilder(
      animation: animationController,
      builder: (BuildContext context, Widget child) {
        return Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Image.asset(
                            'assets/images/logo.png',
                            width:
                                splashLogoAnimation.value * deviceWidth - 100,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 24.0),
                          ),
                          Text(
                            "Medical Application".toUpperCase(),
                            style: TextStyle(
                                color: Color(0xFF72bb53),
                                fontSize: 25.0,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        );
      },
    );
  }
}
