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
import 'package:quickmed/widget/subscription.dart';
import 'package:quickmed/helpers/screen_navigation.dart';



class AmbulanceMapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const AmbulanceMapScreen(this.scaffoldState, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _AmbulanceMapScreenState createState() => _AmbulanceMapScreenState();
}

class _AmbulanceMapScreenState extends State<AmbulanceMapScreen> {
  String statusText = 'Now offline';
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();
  bool isDriverActive = false;

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
                      SizedBox(
                          width: 5), // Add some space between the icon and text
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
                top: 470,
                right: 15,
                child: GestureDetector(
                  onTap: () {
                    changeScreen(context,const Subscription());
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.all(8), // Adjust padding as needed
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius:
                          BorderRadius.circular(20), // Make it circular
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
