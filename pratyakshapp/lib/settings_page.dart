import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:web_socket_channel/io.dart';

class SettingsPage extends StatelessWidget {
  final String ipAddress;
  SettingsPage({required this.ipAddress});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color.fromARGB(255, 49, 49, 49)],
          ),
        ),
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Container(
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  child: Image.asset(
                    'assets/banner.jpg',
                    fit: BoxFit.cover,
                    // height: 100,
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Center(
                      child: CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 20,
                        percent: 0.70,
                        progressColor: Color.fromARGB(255, 65, 227, 168),
                        arcType: ArcType.FULL,
                        arcBackgroundColor: Color.fromARGB(255, 54, 54, 54),
                        circularStrokeCap: CircularStrokeCap.round,
                        center: Text(
                          '70%',
                          style: TextStyle(fontSize: 30, color: Colors.white),
                        ),
                      ),
                    ),
                    _buildInfoRow("Device Name", "Pratyaksh AR"),
                    _buildInfoRow("Connectivity Status", "Connected"),
                    _buildInfoRow("Device Firmware", "v1.0.0"),
                    _buildInfoRow("IP Address", ipAddress),
                    _buildInfoRow("MAC Address", "AA:BB:CC:DD:EE:FF"),
                    SizedBox(width: 10),
                    _buildUnlinkButton(),
                    // Add more info rows as needed
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showDialog(context, ipAddress); // Function to show the dialog box
        },
        child: Icon(Icons.translate),
        backgroundColor: Color.fromARGB(255, 65, 227, 168),
      ),
    );
  }

  Widget _buildInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: Colors.white),
          ),
          Text(
            value,
            style: TextStyle(
                fontSize: 16.0, color: Color.fromARGB(255, 242, 242, 242)),
          ),
        ],
      ),
    );
  }
}

Widget _buildUnlinkButton() {
  return Padding(
    padding: const EdgeInsets.all(16.0),
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          // Implement your unlink device logic here
        },
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30.0),
          ),
          primary: const Color.fromARGB(255, 200, 13, 0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.link_off,
                color: Colors.white,
              ),
              SizedBox(width: 8.0),
              Text(
                "Unlink Device",
                style: TextStyle(fontSize: 16.0, color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

void _showDialog(BuildContext context, String ipAddress) {
  String? selectedOption = 'English'; // Initial selected option as nullable

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text("Select an Language"),
        content: DropdownButton<String>(
          value: selectedOption,
          onChanged: (String? newValue) {
            if (newValue != null) {
              selectedOption = newValue;
            }
          },
          items: <String>['English', 'हिन्दी', 'मराठी']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
        actions: <Widget>[
          TextButton(
            child: Text("Close"),
            onPressed: () {
              if (selectedOption != null) {
                print('Selected Option: $selectedOption');
                final channel =
                    IOWebSocketChannel.connect('ws://$ipAddress:5000');
                channel.sink.add(selectedOption);
                channel.sink.close();
              }
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}