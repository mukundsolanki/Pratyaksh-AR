import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class WelcomeScreen extends StatelessWidget {
  final Function(String) onIPSubmit;

  const WelcomeScreen({Key? key, required this.onIPSubmit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String ipAddress = '';

    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/welcome.jpg',
              fit: BoxFit.cover,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Align text to the left
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 40.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 10.0), // Spacer
                    // Input Field and Button Side by Side
                    Row(
                      children: [
                        // Input Field
                        Expanded(
                          child: TextField(
                            keyboardType: TextInputType.number,
                            onChanged: (value) {
                              ipAddress = value;
                            },
                            decoration: InputDecoration(
                              labelText: 'Enter your unique code',
                              labelStyle: TextStyle(color: Colors.white),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                borderSide: BorderSide(color: Colors.white),
                              ),
                            ),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                        SizedBox(width: 20.0),
                        // Button
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 30,
                          child: IconButton(
                            onPressed: () {
                              onIPSubmit(ipAddress);
                              Fluttertoast.showToast(
                                  msg: "Connected Sucessfully",
                                  toastLength: Toast.LENGTH_SHORT,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            },
                            icon: Icon(
                              Icons.arrow_forward,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Created with ☕ by ',
                              style: TextStyle(
                                fontSize: 15,
                                color: Colors.white,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            TextSpan(
                              text: 'SyntaxSorcerers',
                              style: TextStyle(
                                fontSize: 15,
                                color: Color.fromARGB(255, 65, 227, 168),
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 150.0),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}