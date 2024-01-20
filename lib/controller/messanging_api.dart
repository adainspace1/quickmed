// ignore_for_file: prefer_interpolation_to_compose_strings, non_constant_identifier_names, unused_local_variable

import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseAPi {
  // create an instance of firebase messaging
  final _firebaseMessaging = FirebaseMessaging.instance;

  // function to initialize messaging notification
  Future<void> initNotification() async {
    // request permission from user
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
      

    );

    //fetch the fireebase cloud messsaging  token for this device
    final FCMToken = await _firebaseMessaging.getToken();

    // print the token we will send o the server
    // print("Token:" + FCMToken.toString());
  }

  //function to handle receive message
}
