// ignore_for_file: prefer_final_fields, unused_field, constant_identifier_names

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/service/ambulance/ambulance_service.dart';
import 'package:quickmed/service/map_request.dart';
import 'package:quickmed/service/ride_request.dart';

//enum Show {}

class AmbulanceAppProvider extends ChangeNotifier {
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

  GoogleMapServices _googleMapServices = GoogleMapServices();
  GoogleMapController? _mapController;

  LatLng? _center;
  LatLng? _lastPosition;

  // TextEditingController pickupLocationControlelr = TextEditingController();
  TextEditingController destinationController = TextEditingController();
  //  Position position;

  RideRequest _requestServices = RideRequest();

  AmbulanceDatabaseService _ambulanceDatabaseService = AmbulanceDatabaseService();
  AmbulanceDatabaseService get ambulanceservice => _ambulanceDatabaseService;

  BitmapDescriptor? _carPin;
  BitmapDescriptor? get carpin => _carPin;

  DriverModel? _user;
  DriverModel? get getUser => _user;
  // //   location pin
  BitmapDescriptor? _locationPin;

  LatLng? get center => _center;

  BitmapDescriptor? get locationPin => _locationPin;

  LatLng? get lastPosition => _lastPosition;

  Set<Marker> get markers => _markers;

  // Set<Polyline> get poly => _poly;

  GoogleMapController? get mapController => _mapController;

  AmbulanceAppProvider() {
    _setCustomMapPin();
    _getUserLocation();
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

    Position position = await Geolocator.getCurrentPosition();
    _ambulanceDatabaseService.updateLocation(
        position.latitude, position.longitude);

    _center = LatLng(position.latitude, position.longitude);
    addMarker(_center!);
    notifyListeners();
    return position;
  }

  //FUNCTION TO GET THE USER FROM THE FIRESTORE DATABASE...
  Future<void> refreshUser() async {
    DriverModel user = await _ambulanceDatabaseService.getUserByUid();
    _user = user;
    notifyListeners();
  }

  //create the map
  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  // add the markers of the current location
  addMarker(LatLng position) {
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
        const ImageConfiguration(devicePixelRatio: 2.5), 'images/taxi.png');
  }
}
