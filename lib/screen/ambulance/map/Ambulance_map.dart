// ignore: duplicate_ignore
// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/provider/ambulance/ambulance_appstate.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/loading.dart';

class AmbulanceMapScreen extends StatefulWidget {

    final GlobalKey<ScaffoldState> scaffoldState;

   const AmbulanceMapScreen(this.scaffoldState, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AmbulanceMapScreenState createState() => _AmbulanceMapScreenState();
}

class _AmbulanceMapScreenState extends State<AmbulanceMapScreen> {
  TextEditingController destinationController = TextEditingController();
  Color darkBlue = Colors.black;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AmbulanceAppProvider appState = Provider.of<AmbulanceAppProvider>(context);

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
                  COLOR_ACCENT, // Set your desired background color
              radius: 20, // Set the desired radius
              child: IconButton(
                alignment: Alignment.center,
              
                icon: const Icon(
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
          );
  }

 
}