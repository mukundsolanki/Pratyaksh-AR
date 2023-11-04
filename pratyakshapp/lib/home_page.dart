import 'package:flutter/material.dart';
import 'about_page.dart';
import 'settings_page.dart';
import 'bottom_sheet_content.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pratyaksh AR',
      home: HomePage(ipAddress: '127.0.0.1'), // Example IP address
    );
  }
}

class HomePage extends StatefulWidget {
  final String ipAddress;

  HomePage({required this.ipAddress});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> tasks = [];
  TextEditingController _taskController = TextEditingController();
  int _currentIndex = 0;

  void _addTask() {
    String task = _taskController.text;
    if (task.isNotEmpty) {
      setState(() {
        tasks.insert(0, task);
        _taskController.clear();
      });
    }
  }

  void _deleteTask(int index) {
    setState(() {
      tasks.removeAt(index);
    });
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30))),
      builder: (BuildContext context) {
        return BottomSheetContent(tasks: tasks, ipAddress: widget.ipAddress);
      },
    );
  }

  void _onBottomNavigationBarTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          'Pratyaksh AR',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color.fromARGB(255, 65, 227, 168),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_upload_outlined),
            onPressed: () {
              _showBottomSheet(context);
            },
          ),
        ],
      ),
      body: Navigator(
        onGenerateRoute: (RouteSettings settings) {
          return PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) {
              if (_currentIndex == 0) {
                return FadeTransition(
                  opacity: animation,
                  child: _buildHomeContent(),
                );
              } else if (_currentIndex == 1) {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: AboutPage(),
                );
              } else {
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset(-1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: SettingsPage(),
                );
              }
            },
          );
        },
      ),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: Color.fromARGB(255, 67, 67, 67),
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(color: Colors.white)
          )
        ),
        child: NavigationBar(
          backgroundColor: Colors.black,
          // selectedItemColor: Color.fromARGB(255, 65, 227, 168),
          // unselectedItemColor: Colors.white,
          selectedIndex: _currentIndex,
          onDestinationSelected: _onBottomNavigationBarTapped,
          destinations: [
            NavigationDestination(
              icon: Icon(Icons.home_outlined, color: Colors.white,),
              label: 'Home',
              selectedIcon: Icon(Icons.home, color: Colors.white,),
            ),
            NavigationDestination(
              icon: Icon(Icons.info_outline, color: Colors.white,),
              label: 'About',
              selectedIcon: Icon(Icons.info, color: Colors.white,),
            ),
            NavigationDestination(
              icon: Icon(Icons.settings_outlined, color: Colors.white,),
              label: 'Settings',
              selectedIcon: Icon(Icons.settings, color: Colors.white,),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHomeContent() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.black, Color.fromARGB(255, 49, 49, 49)],
        ),
      ),
      child: Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16.0, 8.0, 8.0, 8.0),
              child: Text(
                'Hey Mukund,',
                textAlign: TextAlign.left,
                style: TextStyle(
                  fontFamily: 'Nunito',
                  wordSpacing: 2,
                  fontSize: 37,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  color: Colors.black45,
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(
                          Icons.voice_chat,
                          color: Color.fromARGB(255, 65, 227, 168),
                        ),
                        Expanded(
                          child: Text(
                            ' ${tasks[index]}',
                            style:
                                TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () => _deleteTask(index),
                          color: Colors.red,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(20),
            margin: EdgeInsets.all(18),
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color.fromARGB(255, 65, 227, 168).withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 35,
                  offset: Offset(0, 0),
                ),
              ],
              color: Colors.black87,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: TextField(
                    controller: _taskController,
                    style: TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter your Wake Word',
                      hintStyle: TextStyle(color: Colors.grey),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addTask,
                  child: Icon(
                    Icons.add,
                    color: Colors.black,
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Color.fromARGB(255, 65, 227, 168),
                    ),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      CircleBorder(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _taskController.dispose();
    super.dispose();
  }
}