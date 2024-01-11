// ignore_for_file: avoid_print

import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/Assitance/request_assistant.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/global/map_key.dart';
import 'package:quickmed/provider/app_info.dart';
import 'package:quickmed/model/direction_model.dart';
// import 'package:quickmed/model/user_model.dart';

class AsssitantMethod {
  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef =
        FirebaseDatabase.instance.ref().child("users").child(currentUser!.uid);

    userRef.once().then((snap) {
      if (snap.snapshot.value != null) {
        //  userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    }).catchError((error) {
      print(error);
    });
  }

  static Future<String> searchAddressForGeographicsCoordinate(
      Position position, context) async {
    String apiUrl =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    String humanReadbleAddress = "";

    var requestResponse = await RequestAssistant.receiveRequest(apiUrl);

    if (requestResponse != "Error occurred while fetching data") {
      humanReadbleAddress = requestResponse["results"][0]["formatted_address"];

      Directions userPickUpAddress = Directions();
      userPickUpAddress.locationlatitude = position.latitude;
      userPickUpAddress.locationlongitude = position.longitude;

      userPickUpAddress.locationName = humanReadbleAddress;

       Provider.of<AppInfo>(context, listen: false)
          .upDatePickUpLocationAddress(userPickUpAddress);
    }

    return humanReadbleAddress;
  }

  // static Future<DirectionDetailsInfo> obtainOriginToDestinationDirectionDetails(LatLng originPosition, LatLng destinationPosition)async{
      
  // }
}
