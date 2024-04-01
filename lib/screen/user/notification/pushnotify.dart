import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:quickmed/global/global.dart';
import 'package:quickmed/provider/app_info.dart';

class PushNotificationService
{
  static sendNotificationToSelectedDriver(String deviceToken, BuildContext context, String tripID) async
  {
    String dropOffDestinationAddress = Provider.of<AppInfo>(context, listen: false).dropOffLocation!.placeName.toString();
    String pickUpAddress = Provider.of<AppInfo>(context, listen: false).pickUpLocation!.placeName.toString();

    Map<String, String> headerNotificationMap =
    {
      "Content-Type": "application/json",
      "Authorization": serverKeyFCM,
    };

    Map titleBodyNotificationMap =
    {
      "title": "NET TRIP REQUEST from $userName",
      "body": "PickUp Location: $pickUpAddress \nDropOff Location: $dropOffDestinationAddress",
    };

    Map dataMapNotification =
    {
      "click_action": "FLUTTER_NOTIFICATION_CLICK",
      "id": "1",
      "status": "done",
      "tripID": tripID,
    };

    Map bodyNotificationMap =
    {
      "notification": titleBodyNotificationMap,
      "data": dataMapNotification,
      "priority": "high",
      "to": deviceToken,
    };

    await http.post(
      Uri.parse("https://fcm.googleapis.com/fcm/send"),
      headers: headerNotificationMap,
      body: jsonEncode(bodyNotificationMap),
    );
  }
}