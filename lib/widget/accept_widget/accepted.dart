import 'package:flutter/material.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/screen/user/chat/chat.dart';

class AcceptRequestScreen extends StatefulWidget {
  final double userLatitude;
  final double userLongitude;
  final String userId;
  final String driverId;

  const AcceptRequestScreen(
      {super.key, required this.userLatitude,
      required this.userLongitude,
      required this.userId,
      required this.driverId});

  @override
  // ignore: library_private_types_in_public_api
  _AcceptRequestScreenState createState() => _AcceptRequestScreenState();
}

class _AcceptRequestScreenState extends State<AcceptRequestScreen> {
  // Initialize TextEditingController for chat message input

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accept Request'),
      ),
      body: Stack(
        children: [
          // Map Widget to display user's location
          // You can use any map widget here, like Google Maps or Flutter's Mapbox
          // Replace Container with your map widget
          SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            // Replace this with your map widget
            child: Center(
              child: Text(
                'User Location: ${widget.userLatitude}, ${widget.userLongitude}',
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          // Draggable chat widget
          Positioned(
            bottom: 0,
            child: Draggable(
              feedback: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(16.0),
                child: const Text(
                  'Drag to move chat',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              childWhenDragging: Container(),
              axis: Axis.vertical,
              feedbackOffset: const Offset(0, 0),
              child: Container(
                width: MediaQuery.of(context).size.width,
                color: Colors.grey[200],
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Chat',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    // Chat messages will be displayed here
                    Expanded(
                      child: ListView(
                        children: const [
                          // Replace with actual chat messages
                          ListTile(
                            title: Text('Driver: Hello!'),
                          ),
                          ListTile(
                            title: Text('User: Hi, can you help me?'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Text input for sending messages
                    Column(
                      children: [
                        ListTile(
                            onTap: () {
                              changeScreen(
                                  context,
                                  MyChatApp(
                                    userId: widget.userId,
                                    name: widget.userId,
                                    img: widget.userId,
                                    isOnline: true,
                                  ));
                            },
                            leading: Image.network(
                              "https://res.cloudinary.com/damufjozr/image/upload/v1701761216/pers_jfroff.png",
                              width: 40,
                              height: 40,
                            ),
                            title: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                RichText(
                                    text: const TextSpan(children: [
                                  TextSpan(
                                      text: "Chat",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300)),
                                ], style: TextStyle(color: Colors.black))),
                              ],
                            )),
                      ],
                    ),
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
