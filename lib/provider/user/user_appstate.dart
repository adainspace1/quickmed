// ignore_for_file: prefer_final_fields, unused_field, constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/location_service.dart';
import 'package:quickmed/service/ride_request.dart';
import 'package:quickmed/service/user/user_service.dart';

// ignore: depend_on_referenced_packages
import 'package:uuid/uuid.dart';

//to maintain the state of the app..
enum Show { SP_ACCEPTED, SEND_REQUEST }

class UserAppProvider extends ChangeNotifier {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';

  final LocationService _locationService = LocationService();
  late GlobalKey<ScaffoldState>? _scaffoldKey;
  late GoogleMapController? _controller;
  late Set<Marker>? _markers;
  late Marker? _remoteMarker;
  late BitmapDescriptor? _selectionPin;
  late BitmapDescriptor? _carPin;
  late Set<Polyline>? _polylines;
  late double? _cost;
  late String? _remoteAddress;
  late String? _deviceAddress;
  late double? _distance;
  late LatLng? _remoteLocation;
  late Position? _deviceLocation;
  late CameraPosition? _cameraPos;
  late StreamSubscription<Position>? _positionStream;
  bool _driverArrivingInit = false;

  GlobalKey<ScaffoldState>? get scaffoldKey => _scaffoldKey;
  CameraPosition? get cameraPos => _cameraPos;
  GoogleMapController? get controller => _controller;
  Set<Marker>? get markers => _markers;
  Marker? get remoteMarker => _remoteMarker!;
  BitmapDescriptor? get selectionPin => _selectionPin;
  BitmapDescriptor? get carPin => _carPin;
  Position? get deviceLocation => _deviceLocation;
  LatLng? get remoteLocation => _remoteLocation;
  String? get remoteAddress => _remoteAddress;
  String? get deviceAddress => _deviceAddress;
  Set<Polyline>? get polylines => _polylines;
  double? get cost => _cost;
  double? get distance => _distance;

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
  bool lookingForDriver = false;
  bool driverFound = false;
  bool driverArrived = false;
  int timeCounter = 0;
  double percentage = 0;
  late Timer periodicTimer;

/*
THIS IS TO SHOW THE WIDGET WHEN THE USER IS FOUND
*/
  Show show = Show.SP_ACCEPTED;

  UserAppProvider() {
    _scaffoldKey = null;
    _deviceLocation = null;
    _remoteLocation = null;
    _remoteAddress = null;
    _deviceAddress = null;
    _cost = null;
    _distance = null;
    _cameraPos = null;
    _markers = {};
    _polylines = {};
    _positionStream = null;
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

  //FUNCTION TO SEND REQUEST
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
        img: user.profileImageUrl);

    //Show UI indicating that a request is being sent
    showWaitingForResponseUI();
    //START TIMER FOR WAITING THE REQUEST...
    startWaitingTimer(user.id!, context);
  }

  void showWaitingForResponseUI() {
    //Update UI to indicate that a request is being sent
    alertsOnUi = true;
    notifyListeners();
  }

  void startWaitingTimer(String requestId, BuildContext context) {
    //Start the timer for waiting
    lookingForDriver = true;
    notifyListeners();

    periodicTimer = Timer.periodic(const Duration(seconds: 1), (time) {
      timeCounter = timeCounter + 1;
      percentage = timeCounter / 100;
      //print("====== GOOOO $timeCounter");

      if (timeCounter == 20) {
        // WHEN THE TIMER RUNS OUT
        timeCounter = 0;
        percentage = 0;
        lookingForDriver = false;

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
    _request.upDateRequest(EXPIRED, requestId!);
    periodicTimer.cancel();
    notifyListeners();
  }


}
