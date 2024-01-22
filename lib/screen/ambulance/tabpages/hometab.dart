// ignore: duplicate_ignore
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/provider/ambulance/ambulance_appstate.dart';
import 'package:quickmed/provider/ambulance/ambulance_user_provider.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/loading.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart' as model;

class AmbulanceMapScreen extends StatefulWidget {

    final GlobalKey<ScaffoldState> scaffoldState;

   const AmbulanceMapScreen(this.scaffoldState, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AmbulanceMapScreenState createState() => _AmbulanceMapScreenState();
}

class _AmbulanceMapScreenState extends State<AmbulanceMapScreen> {
  String? statusText = '';
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AmbulanceAppProvider appState = Provider.of<AmbulanceAppProvider>(context);
    model.DriverModel? user = Provider.of<AmbulanceProvider>(context).getUser;

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
        
            Positioned(
            top: 40,
            left: 15,
            child: CircleAvatar(
              backgroundColor:
                  COLOR_ACCENT, 
              radius: 20, 
              child: IconButton(
                alignment: Alignment.center,
              
                icon: CircleAvatar(
                  radius: 10,
                  backgroundImage: NetworkImage(user.profileImageUrl ?? ""),
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