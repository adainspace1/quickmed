// ignore_for_file: non_constant_identifier_names

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class FirebaseAPi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: true,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    //final FCMToken = await _firebaseMessaging.getToken();

    // Set up message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {

      // Display the received message using Fluttertoast
      Fluttertoast.showToast(
        msg: "${message.notification?.title}: ${message.notification?.body}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.blue,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    });

    // Function to handle when the app is in the background and the user taps the notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {

      // Handle the notification tap event as needed
    });
  }
}
