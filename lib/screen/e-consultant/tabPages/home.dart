import 'package:flutter/material.dart';
import 'package:flutter_geofire/flutter_geofire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/provider/econsultant/econsultant_appstate.dart';
import 'package:quickmed/service/econsultant/econ_service.dart';
import 'package:quickmed/util/constant.dart';
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
  String statusText = 'Now offline';
  bool isEconsultantActive = false;

  @override
  void initState() {
    super.initState();
  }

  //this funtion set the online status of the econsultant
  econIsNowOnline() async {
    Geofire.initialize("activeDrivers");

    EconsultantServices services = EconsultantServices();
    services.updateActiveStatus(true);
  }

  //read econsultant current location
  

  //this makes the econsultant go offline
  econIsOffline() {
    EconsultantServices services = EconsultantServices();
    services.updateActiveStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    EconsultantAppProvider appState =
        Provider.of<EconsultantAppProvider>(context);
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
                onCameraMove: appState.onCameraMove,
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
                        if (isEconsultantActive != true) {
                          econIsNowOnline();
                          setState(() {
                            statusText = "Now online";
                            isEconsultantActive = true;
                          });
                        } else {
                          econIsOffline();
                          setState(() {
                            statusText = "Now offline";
                            isEconsultantActive = false;
                          });
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue),
                      child: statusText == "Now offline"
                          ? Text(
                              statusText,
                              style: const TextStyle(color: COLOR_BACKGROUND),
                            )
                          : const Icon(
                              Icons.phonelink_ring_sharp,
                              color: COLOR_BACKGROUND,
                            ),
                    )
                  ],
                ),
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
