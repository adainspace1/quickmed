import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/provider/econsultant/econsultant_appstate.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/subscription.dart';
import 'package:quickmed/widget/loading.dart';


class EconsultantMapScreen extends StatefulWidget {
  final GlobalKey<ScaffoldState> scaffoldState;

  const EconsultantMapScreen(this.scaffoldState, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _EconsultantMapScreenState createState() => _EconsultantMapScreenState();
}

class _EconsultantMapScreenState extends State<EconsultantMapScreen> {
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    EconsultantAppProvider appState =
        Provider.of<EconsultantAppProvider>(context);
    // ignore: unnecessary_null_comparison
    return appState.center == null
        ? const Loading()
        :  Stack(
            children: <Widget>[
              GoogleMap(
                initialCameraPosition:
                    CameraPosition(target: appState.center!, zoom: 15),
                onMapCreated: appState.onCreate,
                myLocationEnabled: true,
                mapType: MapType.normal,
                compassEnabled: true,
                rotateGesturesEnabled: true,
                onCameraMove: appState.onCameraMove,
                markers: appState.markers,
              ),

              //for the circular avatar
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
                      color: Colors.white,
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
              // for the verification barge............
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
                            width:
                                5), // Add some space between the icon and text
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
