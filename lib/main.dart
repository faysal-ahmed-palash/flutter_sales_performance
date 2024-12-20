import 'package:flutter/material.dart';
import 'login_auto.dart';
import 'splash.dart';




void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/login': (context) => LoginPageAuto(), // Your main screen
    },
  ));
}

