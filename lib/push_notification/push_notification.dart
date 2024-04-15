// ignore_for_file: body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/model/trip_details.dart';
import 'package:quickmed/widget/loading_dialog.dart';
import 'package:quickmed/widget/notification_dialog.dart';

class PushNotificationSystem {
  FirebaseMessaging firebaseCloudMessaging = FirebaseMessaging.instance;
  // static final _notification = FlutterLocalNotificationsPlugin();

  Future<String?> generateDeviceRegistrationToken() async {
    String? deviceRecognitionToken = await firebaseCloudMessaging.getToken();

    DatabaseReference referenceOnlineDriver = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("deviceToken");

    referenceOnlineDriver.set(deviceRecognitionToken);

    firebaseCloudMessaging.subscribeToTopic("drivers");
    firebaseCloudMessaging.subscribeToTopic("users");
  }

  // static Future _notificationDetail() async {
  //   return const NotificationDetails(
  //     android: AndroidNotificationDetails('channel id', 'channel name',
  //         importance: Importance.max),
  //   );
  // }

  // Future showNotification(
  //     {int id = 0, String? title, String? body, String? payload}) async {
  //   _notification.show(id, title, body, await _notificationDetail(),
  //       payload: payload);
  // }

  startListeningForNewNotification(BuildContext context) async {
    ///1. Terminated
    //When the app is completely closed and it receives a push notification
    FirebaseMessaging.instance
        .getInitialMessage()
        .then((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];
        retrieveTripRequestInfo(tripID, context);
      }
    });

    ///2. Foreground
    //When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];

        retrieveTripRequestInfo(tripID, context);
      }
    });

    ///3. Background
    //When the app is in the background and it receives a push notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage? messageRemote) {
      if (messageRemote != null) {
        String tripID = messageRemote.data["tripID"];

        retrieveTripRequestInfo(tripID, context);
      }
    });
  }

  retrieveTripRequestInfo(String tripID, BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) =>
          LoadingDialog(messageText: "getting details..."),
    );

    DatabaseReference tripRequestsRef =
        FirebaseDatabase.instance.ref().child("tripRequests").child(tripID);

    tripRequestsRef.once().then((dataSnapshot) {
      Navigator.pop(context);

      // audioPlayer.open(
      //   Audio(
      //     "assets/audio/alert_sound.mp3"
      //   ),
      // );

      //audioPlayer.play();

      TripDetails tripDetailsInfo = TripDetails();
      double pickUpLat = double.parse(
          (dataSnapshot.snapshot.value! as Map)["pickUpLatLng"]["latitude"]);
      double pickUpLng = double.parse(
          (dataSnapshot.snapshot.value! as Map)["pickUpLatLng"]["longitude"]);
      tripDetailsInfo.pickUpLatLng = LatLng(pickUpLat, pickUpLng);

      tripDetailsInfo.pickupAddress =
          (dataSnapshot.snapshot.value! as Map)["pickUpAddress"];

      double dropOffLat = double.parse(
          (dataSnapshot.snapshot.value! as Map)["dropOffLatLng"]["latitude"]);
      double dropOffLng = double.parse(
          (dataSnapshot.snapshot.value! as Map)["dropOffLatLng"]["longitude"]);
      tripDetailsInfo.dropOffLatLng = LatLng(dropOffLat, dropOffLng);

      tripDetailsInfo.dropOffAddress =
          (dataSnapshot.snapshot.value! as Map)["dropOffAddress"];

      tripDetailsInfo.userName = (dataSnapshot.snapshot.value! as Map)["name"];
      tripDetailsInfo.userPhone =
          (dataSnapshot.snapshot.value! as Map)["Phone"];

      tripDetailsInfo.tripID = tripID;

      showDialog(
        context: context,
        builder: (BuildContext context) => NotificationDialog(
          tripDetailsInfo: tripDetailsInfo,
        ),
      );
    });
  }
}
