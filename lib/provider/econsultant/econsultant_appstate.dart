// ignore_for_file: prefer_final_fields, unused_field, constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/econsultant/econ_service.dart';
import 'package:quickmed/service/map_request.dart';
import 'package:quickmed/service/ride_request.dart';

enum Show { User_Found, User_Loading, Show_User, Request_Cancelled }

class EconsultantAppProvider extends ChangeNotifier {
  static const ACCEPTED = 'accepted';
  static const CANCELLED = 'cancelled';
  static const PENDING = 'pending';
  static const EXPIRED = 'expired';
  static const LOCATION_MARKER_ID = 'location';

  Set<Marker> _markers = {};

  GoogleMapServices _googleMapServices = GoogleMapServices();
  GoogleMapController? _mapController;

  LatLng? _center;
  LatLng? _lastPosition;

  //draggable to show
  Show show = Show.User_Found;

  //LOCATION PIIN
  BitmapDescriptor? _locationPin;

  LatLng? get center => _center;

  //THIS GETS THE USER MODEL...
  late UserModel userModel;

  // THIS IS FOR THE ECONSULTANT SERVICES
  EconsultantServices _econsultantServices = EconsultantServices();

  BitmapDescriptor? get locationPin => _locationPin;

  LatLng? get lastPosition => _lastPosition;

  Set<Marker> get markers => _markers;

  // RIDEREQUEST SERVICE
  RideRequest _request = RideRequest();

  // BOOLEAN VARIABLE TO IN INITIALIZED FRO LATER USAGE....
  bool lookingForDriver = false;
  bool alertsOnUi = false;

  //GOOGLE MAP CONTROLLER
  GoogleMapController? get mapController => _mapController;
  late StreamSubscription<QuerySnapshot> requestStream;

  //THIS IS THE ECONSULTANT APPSTATE THAT WOULD RUN AT THE START OF THE APP..
  EconsultantAppProvider() {
    _setCustomMapPin();
    _getUserLocation();
    listenToRequest();
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

    _center = LatLng(position.latitude, position.longitude);

    addMarker(_center!);
    notifyListeners();
    return position;
  }

  //CREATE THE MAP
  onCreate(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  onCameraMove(CameraPosition position) {
    _lastPosition = position.target;
    notifyListeners();
  }

  //ADD MARKER TO THE CURRENT USER LOCATION...
  addMarker(LatLng position) {
    _markers.add(
      Marker(
          markerId: const MarkerId(LOCATION_MARKER_ID),
          position: position,
          anchor: const Offset(0, 0.85),
          icon: locationPin!),
    );
    notifyListeners();
  }

  //THIS FUNCTION SETS A CUSTOM MARKERS AT THE USER LOCATION....
  _setCustomMapPin() async {
    _locationPin = await BitmapDescriptor.fromAssetImage(
        const ImageConfiguration(devicePixelRatio: 2.5), 'images/pin.png');
  }

  // THIS FUNCTION LISTEN TO THE CURRENT REQUEST OF THE USER..
  listenToRequest({String? id, BuildContext? context}) async {
    requestStream = _request.requestStream()!.listen((querySnapshot) {
      querySnapshot.docChanges.forEach((element) async {
        Map<String, dynamic> data = element.doc.data() as Map<String, dynamic>;
        switch (data['Status']) {
          case PENDING:
            //loading
            show = Show.User_Loading;
            notifyListeners();
            break;

          case EXPIRED:
            show = Show.Show_User;
            notifyListeners();
            break;

          case ACCEPTED:
            break;

          case CANCELLED:
            show == Show.Request_Cancelled;
            cancelRequest(data['id']);
            notifyListeners();
            break;

          default:
        }
      });
    });
  }

  cancelRequest(String id) {
    lookingForDriver = false;
    _request.upDateRequest(CANCELLED, id);
  }

  //ACCCEPT REQUEST
  acceptRequest() async {
    _request.addRooms();
  }
}
