// ignore_for_file: prefer_final_fields, unused_field, constant_identifier_names

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';
import 'package:quickmed/model/ride_request.dart';
import 'package:quickmed/model/route/route_model.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/econsultant/getEcon_service.dart';
import 'package:quickmed/service/map_request.dart';
import 'package:quickmed/service/ride_request.dart';
import 'package:quickmed/service/user/user_service.dart';

enum Show {
  SP_FOUND,
}

class UserAppProvider extends ChangeNotifier {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';
  static const PICKUP_MARKER_ID = 'pickup';
  static const LOCATION_MARKER_ID = 'location';
  static const DRIVER_AT_LOCATION_NOTIFICATION = 'DRIVER_AT_LOCATION';
  static const REQUEST_ACCEPTED_NOTIFICATION = 'REQUEST_ACCEPTED';
  static const TRIP_STARTED_NOTIFICATION = 'TRIP_STARTED';

  Set<Marker> _markers = {};
  //  this polys will be displayed on the map
  // Set<Polyline> _poly = {};
  // // this polys temporarely store the polys to destination
  // Set<Polyline> _routeToDestinationPolys = {};
  // // this polys temporarely store the polys to driver
  // Set<Polyline> _routeToDriverpoly = {};

  GoogleMapServices _googleMapServices = GoogleMapServices();
  GoogleMapController? _mapController;

  LatLng? _center;
  LatLng? _lastPosition;

  TextEditingController pickupLocationControlelr = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  //  Position position;

  RideRequest _requestServices = RideRequest();
  UserDataBaseServices _userServices = UserDataBaseServices();

  UserDataBaseServices get userServices => _userServices;

  BitmapDescriptor? _carPin;
  BitmapDescriptor? get carpin => _carPin;

  EconsultantModel? driverModel;
  RouteModel? routeModel;
  UserModel? _userModel;
  // //   location pin
  BitmapDescriptor? _locationPin;

  LatLng? get center => _center;

  BitmapDescriptor? get locationPin => _locationPin;

  LatLng? get lastPosition => _lastPosition;

  Set<Marker> get markers => _markers;
  DriverService? _driverService = DriverService();

  // Set<Polyline> get poly => _poly;

  GoogleMapController? get mapController => _mapController;
  //  RouteModel routeModel;

  //  draggable to show
  Show show = Show.SP_FOUND;

  // //  Driver request related variables
  bool lookingForDriver = false;
  bool alertsOnUi = false;
  bool driverFound = false;
  bool driverArrived = false;
  int timeCounter = 0;
  double percentage = 0;
  Timer? periodicTimer;
  String? requestedDestination;

  String requestStatus = "";
  double? requestedDestinationLat;

  double? requestedDestinationLng;
  RideRequestModel? rideRequestModel;
  BuildContext? mainContext;

//   //  this variable will listen to the status of the ride request
  StreamSubscription<QuerySnapshot>? requestStream;
//   // this variable will keep track of the drivers position before and during the ride
  StreamSubscription<QuerySnapshot>? driverStream;
// //  this stream is for all the driver on the app
  StreamSubscription<List<EconsultantModel>>? allDriversStream;

  //DriverModel driverModel;
  LatLng? pickupCoordinates;
  LatLng? destinationCoordinates;
  double ridePrice = 0;
  // String notificationType = "";

  UserAppProvider() {
    _setCustomMapPin();
    _getUserLocation();
    _listemToDrivers();
  }

  //gets the current location
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

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    _center = LatLng(position.latitude, position.longitude);
    addMarker(_center!);
    notifyListeners();
    return position;
  }

  //create the map
  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  // ignore: unused_element
  void _addDriverMarker(LatLng position) {
    _markers.add(Marker(
        markerId: const MarkerId('driver'),
        position: position,
        anchor: const Offset(0, 0.85),
        icon: carpin!
        // Add other marker properties if needed
        ));
    notifyListeners();
  }

  // add the markers of the current location
  addMarker(
    LatLng position,
  ) {
    _markers.add(
      Marker(
          markerId: const MarkerId(LOCATION_MARKER_ID),
          position: position,
          anchor: const Offset(0, 0.85),
          icon: locationPin!
          // Add other marker properties if needed
          ),
    );
    notifyListeners();
  }

  //this is to set a custom marker
  _setCustomMapPin() async {
    _locationPin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'images/pin.png');
  }

  // this function listen to all the drivers available
  _listemToDrivers() {
    allDriversStream = _driverService?.getDrivers().listen(_updateMarkers);
    show = Show.SP_FOUND;
    notifyListeners();
  }

  _updateMarkers(List<EconsultantModel> drivers) {
    // Extract the names of the drivers
    //List<String?> driverNames = drivers.map((driver) => driver.name).toList();

    //Print the driver names
    //print('Driver Names: $driverNames');
  }

  Future sendRequest({LatLng? origin, LatLng? destination}) async {
    LatLng org;
    LatLng dest;
    if (origin == null && destination == null) {
      org = pickupCoordinates!;
      dest = destinationCoordinates!;
    } else {
      org = origin!;
      dest = destination!;
    }

    RouteModel route =
        await _googleMapServices.getRouteByCoordinate(org, dest);
    routeModel = route;

    if (origin == null) {
      ridePrice =
          double.parse((routeModel!.distance.value / 500).toStringAsFixed(2));
    }

    List<Marker> mks = _markers
        .where((element) => element.markerId.value == "location")
        .toList();

    if (mks.isNotEmpty) {
      _markers.remove(mks[0]);
    }

    addMarker(destinationCoordinates!);
    _center = destinationCoordinates;
  }
}
