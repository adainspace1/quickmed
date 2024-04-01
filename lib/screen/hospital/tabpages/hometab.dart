// ignore: duplicate_ignore
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/provider/hospital/hospital_appstate.dart';
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
  String statusText = 'Now offline';
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();
  bool isDriverActive = false;

  @override
  void initState() {
    super.initState();
    readDriverCurrentInfo();
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
                      onPressed: () {
                        if (isDriverActive != true) {
                          driverIsNowOnline();
                          updateDriverLocationRealTime();
                          setState(() {
                            statusText = "Now online";
                            isDriverActive = true;
                          });
                        } else {
                          driverIsOffline();
                          setState(() {
                            statusText = "Now offline";
                            isDriverActive = false;
                          });
                        }
                      },
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

    readDriverCurrentInfo() async {
    var newuser = firebaseAuth.currentUser;

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference driversCollection = firestore.collection('ambulance');

    DocumentSnapshot snap = await driversCollection.doc(newuser!.uid).get();

    if (snap.exists) {
      Map<String, dynamic>? data = snap.data() as Map<String, dynamic>;

      
        onLineDriver.id = data['id'];
        onLineDriver.name = data['name'];
        driverVehicleType = data['carType'];
      }
    
  }

  driverIsNowOnline() async {
    Position pos = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    driverCurrentPosition = pos;

    Geofire.initialize("activeDrivers");
    Geofire.setLocation(
      currentUser!.uid,
      driverCurrentPosition!.latitude,
      driverCurrentPosition!.longitude,
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference driversCollection = firestore.collection('ambulance');

    await driversCollection.doc(currentUser?.uid).update({
      'new ride status': 'idle',
    });
  }

  updateDriverLocationRealTime() async {
    streamSubscriptionPosition =Geolocator.getPositionStream().listen((Position position) {
      if (isDriverActive == true) {
        Geofire.setLocation(
          currentUser!.uid,
          position.latitude,
          position.longitude,
        );
      }
      //LatLng latLng = LatLng(position.latitude, position.longitude);
    });
  }

  driverIsOffline() async {
    Geofire.removeLocation(currentUser!.uid);

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference driversCollection = firestore.collection('ambulance');

    // Remove the 'new ride status' field
    await driversCollection.doc(currentUser!.uid).update({
      'new ride status': FieldValue.delete(),
    });

    // ...
  }
}
