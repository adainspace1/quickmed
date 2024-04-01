import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/model/chatmodel/chat_model.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

//this is for the user detalsi
User? currentUser;
String userName = "";
String userPhone = "";
String userID = FirebaseAuth.instance.currentUser!.uid;

//subscription stream of position
StreamSubscription<Position>? streamSubscriptionPosition;

//subscription stream of driver position
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;

//subscription stream of position
StreamSubscription<Position>? positionStreamHomePage;
//serverkeyFCM for messaging api
String serverKeyFCM =
    "AAAALrs8FtM:APA91bG1YcRWoBxJy-YCnDKecCOhYpm12y6HxjOrpEHy-YSN92U0DvdXCDVbgKRxi_dD4_io3dqXAzcfCBVLw3lcyJXNhUu_DifZ2fsZDmtTGHD0yMVlpoNIg53UJsUCzGWFqM10dChj";

// user model current info
UserModel? userModelCurrentInfo;

Position? driverCurrentPosition;
Position? currentPositionOfUser;

//driver model current info
DriverModel onLineDriver = DriverModel();

//google initial camera position
const CameraPosition googlePlexInitialPosition = CameraPosition(
  target: LatLng(9.0537984, 7.4612736),
  zoom: 14.4746,
);

int driverTripRequestTimeout = 20;

//list of message
List<MessageData> messageList = [];

String? driverVehicleType = "";

String userDropOffAddress = "";

SharedPreferences? sharedPrefs;

StreamSubscription<Position>? positionStreamNewTripPage;

String tripID = "";
//driver details
String driverName = "";
String driverPhone = "";
String driverPhoto = "";
String carColor = "";
String carModel = "";
String carNumber = "";
