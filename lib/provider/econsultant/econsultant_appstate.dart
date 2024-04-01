// ignore_for_file: prefer_final_fields, unused_field, constant_identifier_names, avoid_function_literals_in_foreach_calls

import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/econsultant/econ_service.dart';
import 'package:quickmed/service/map_request.dart';
import 'package:quickmed/service/ride_request.dart';
import 'package:quickmed/widget/stars.dart';

enum Show { SP_Found, SP_Expired }

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
  Show show = Show.SP_Found;

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

  EconsultantModel? _user;
  EconsultantModel? get getUser => _user;

  // BOOLEAN VARIABLE TO IN INITIALIZED FRO LATER USAGE....
  bool lookingForDriver = false;
  bool alertsOnUi = false;
  EconsultantModel? econsultantModel;
  Timer? periodicTimer;

  //GOOGLE MAP CONTROLLER
  GoogleMapController? get mapController => _mapController;
  late StreamSubscription<QuerySnapshot> requestStream;
  late StreamSubscription<List<EconsultantModel>> allDriversStream;

  //THIS IS THE ECONSULTANT APPSTATE THAT WOULD RUN AT THE START OF THE APP..
  EconsultantAppProvider() {
    _setCustomMapPin();
    _getUserLocation();
    listenToRequest();
  }

  //FUNCTION TO GET THE USER FROM THE FIRESTORE DATABASE...
  Future<void> refreshUser() async {
    EconsultantModel user = await _econsultantServices.getUserByUid();
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
    _econsultantServices.updateLocation(position.latitude, position.longitude);

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
          case CANCELLED:
            break;

          case ACCEPTED:
            break;

          case EXPIRED:
            show = Show.SP_Expired;
            break;

          case PENDING:
            show = Show.SP_Found;
            notifyListeners();
            break;

          default:
        }
      });
    });
  }

  acceptRequest({String? requestId, String? spId}) {
    _request.upDateRequest(ACCEPTED, requestId!);
    notifyListeners();
  }

  cancelRequest(String? id) {
    lookingForDriver = false;
    _request.upDateRequest(CANCELLED, id!);
    notifyListeners();
  }

  listenToEconsultant() {
    allDriversStream = _econsultantServices.econsultantStream().listen((event) {
      event.docChanges.forEach((change) async {
        Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;

        if (data['id'] == econsultantModel!.id) {
          notifyListeners();

          show = Show.SP_Found;
        }
      });
    }) as StreamSubscription<List<EconsultantModel>>;
  }

  // show the avalable service providers
  showSpBottomSheet(BuildContext context) {
    if (alertsOnUi) Navigator.pop(context);

    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SizedBox(
              height: 400,
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "7 MIN AWAY",
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: econsultantModel!.profileImage == null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.5),
                              borderRadius: BorderRadius.circular(40)),
                          child: const CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 45,
                            child: Icon(
                              Icons.person,
                              size: 65,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Visibility(
                        visible: econsultantModel!.profileImage != null,
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.deepOrange,
                              borderRadius: BorderRadius.circular(40)),
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                NetworkImage(econsultantModel!.profileImage!),
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(econsultantModel!.name ?? "Nada"),
                    ],
                  ),
                  const SizedBox(height: 10),
                  _stars(
                      rating: econsultantModel!.rating,
                      votes: econsultantModel!.vote),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        onPressed: () {},
                        child: const Text("call"),
                      )
                    ],
                  )
                ],
              ));
        });
  }

  _stars({int? votes, int? rating}) {
    if (votes == 0) {
      return const StarsWidget(
        numberOfStars: 0,
      );
    } else {
      double finalRate = rating! / votes!;
      return StarsWidget(
        numberOfStars: finalRate.floor(),
      );
    }
  }
}
