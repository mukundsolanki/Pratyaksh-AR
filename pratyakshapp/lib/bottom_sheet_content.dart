import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:slide_to_act/slide_to_act.dart';

class BottomSheetContent extends StatelessWidget {
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
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 20),
                // Add more widgets
                Center(
                  child: SvgPicture.asset(
                    'assets/ar_glasses_upload.svg',
                    height: 225,
                  ),
                ),
                SlideAction(
                  sliderRotate: false,
                  onSubmit: () {
                    print("Swiped");
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