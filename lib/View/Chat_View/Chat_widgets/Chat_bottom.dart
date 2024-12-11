// Import necessary packages and files
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class ChatInputField extends StatefulWidget {
  @override
  State<ChatInputField> createState() => _ChatInputFieldState();
}

class _ChatInputFieldState extends State<ChatInputField> {


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        height: 60,

        child: Row(
          children: [
            IconButton(
              icon: SvgPicture.asset(
                'assets/images/Attachment.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () {
                // Handle attachment button press
              },
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.2,
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            fontSize: 18,
                          ),
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: SvgPicture.asset(
                        'assets/images/profileplus.svg',
                        width: 24,
                        height: 24,
                      ),
                      onPressed: () {
                        // Handle profile plus button press
                      },
                    ),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: SvgPicture.asset(
                'assets/images/Camera.svg',
                width: 24,
                height: 24,

              ),
              onPressed: () {
                // Handle camera button press
              },
            ),
            IconButton(
              icon:


              SvgPicture.asset(
                'assets/images/mic.svg',
                width: 24,
                height: 24,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
