// ignore_for_file: prefer_final_fields, unused_field, constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/ride_request.dart';
import 'package:quickmed/service/user/user_service.dart';

// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

//to maintain the state of the app..
enum Show { SEND_REQUEST }

class UserAppProvider extends ChangeNotifier {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';

/* THIS IS TO GET THE USERDATABASE SERVICES*/
  UserDataBaseServices _services = UserDataBaseServices();

// RIDEREQUEST SERVICE
  RideRequest _request = RideRequest();

/* THIS IS TO GET THE USERMODEL */
  UserModel? _user;
  UserModel? get getUser => _user;

/*THIS IS TO GET THE SPMODEL */

/* THIS IS TO MAINTAIN THE STATE OF THE WALLET  */
  int? _amount;
  int? get amount => _amount;

  bool alertsOnUi = false;
  bool lookingForSp = false;
  bool spFound = false;
  bool spArrived = false;
  int timeCounter = 0;
  double percentage = 0;
  late Timer periodicTimer;

  late EconsultantModel _econsultantModel;

  UserAppProvider() {
    _getUserLocation();
  }

  //FUNCTION TO GET THE USER FROM THE FIRESTORE DATABASE...
  Future<void> refreshUser() async {
    UserModel user = await _services.getUserByUid();
    _user = user;
    notifyListeners();
  }

  //THIS FUNCTION GET THE USER CURRENT USER LOCATION
  Future<Position> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      return Future.error('Location services are disabled');
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        return Future.error("Location permission denied");
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied');
    }

    Position position = await Geolocator.getCurrentPosition();

    _services.updateLocation(position.latitude, position.longitude);

    return position;
  }

  //FUNCTION TO CREATE A RIDE REQUEST
  void createRequest(String? issue, BuildContext context, UserModel user) {
    //TO GENERATE A UNIQUE ID FOR EACH REQUESTS..
    var uuid = const Uuid();
    String requestId = uuid.v1();

    //SEND RIDE REQUEST...
    _request.createRideRequest(
        id: requestId,
        userId: user.id,
        name: user.name,
        issue: issue,
        lat: user.latitude,
        long: user.longitude,
        img: user.profileImageUrl);

    //START TIMER FOR WAITING THE REQUEST...
    startWaitingTimer(user.id!, context);
  }

  void startWaitingTimer(String requestId, BuildContext context) {
    //Start the timer for waiting
    lookingForSp = true;
    notifyListeners();

    periodicTimer = Timer.periodic(const Duration(seconds: 1), (time) {
      timeCounter = timeCounter + 1;
      percentage = timeCounter / 100;
      //print("====== GOOOO $timeCounter");

      if (timeCounter == 20) {
        // WHEN THE TIMER RUNS OUT
        timeCounter = 0;
        percentage = 0;
        lookingForSp = false;

        //UPDATE THE REQUEST TO EXPIRED...
        _request.upDateRequest(EXPIRED, requestId);

        //CANCEL TIMER....
        time.cancel();

        if (alertsOnUi) {
          alertsOnUi = false;
          notifyListeners();
        }
      }
      notifyListeners();
    });
  }



  //decline request
  declineRequest(String? requestId) {
    _request.deleteRideRequest(requestId);
    periodicTimer.cancel();
    notifyListeners();
  }
}
