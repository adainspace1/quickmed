import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/provider/user/user_appstate.dart';
import 'package:quickmed/provider/user/user_provider.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/loading.dart';
import 'package:quickmed/model/user/user_model.dart' as model;

class UserMapScreen extends StatefulWidget {

    final GlobalKey<ScaffoldState> scaffoldState;

   const UserMapScreen(this.scaffoldState, {super.key});
  @override
  // ignore: library_private_types_in_public_api
  _UserMapScreenState createState() => _UserMapScreenState();
}

class _UserMapScreenState extends State<UserMapScreen> {
  TextEditingController destinationController = TextEditingController();
  Color darkBlue = Colors.black;
  Color grey = Colors.grey;
  GlobalKey<ScaffoldState> scaffoldSate = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    UserAppProvider appState = Provider.of<UserAppProvider>(context);
    model.UserModel? user = Provider.of<UserProvider>(context).getUser;

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
            Positioned(
            top: 40,
            left: 15,
            child: CircleAvatar(
              backgroundColor:
                  COLOR_ACCENT, // Set your desired background color
              radius: 20, // Set the desired radius
              child: IconButton(
                alignment: Alignment.center,
              
                icon: CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(
                        user.profileImageUrl ?? ""),
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