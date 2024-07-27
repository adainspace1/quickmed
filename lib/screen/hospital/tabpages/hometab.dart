// ignore: duplicate_ignore
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/provider/hospital/hospital_appstate.dart';
import 'package:quickmed/service/hospital/hospital.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/loading.dart';

class HospitalMapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const HospitalMapScreen(this.scaffoldState, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _HospitalMapScreenState createState() => _HospitalMapScreenState();
}

class _HospitalMapScreenState extends State<HospitalMapScreen> {
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();
  String statusText = 'Now offline';
  bool isHospitalActive = false;
  Position? currentPositionOfHospital;

  Color colorToShow = Colors.green;
  String titleToShow = "GO ONLINE NOW";
  bool isDriverAvailable = false;
  GoogleMapController? controllerGoogleMap;
  DatabaseReference? newHpRequestReference;

// TO ENABLE USER TO SEND RIDE REQUESTS
  goOnlineNow() async {
    Position pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    hospitalCurrentPosition = pos;

    Geofire.initialize("onlineHospitals");
    Geofire.setLocation(
      FirebaseAuth.instance.currentUser!.uid,
      hospitalCurrentPosition!.latitude,
      hospitalCurrentPosition!.longitude,
    );

    newHpRequestReference = FirebaseDatabase.instance
        .ref()
        .child("hospital")
        .child(FirebaseAuth.instance.currentUser!.uid)
        .child("newTripStatus");
    newHpRequestReference!.set("waiting");

    newHpRequestReference!.onValue.listen((event) {});
  }

  //TO GO OFFLINE DISABLE REQUESTS
  goOfflineNow() {
    //stop sharing driver live location updates
    Geofire.removeLocation(FirebaseAuth.instance.currentUser!.uid);

    //stop listening to the newTripStatus
    newHpRequestReference!.onDisconnect();
    newHpRequestReference!.remove();
    newHpRequestReference = null;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    HospitalAppProvider appState = Provider.of<HospitalAppProvider>(context);

    // ignore: unnecessary_null_comparison
    return appState.center == null
        ? const Loading()
        : Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: appState.center!, zoom: 15),
                onMapCreated: appState.onCreate,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                markers: appState.markers,
              ),
              statusText != "Now online"
                  ? Container(
                      height: MediaQuery.of(context).size.height,
                      width: double.infinity,
                      color: Colors.black87,
                    )
                  : Container(),

              //button for driver
              Positioned(
                top: statusText != "Now online"
                    ? MediaQuery.of(context).size.height * 0.45
                    : 40,
                left: 0,
                right: 0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: statusText == "Now offline"
                          ? Text(statusText)
                          : const Icon(Icons.phonelink_ring_sharp),
                    )
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
            ],
          );
  }
}
