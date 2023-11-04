import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
import 'package:lottie/lottie.dart';
import 'package:slide_to_act/slide_to_act.dart';
import 'package:web_socket_channel/io.dart';

class BottomSheetContent extends StatelessWidget {

  final List<String> tasks;
  final String ipAddress;

  BottomSheetContent({required this.tasks , required this.ipAddress});

  void _sendTasksToServer() {
    final channel = IOWebSocketChannel.connect('ws://$ipAddress:5000');
    channel.sink.add(tasks.join(','));
    channel.sink.close();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(Icons.close),
                      onPressed: () {
                        Navigator.pop(context); // Close the bottom sheet
                      },
                    ),
                  ],
                ),
                Center(
                  child: Text(
                    'Sync with AR Glasses',
                    style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),

                Center(
                  // child: SvgPicture.asset(
                  //   'assets/ar_glasses_upload.svg',
                  //   height: 225,
                  // ),
                  child: Lottie.asset(
                    'animations/animation_lo4rog07.json',
                    width: 200,
                    height: 200,
                    fit: BoxFit.cover,
                  ),
                ),

                SizedBox(height: 12),

                SlideAction(
                  sliderButtonIcon: Icon(Icons.arrow_right),
                  text: 'Slide to Sync!',
                  textStyle: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 23,
                  ),
                  sliderRotate: false,
                  onSubmit: () {
                    // print("Swiped");
                    _sendTasksToServer();
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}