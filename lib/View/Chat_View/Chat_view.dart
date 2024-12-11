import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../Utils/Colors.dart';

class chatview extends StatefulWidget {
  const chatview({super.key});

  @override
  State<chatview> createState() => _chatviewState();
}

class _chatviewState extends State<chatview>
    with SingleTickerProviderStateMixin {
  TabController? _tabcontroller1;
  TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    _tabcontroller1 = TabController(length: 2, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colorutils.userdetailcolor,
        title: Padding(
          padding: const EdgeInsets.all(4.0),
          child: Row(
            children: [
              IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  )),
              const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
              ),
              const SizedBox(
                width: 10,
              ),
              Text(
                'My Class',
                style: GoogleFonts.inter(
                    fontSize: 20.0,
                    fontWeight: FontWeight.w600,
                    color: Colors.white),
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: Container(
              height: 27.w,
              width: 27.w,
              child: SvgPicture.asset(
                'assets/images/MagnifyingGlass.svg',
                width: 200,
                height: 200,
              ),
            ),
          )
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colorutils.userdetailcolor,
            child: TabBar(
              tabAlignment: TabAlignment.center,
              controller: _tabcontroller1,
              indicatorColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.label,
              isScrollable: true,
              tabs: <Widget>[
                Container(
                  // width: 100,
                  height: 50,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Feeded View',
                        style: GoogleFonts.inter(
                          color: Colorutils.Whitecolor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 10,
                        child: Text(
                          "6",
                          style: GoogleFonts.inter(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  // width: 100,
                  height: 50,

                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Grouped View',
                        style: GoogleFonts.inter(
                          color: Colorutils.Whitecolor,
                          fontWeight: FontWeight.w600,
                          fontSize: 16.0,
                        ),
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        radius: 10,
                        child: Text(
                          "3",
                          style: GoogleFonts.inter(
                              fontSize: 13.0,
                              fontWeight: FontWeight.w500,
                              color: Colors.green),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
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
                padding: const EdgeInsets.symmetric(horizontal: 10),
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
                        controller: _messageController,
                        decoration: const InputDecoration(
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
              icon: SvgPicture.asset(
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

class MessageBubble extends StatelessWidget {
  // final Message message;

  const MessageBubble({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 3.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 16,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.35,
              ),
              padding: const EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    offset: const Offset(0, 1),
                    blurRadius: 5,
                  ),
                ],
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "message.senderName",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.teal,
                        ),
                      ),
                      SizedBox(width: 5),
                      Text(
                        " message.senderSubtitle",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Text(
                    " message.messageContent",
                    style: TextStyle(fontSize: 16),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: Text(
                      "message.timestamp",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
