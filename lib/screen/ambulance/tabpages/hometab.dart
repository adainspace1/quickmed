// ignore: duplicate_ignore
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, prefer_final_fields, use_build_context_synchronously, unused_local_variable
import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/provider/ambulance/ambulance_appstate.dart';
import 'package:quickmed/push_notification/push_notification.dart';
import 'package:quickmed/service/ambulance/ambulance_service.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/subscription.dart';

class AmbulanceMapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const AmbulanceMapScreen(this.scaffoldState, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AmbulanceMapScreenState createState() => _AmbulanceMapScreenState();
}

class _AmbulanceMapScreenState extends State<AmbulanceMapScreen> {
  final Completer<GoogleMapController> googleMapCompleterController =
      Completer<GoogleMapController>();

  String statusText = 'Now offline';
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();
  bool isDriverActive = false;
  Position? currentPositionOfDriver;

  Color colorToShow = Colors.green;
  String titleToShow = "GO ONLINE NOW";
  bool isDriverAvailable = false;
  DatabaseReference? newTripRequestReference;
  GoogleMapController? controllerGoogleMap;
  AmbulanceDatabaseService _service = AmbulanceDatabaseService();

  @override
  void initState() {
    super.initState();
    retrieveCurrentDriverInfo();
  }

  getCurrentLiveLocationOfDriver() async {
    Position positionOfUser = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.bestForNavigation);
    currentPositionOfDriver = positionOfUser;
    driverCurrentPosition = currentPositionOfDriver;

    LatLng positionOfUserInLatLng = LatLng(
        currentPositionOfDriver!.latitude, currentPositionOfDriver!.longitude);

    CameraPosition cameraPosition =
        CameraPosition(target: positionOfUserInLatLng, zoom: 15);
    controllerGoogleMap!
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  // TO ENABLE USER TO SEND RIDE REQUESTS
  goOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = pos;

    Geofire.initialize("onlineDrivers");
    Geofire.setLocation(
      FirebaseAuth.instance.currentUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    newTripRequestReference = FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("newTripStatus");
    newTripRequestReference!.set("waiting");

    newTripRequestReference!.onValue.listen((event) {});

    _service.updateActiveStatus(true);
  }

  //TO GO OFFLINE DISABLE REQUESTS
  goOfflineNow() {
    //stop sharing driver live location updates
    Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);

