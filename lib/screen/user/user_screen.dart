// ignore_for_file: unused_field, non_constant_identifier_names, prefer_final_fields, use_build_context_synchronously, prefer_interpolation_to_compose_strings, avoid_print

import 'dart:async';
import 'package:geocoder2/geocoder2.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart' as loc;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/Assitance/assitant_method.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/global/map_key.dart';
import 'package:quickmed/provider/app_info.dart';
import 'package:quickmed/widget/searchplace_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  LatLng? pickLocation;
  loc.Location location = loc.Location();
  String? _address;

  final Completer<GoogleMapController> _controllerGoogleMap =
      Completer<GoogleMapController>();
  GoogleMapController? newGoogleController;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(9.0537984, 7.4612736),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> _ScaffoldState = GlobalKey<ScaffoldState>();

  double searchLocationHeight = 220;
  double waitingResponseFromDriverContainerHeight = 0;
  double assignedDriverInfoContainerHeight = 0;

  Position? currentUserPosition;
  var geolocator = Geolocator();

  LocationPermission? _locationPermission;
  double bottomPadingOfMap = 0;

  List<LatLng> pLineCoordinateList = [];

  Set<Polyline> polylineSet = {};
  Set<Marker> markersSet = {};
  Set<Circle> circlesSet = {};

  String userName = "";
  String userEmail = "";

  bool openNavigationDrawer = true;
  bool activeNearByDriverKeyLoaded = false;

  BitmapDescriptor? activeNearByIcon;

  locateUserPosition() async {
    Position cPosition = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    currentUserPosition = cPosition;
    LatLng latLngPosition =
        LatLng(currentUserPosition!.latitude, currentUserPosition!.longitude);
    CameraPosition cameraPosition =
        CameraPosition(target: latLngPosition, zoom: 14);

    newGoogleController!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String humanReadableAddress =
        await AsssitantMethod.searchAddressForGeographicsCoordinate(
            currentUserPosition!, context);
    print("this is our addresss" + humanReadableAddress);

    userName = userModelCurrentInfo!.name!;
    userEmail = userModelCurrentInfo!.email!;

    // initializeGeoFireListener();
    // AsssitantMethod.readTripsKeyForOnlineUser(context);
  }

  getAddressFromLatLng() async {
    try {
      GeoData data = await Geocoder2.getDataFromCoordinates(
          latitude: pickLocation!.latitude,
          longitude: pickLocation!.longitude,
          googleMapApiKey: mapKey);

      setState(() {
        //   Directions userPickUpAddress = Directions();
        // userPickUpAddress.locationlatitude = pickLocation!.latitude;
        // userPickUpAddress.locationlongitude = pickLocation!.longitude;

        // userPickUpAddress.locationName = data.address;
        _address = data.address;
      });
    } catch (e) {
      // print(e);
    }
  }

  checkIfLocationPermissionIsAllowed() async {
    _locationPermission = await Geolocator.requestPermission();

    if (_locationPermission == LocationPermission.denied) {
      _locationPermission = await Geolocator.requestPermission();
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfLocationPermissionIsAllowed();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Stack(
          children: [
            GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              initialCameraPosition: _kGooglePlex,
              polylines: polylineSet,
              markers: markersSet,
              circles: circlesSet,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleController = controller;

                setState(() {});
                locateUserPosition();
              },
              onCameraMove: (CameraPosition? position) {
                if (pickLocation != position!.target) {
                  setState(() {
                    pickLocation = position.target;
                  });
                }
              },
              onCameraIdle: () {
                getAddressFromLatLng();
              },
            ),
            Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 35.0),
                child: Image.network(
                  "https://res.cloudinary.com/damufjozr/image/upload/v1703326116/imgbin_computer-icons-avatar-user-login-png_t9t5b9.png",
                  width: 45,
                  height: 45,
                ),
              ),
            ),

            // ui for searhing location
            Positioned(
                bottom: 0,
                right: 40,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 50, 20, 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(20),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.location_on_outlined,
                                          color: Colors.blue,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const Text(
                                              "from",
                                              style: TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(
                                              Provider.of<AppInfo>(context)
                                                          .userPickUpLocation !=
                                                      null
                                                  ? (Provider.of<AppInfo>(
                                                                  context)
                                                              .userPickUpLocation!
                                                              .locationName!)
                                                          .substring(0, 24) +
                                                      "..."
                                                  : "not getting Address",
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.grey),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const Divider(
                                    height: 1,
                                    thickness: 2,
                                    color: Colors.amber,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: GestureDetector(
                                      onTap: () async {
                                        var responseFromSearchScreen =
                                            await Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        const SearchPlaceScreen()));

                                        if (responseFromSearchScreen ==
                                            "obtainDropOff") {
                                          setState(() {
                                            openNavigationDrawer = false;
                                          });
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.location_on_outlined,
                                            color: Colors.blue,
                                          ),
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                "To",
                                                style: TextStyle(
                                                    color: Colors.blue,
                                                    fontSize: 12,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(
                                                Provider.of<AppInfo>(context)
                                                            .userDropOffLocation !=
                                                        null
                                                    ? (Provider.of<AppInfo>(
                                                                    context)
                                                                .userDropOffLocation!
                                                                .locationName!)
                                                            .substring(0, 24) +
                                                        "..."
                                                    : "not getting Address",
                                                style: const TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.grey),
                                              )
                                            ],
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ))
            // Positioned(
            //     top: 40,
            //     right: 20,
            //     left: 20,
            //     child: Container(
            //       decoration: BoxDecoration(
            //           border: Border.all(color: Colors.black),
            //           color: Colors.white),
            //       padding: EdgeInsets.all(20),
            //       child: Text(
            //         Provider.of<AppInfo>(context).userPickUpLocation != null
            //         ?(Provider.of<AppInfo>(context).userPickUpLocation!.locationName!).substring(0,24) + "............."
            //         : "not getting Address",
            //         overflow: TextOverflow.visible,
            //         softWrap: true,
            //       ),
            //     ))
          ],
        ),
      ),
    );
  }
}
