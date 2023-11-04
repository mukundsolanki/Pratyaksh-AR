import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color.fromARGB(255, 49, 49, 49)],
          ),
        ),
        child: Center(
          child: Text(
            'This is the Settings Page',
            style: TextStyle(fontSize: 24),
          ),
        ),
      ),
    );
  }
}
