// import 'package:flutter/material.dart';
// import 'package:quickmed/Assitance/request_assistant.dart';
// import 'package:quickmed/global/map_key.dart';
// import 'package:quickmed/model/predictplaces_model.dart';
// import 'package:quickmed/widget/place_prediction_file.dart';

// class SearchPlaceScreen extends StatefulWidget {
//   const SearchPlaceScreen({super.key});

//   @override
//   State<SearchPlaceScreen> createState() => _SearchPlaceScreenState();
// }

// class _SearchPlaceScreenState extends State<SearchPlaceScreen> {
//   List<PredictedPlaces> placesPredictedList = [];
//   findPlaceAutoCompleteSearch(String inputText) async {
//     if (inputText.length > 1) {
//       String urlAutoCompleteSearch =
//           "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:NG";

//       var responseAutoCompleteSearch =
//           await RequestAssistant.receiveRequest(urlAutoCompleteSearch);

//       if (responseAutoCompleteSearch ==
//           "Error Occurred. Failed. No Response.") {
//         return;
//       }

//       if (responseAutoCompleteSearch["status"] == "OK") {
//         var placePrediction = responseAutoCompleteSearch["prediction"];
//         var placePredictionList = (placePrediction as List)
//             .map((jsonData) => PredictedPlaces.fromJson(jsonData))
//             .toList();

//         setState(() {
//           placesPredictedList = placePredictionList;
//         });
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         backgroundColor: Colors.white,
//         appBar: AppBar(
//           backgroundColor: Colors.blue,
//           leading: GestureDetector(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: const Icon(
//               Icons.arrow_back,
//               color: Colors.grey,
//             ),
//           ),
//           title: const Text(
//             "Search and Set DropOff Location",
//             style: TextStyle(color: Colors.black),
//           ),
//           elevation: 0.0,
//         ),
//         body: Column(
//           children: [
//             Container(
//               decoration: const BoxDecoration(color: Colors.blue, boxShadow: [
//                 BoxShadow(
//                     color: Colors.white54,
//                     blurRadius: 8,
//                     spreadRadius: 0.8,
//                     offset: Offset(0.7, 0.7))
//               ]),
//               child: Padding(
//                 padding: const EdgeInsets.all(10),
//                 child: Column(
//                   children: [
//                     Row(
//                       children: [
//                         const Icon(
//                           Icons.adjust_sharp,
//                           color: Colors.white,
//                         ),
//                         const SizedBox(
//                           height: 10,
//                         ),
//                         Expanded(
//                             child: Padding(
//                           padding: const EdgeInsets.all(8),
//                           child: TextField(
//                             onChanged: (value) {
//                               findPlaceAutoCompleteSearch(value);
//                             },
//                             decoration: const InputDecoration(
//                                 hintText: "Search Location Here....",
//                                 fillColor: Colors.white,
//                                 filled: true,
//                                 border: InputBorder.none,
//                                 contentPadding: EdgeInsets.only(
//                                     left: 11, top: 8, bottom: 8)),
//                           ),
//                         ))
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),

//             // display PreddictedSearch
//             // ignore: prefer_is_empty
//             (placesPredictedList.length > 0)
//                 ? Expanded(
//                     child: ListView.separated(
//                     itemCount: placesPredictedList.length,
//                     physics: const ClampingScrollPhysics(),
//                     itemBuilder: (context, index) {
//                       return PlacePredictionTile(
//                         predictedPlaces: placesPredictedList[index],
//                       );
//                     },
//                     separatorBuilder: (BuildContext context, int index) {
//                       return const Divider(
//                         height: 0,
//                         color: Colors.blue,
//                         thickness: 0,
//                       );
//                     },
//                   ))
//                 : Container()
//           ],
//         ),
//       ),
//     );
//   }
// }
