// ignore_for_file: library_private_types_in_public_api, file_names, non_constant_identifier_names, unnecessary_import

import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/provider/econsultant/econsultant_appstate.dart';
import 'package:quickmed/util/notification.dart';
import 'package:quickmed/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/service/user/user_service.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/stars.dart';

class ListOfEcon extends StatefulWidget {
  const ListOfEcon({super.key});

  @override
  State<ListOfEcon> createState() => _ListOfEconState();
}

class _ListOfEconState extends State<ListOfEcon> {
  UserDataBaseServices services = UserDataBaseServices();
  final TextEditingController _search = TextEditingController();
  bool _isShowUser = false;
  final issueTextEditingController = TextEditingController();
  NotificationMessage notify = NotificationMessage();
  DatabaseReference? spRequestRef;
  String stateOfApp = "normal";
  double bottomMapPadding = 0;
  double userDetailsContainerHeight = 0;
  double requestContainerHeight = 0;
  StreamSubscription<DatabaseEvent>? spStreamSubscription;
  bool isDrawerOpened = true;
  GoogleMapController? controllerGoogleMap;
  String nameSp = "";

  cancelRideRequest() {
    //remove ride request from database
    spRequestRef!.remove();

    setState(() {
      stateOfApp = "normal";
    });
  }

  displayRequestContainer() {
    setState(() {
      userDetailsContainerHeight = 0;
      requestContainerHeight = 220;
      bottomMapPadding = 200;
      isDrawerOpened = true;
    });
  }

  makeRequest() {
    TextEditingController issue = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Describe Your Issue"),
        content: Container(
          height: 200, // Set the desired height
          decoration: BoxDecoration(
            color: Colors.white, // Set the background color to white
            borderRadius:
                BorderRadius.circular(8.0), // Optional: add border radius
          ),
          child: TextField(
            controller: issue,
            decoration: const InputDecoration(
              hintText: "Describe the issue",
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none, // Remove border
            ),
          ),
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: COLOR_ACCENT),
            onPressed: () async {
              spRequestRef =
                  FirebaseDatabase.instance.ref().child("spRequest").push();

              Map spCoOrdinates = {
                "latitude": "",
                "longitude": "",
              };

              Map dataMap = {
                "spRequestID": "",
                "publishDateTime": DateTime.now().toString(),
                "userName": "",
                "userPhone": "",
                "userID": "",
                "userPosition": "",
                "spID": "waiting",
                "carDetails": "",
                "spLocation": spCoOrdinates,
                "spName": "",
                "spPhone": "",
                "issues": issue.text,
                "fareAmount": "",
                "status": "new",
              };

              spRequestRef!.set(dataMap);
              spStreamSubscription =
                  spRequestRef!.onValue.listen((event) async {
                if (event.snapshot.value == null) {
                  return;
                }

                if ((event.snapshot.value as Map)["spName"] != null) {
                  nameSp = (event.snapshot.value as Map)["spName"];
                  print(nameSp);
                }
              });

              Navigator.pop(context);
            },
            child: const Text(
              "Proceed",
              style: TextStyle(color: COLOR_BACKGROUND),
            ),
          )
        ],
      ),
    );
  }

  Widget UserList(
      {required String id,
      required String name,
      required String imageUrl,
      required bool isOnline,
      required int star,
      required String messageText}) {
    return GestureDetector(
      onTap: () {
        // Handle onTap action here
        makeRequest();
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: NetworkImage(imageUrl), // Set the image
              maxRadius: 30,
            ),
            const SizedBox(
              width: 16,
            ),
            Expanded(
              child: Container(
                color: Colors.transparent,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name, // Display user's name
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(
                      height: 6,
                    ),
                    Text(
                      isOnline ? 'Online' : 'Offline', // Display online status
                      style: TextStyle(
                        color: isOnline ? Colors.green : Colors.red,
                      ),
                    ),
                    Text(
                      messageText,
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            StarsWidget(numberOfStars: star),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<EconsultantAppProvider>(
      context,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_ACCENT,
        title: Form(
          child: TextFormField(
            controller: _search,
            decoration: const InputDecoration(
                labelText: "Search For Econsultants eg nurse, doctor",
                labelStyle: TextStyle(color: Colors.white, fontSize: 16)),
            onFieldSubmitted: (String _) {
              setState(() {
                _isShowUser = true;
              });
            },
          ),
        ),
      ),
      body: _isShowUser
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection("econsultants")
                  .where('medicalField', isEqualTo: _search.text.toLowerCase())
                  .get(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Show circular progress indicator while waiting for data
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (snapshot.hasError) {
                  // Handle error state
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Text(
                      'No results found for "${_search.text}"',
                      style: const TextStyle(fontSize: 20),
                    ),
                  );
                } else {
                  // Data has been successfully fetched, display list of items
                  return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (context, index) {
                      return Stack(children: [
                        Visibility(
                          child: UserList(
                            id: (snapshot.data! as dynamic).docs[index]['id'],
                            name: (snapshot.data! as dynamic).docs[index]
                                ['name'],
                            imageUrl: (snapshot.data! as dynamic).docs[index]
                                ['img'],
                            star: (snapshot.data! as dynamic).docs[index]
                                ['rating'],
                            isOnline: (snapshot.data! as dynamic).docs[index]
                                ['is_Online'],
                            messageText: (snapshot.data! as dynamic).docs[index]
                                ['medicalField'],
                          ),
                        ),
                      ]);
                    },
                  );
                }
              },
            )
          : StreamBuilder<QuerySnapshot>(
              stream: services.econsultantStream(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  List sp = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: sp.length,
                    shrinkWrap: true,
                    padding: const EdgeInsets.only(top: 16),
                    itemBuilder: (context, index) {
                      DocumentSnapshot document = sp[index];
                      Map<String, dynamic> data =
                          document.data() as Map<String, dynamic>;
                      String field = data['medicalField'];
                      bool isOnline = data['is_Online'] ?? false;
                      int starRating = data['rating'] ?? 0;
                      String imageUrl = data['img'] ?? '';
                      String son = data['name'] ?? '';
                      String id = data['id'] ?? '';

                      return Stack(children: [
                        Visibility(
                          child: UserList(
                            id: id,
                            name: son,
                            imageUrl: imageUrl,
                            star: starRating,
                            isOnline: isOnline,
                            messageText: field,
                          ),
                        ),
                      ]);
                    },
                  );
                } else {
                  return const Loading();
                }
              },
            ),
    );
  }
}
