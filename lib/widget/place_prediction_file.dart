// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:quickmed/Assitance/request_assistant.dart';
// import 'package:quickmed/global/map_key.dart';
// import 'package:quickmed/provider/app_info.dart';
// import 'package:quickmed/model/direction_model.dart';
// import 'package:quickmed/model/predictplaces_model.dart';
// import 'package:quickmed/widget/progress_dialog.dart';
// import 'package:quickmed/global/global.dart';

// class PlacePredictionTile extends StatefulWidget {
//   final PredictedPlaces? predictedPlaces;

//   // ignore: use_key_in_widget_constructors, prefer_const_constructors_in_immutables
//   PlacePredictionTile({this.predictedPlaces});

//   @override
//   State<PlacePredictionTile> createState() => _PlacePredictionTileState();
// }

// class _PlacePredictionTileState extends State<PlacePredictionTile> {
//   getPlaceDirectionDetails(double? placeId, context) async {
//     showDialog(
//         context: context,
//         builder: (BuildContext context) => ProgressDialog(
//               message: "settingup dropoff location please wait......",
//             ));

//     String placeDirectionDetailsUrl =
//         "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";
//     var responseApi =
//         await RequestAssistant.receiveRequest(placeDirectionDetailsUrl);

//     Navigator.pop(context);
//     if (responseApi == "Error Occurred. Failed. No Response.") {
//       return;
//     }

//     if (responseApi['status'] == "OK") {
//       Directions directions = Directions();

//       directions.locationName = responseApi["result"]["name"];
//       directions.locationId = placeId;
//       directions.locationlatitude =
//           responseApi["result"]["geometry"]["location"]["lat"];
//       directions.locationlatitude =
//           responseApi["result"]["geometry"]["location"]["lng"];

//       Provider.of<AppInfo>(context, listen: false)
//           .upDateDropOffLocationAddress(directions);

//       setState(() {
//         userDropOffAddress = directions.locationName!;
//       });

//       Navigator.pop(context, "ObtainDropOff");
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: () {
//         getPlaceDirectionDetails(widget.predictedPlaces!.place_Id, context);
//       },
//       child: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Row(
//           children: [
//             const Icon(
//               Icons.add_location,
//               color: Colors.blue,
//             ),
//             const SizedBox(
//               width: 10,
//             ),
//             Expanded(
//                 child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   widget.predictedPlaces!.main_text!,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(fontSize: 16, color: Colors.blue),
//                 ),
//                 Text(
//                   widget.predictedPlaces!.secondary_text!,
//                   overflow: TextOverflow.ellipsis,
//                   style: const TextStyle(fontSize: 16, color: Colors.blue),
//                 )
//               ],
//             ))
//           ],
//         ),
//       ),
//     );
//   }
// }
