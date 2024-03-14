import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/model/chatmodel/chat_model.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;

StreamSubscription<Position>? streamSubscriptionPosition;
StreamSubscription<Position>? streamSubscriptionDriverLivePosition;


UserModel? userModelCurrentInfo;
Position? driverCurrentPosition;
DriverModel onLineDriver = DriverModel();

List<MessageData> messageList = [];

String? driverVehicleType = "";

String userDropOffAddress = "";

SharedPreferences? sharedPrefs;
