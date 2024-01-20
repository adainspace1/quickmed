// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/util/constant.dart';

class CurrentLocationScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const CurrentLocationScreen(this.scaffoldState, {super.key});

  @override
  _CurrentLocationScreenState createState() => _CurrentLocationScreenState();
}

class _CurrentLocationScreenState extends State<CurrentLocationScreen> {
  late GoogleMapController googleMapController;

  static const CameraPosition initialCameraPosition =CameraPosition(target: LatLng(9.0537984, 7.4612736), zoom: 14);

  Set<Marker> markers = {};

  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            initialCameraPosition: initialCameraPosition,
            markers: markers,
            zoomControlsEnabled: false,
            myLocationEnabled: true,
            mapType: MapType.normal,
            onMapCreated: (GoogleMapController controller) {
              googleMapController = controller;
            },
          ),
          Positioned(
            top: 40,
            left: 15,
            child: CircleAvatar(
              backgroundColor:
                  COLOR_ACCENT, // Set your desired background color
              radius: 20, // Set the desired radius
              child: IconButton(
                alignment: Alignment.center,
              
                icon: Icon(
                  Icons.menu,
                  
                  color: Colors.white, // Set the desired icon color
                  size: 20,
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
      ),
    );
  }

  Future<void> _getUserLocation() async {
    Position position = await _determinePosition();

    googleMapController.animateCamera(CameraUpdate.newCameraPosition(
        CameraPosition(
            target: LatLng(position.latitude, position.longitude), zoom: 14)));

    markers.clear();
    markers.add(Marker(
        markerId: const MarkerId('currentLocation'),
        position: LatLng(position.latitude, position.longitude)));

    setState(() {});
  }

//determing the current position
  Future<Position> _determinePosition() async {
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

    return position;
  }
}
