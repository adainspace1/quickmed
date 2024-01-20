import 'dart:convert';

import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:quickmed/Assitance/request_assistant.dart';
import 'package:quickmed/global/map_key.dart';
import 'package:quickmed/model/route/route_model.dart';

class GoogleMapServices {
  Future<RouteModel> getRouteByCoordinate(LatLng l1, LatLng l2) async {
    String url =
        "https://maps.googleapis.com/maps/api/directions/json?origin=${l1.latitude},${l1.longitude}&destination=${l2.latitude},${l2.longitude}&key=$mapKey";
    var response = await RequestAssistant.receiveRequest(url);
    Map values = jsonDecode(response.body);
    Map routes = values["routes"][0];
    Map legs = values["routes"][0]["legs"];

    RouteModel route = RouteModel(
        points: routes["overview_polyline"]["points"],
        distance: Distance.fromMap(legs["distance"]),
        timeNeeded: TimeNeeded.fromMap(legs["duration"]),
        startAddress: legs["end_address"],
        endAddress: legs["end_address"]);
        
    return route;
  }
}
