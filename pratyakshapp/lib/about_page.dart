import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  // URL to be opened when the button is clicked
  final String websiteUrl = 'https://www.example.com';

  // Function to launch the website in a browser
  void _launchWebsite() async {
    if (await canLaunch(websiteUrl)) {
      await launch(websiteUrl);
    } else {
      throw 'Could not launch $websiteUrl';
    }
  }

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Image at the center of the page
              ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: Image.asset(
                  'assets/about.jpg', // Replace with your image asset path
                  height: 250,
                  // width: 150,
                ),
              ),
              SizedBox(height: 20),
              Text(
                'To know more....',
                style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                    fontStyle: FontStyle.italic),
              ),
              SizedBox(height: 20),
              // Button to open the website in a browser
              ElevatedButton(
                onPressed: _launchWebsite,
                child: Text('Visit Website'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
