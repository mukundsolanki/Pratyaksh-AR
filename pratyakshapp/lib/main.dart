import 'package:flutter/material.dart';
import 'package:pratyakshapp/home_page.dart';
import 'package:pratyakshapp/welcome_screen.dart';

void main() {
  runApp( MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String? ipAddress;

  void setIPAddress(String ip) {
    setState(() {
      ipAddress = ip;
    });
  }

  @override
  Widget build(BuildContext context) {
    Widget screen;

    if (ipAddress == null) {
      screen = WelcomeScreen(onIPSubmit: setIPAddress);
    } else {
      screen = HomePage(ipAddress: ipAddress!);
    }

    return MaterialApp(
      title: 'App for deaf',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: screen,
      // debugShowCheckedModeBanner: false,
    );
  }
}