    //stop listening to the newTripStatus
    newTripRequestReference!.onDisconnect();
    newTripRequestReference!.remove();
    newTripRequestReference = null;
  }

  setAndGetLocationUpdates() {
    positionStreamHomePage =
        Geolocator.getPositionStream().listen((Position position) {
      currentPositionOfDriver = position;

      if (isDriverAvailable == true) {
        Geofire.setLocation(
          FirebaseAuth.instance.currentUser!.uid,
          currentPositionOfDriver!.latitude,
          currentPositionOfDriver!.longitude,
        );
      }

      LatLng positionLatLng = LatLng(position.latitude, position.longitude);
      controllerGoogleMap!
          .animateCamera(CameraUpdate.newLatLng(positionLatLng));
    });
  }

  initializePushNotificationSystem() {
    PushNotificationSystem notificationSystem = PushNotificationSystem();
    notificationSystem.generateDeviceRegistrationToken();
    notificationSystem.startListeningForNewNotification(context);
  }

  retrieveCurrentDriverInfo() async {
    await FirebaseDatabase.instance
        .ref()
        .child("drivers")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .once()
        .then((snap) {
      driverName = (snap.snapshot.value as Map)["name"];
      driverPhone = (snap.snapshot.value as Map)["phone"];
      driverPhoto = (snap.snapshot.value as Map)["photo"];
      carColor = (snap.snapshot.value as Map)["car_details"]["carType"];
      carModel = (snap.snapshot.value as Map)["car_details"]["color"];
      carNumber = (snap.snapshot.value as Map)["car_details"]["plateNumber"];

      // print("dRIVERnAME:$driverName");
      // print("driverphoto:$driverPhone");
      // print(driverPhoto);
      // print(carColor);
      // print(carModel);
      // print(carNumber);

      initializePushNotificationSystem();
    });

    // DatabaseReference usersRef = FirebaseDatabase.instance
    //     .ref()
    //     .child("drivers")
    //     .child(FirebaseAuth.instance.currentUser!.uid);

    // await usersRef.once().then((snap) {
    //   if (snap.snapshot.value != null) {
    //     setState(() {
    //       driverName = (snap.snapshot.value as Map)["name"];
    //       driverPhone = (snap.snapshot.value as Map)["phone"];
    //       driverPhoto = (snap.snapshot.value as Map)["profileImageUrl"];
    //       carColor = (snap.snapshot.value as Map)["carType"];
    //       carModel = (snap.snapshot.value as Map)["color"];
    //       carNumber = (snap.snapshot.value as Map)["plateNumber"];

    //       print("drivername:$driverName");
    //       print("driverphoto:$driverPhone");
    //       print("Driverphoto$driverPhoto");
    //       print(carColor);
    //       print(carModel);
    //       print(carNumber);

    //       initializePushNotificationSystem();

    //       //add user photo
    //     });
    //   } else {}
    // });
  }

  @override
  Widget build(BuildContext context) {
    AmbulanceAppProvider appState = Provider.of<AmbulanceAppProvider>(context);

    // ignore: unnecessary_null_comparison
    return Stack(
      children: <Widget>[
        GoogleMap(
          padding: const EdgeInsets.only(top: 136),
          mapType: MapType.normal,
          myLocationEnabled: true,
          initialCameraPosition: googlePlexInitialPosition,
          onMapCreated: (GoogleMapController mapController) {
            controllerGoogleMap = mapController;
            googleMapCompleterController.complete(controllerGoogleMap);

            getCurrentLiveLocationOfDriver();
          },
        ),
        //go online for driver
        Positioned(
          top: 61,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                      context: context,
                      isDismissible: false,
                      builder: (BuildContext context) {
                        return Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey,
                                blurRadius: 5.0,
                                spreadRadius: 0.5,
                                offset: Offset(
                                  0.7,
                                  0.7,
                                ),
                              ),
                            ],
                          ),
                          height: 221,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 24, vertical: 18),
                            child: Column(
                              children: [
                                const SizedBox(
                                  height: 11,
                                ),
                                Text(
                                  (!isDriverAvailable)
                                      ? "GO ONLINE NOW"
                                      : "GO OFFLINE NOW",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontSize: 22,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  height: 21,
                                ),
                                Text(
                                  (!isDriverAvailable)
                                      ? "You are about to go online, you will become available to receive trip requests from users."
                                      : "You are about to go offline, you will stop receiving new trip requests from users.",
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 25,
                                ),
                                Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.red),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text(
                                          "BACK",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 16,
                                    ),
                                    Expanded(
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (!isDriverAvailable) {
                                            //go online
                                            goOnlineNow();

                                            //get driver location updates
                                            setAndGetLocationUpdates();

                                            Navigator.pop(context);

                                            setState(() {
                                              colorToShow = Colors.redAccent;
                                              titleToShow = "GO OFFLINE NOW";
                                              isDriverAvailable = true;
                                            });
                                          } else {
                                            //go offline
                                            goOfflineNow();

                                            Navigator.pop(context);

                                            setState(() {
                                              colorToShow = Colors.green;
                                              titleToShow = "GO ONLINE NOW";
                                              isDriverAvailable = false;
                                            });
                                          }
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              (titleToShow == "GO ONLINE NOW")
                                                  ? Colors.green
                                                  : Colors.green,
                                        ),
                                        child: const Text("CONFIRM",
                                            style:
                                                TextStyle(color: Colors.white)),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorToShow,
                ),
                child: Text(titleToShow,
                    style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
        ),
        Positioned(
          top: 40,
          left: 15,
          child: CircleAvatar(
            backgroundColor: COLOR_ACCENT,
            radius: 20,
            child: IconButton(
              alignment: Alignment.center,
              icon: const Icon(
                Icons.menu,
                color: COLOR_BACKGROUND,
              ),
              onPressed: () {
                if (widget.scaffoldState.currentState != null) {
                  widget.scaffoldState.currentState!.openDrawer();
                }
              },
            ),
          ),
        ),
        Positioned(
          top: 25,
          right: 15,
          child: Container(
            padding: const EdgeInsets.all(8), // Adjust padding as needed
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(20), // Make it circular
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.verified,
                  color: Colors.white,
                  size: 20,
                ),
                SizedBox(width: 5), // Add some space between the icon and text
                Text(
                  'Not Verified',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),

        Positioned(
          top: 620,
          right: 15,
          child: GestureDetector(
            onTap: () {
              changeScreen(context, const Subscription());
            },
            child: Container(
              padding: const EdgeInsets.all(8), // Adjust padding as needed
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(20), // Make it circular
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.verified,
                    color: Colors.white,
                    size: 20,
                  ),
                  SizedBox(
                      width: 5), // Add some space between the icon and text
                  Text(
                    'Go Premium',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
