import 'package:flutter/material.dart';
//import 'login_auto.dart';
import 'login_hive.dart';
import 'splash.dart';
import 'package:hive_flutter/hive_flutter.dart';



void main() async {

  await Hive.initFlutter(); // Initialize Hive
  await Hive.openBox('userBox'); // Open a Hive box

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    initialRoute: '/',
    routes: {
      '/': (context) => SplashScreen(),
      '/login': (context) => LoginPageHive(), // Your main screen // for auto LotinPageAuto
    },
  ));
}

