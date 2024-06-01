// ignore_for_file: non_constant_identifier_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/screen/user/chat/chat.dart';
import 'package:quickmed/service/hospital/hospital.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/loading.dart';

class ListOfHospital extends StatefulWidget {
  const ListOfHospital({super.key});

  @override
  State<ListOfHospital> createState() => _ListOfHospitalState();
}

class _ListOfHospitalState extends State<ListOfHospital> {
  final TextEditingController _search = TextEditingController();
  bool _isShowUser = false;
  HospitalServices services = HospitalServices();

  Widget UserList(
      {required String id, required String name, required bool isOnline}) {
    return GestureDetector(
      onTap: () {
        // Handle onTap action here
        changeScreen(
            context,
            MyChatApp(
                userId: id,
                name: name,
                img:
                    'https://res.cloudinary.com/damufjozr/image/upload/v1701761462/hos2_qtpkzs.png',
                isOnline: isOnline));
      },
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            const CircleAvatar(
              backgroundImage: NetworkImage(
                  "https://res.cloudinary.com/damufjozr/image/upload/v1701761462/hos2_qtpkzs.png"), // Set the image
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
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_ACCENT,
        title: Form(
          child: TextFormField(
            controller: _search,
            decoration: const InputDecoration(
                labelText: "Search For Hospitals ",
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
                  .collection("hospital")
                  .where('hospitalName', isEqualTo: _search.text.toLowerCase())
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
                            id: (snapshot.data as dynamic).docs[index]['id'],
                            name: (snapshot.data as dynamic).docs[index]
                                ['hospitalName'],
                            isOnline: (snapshot.data as dynamic).docs[index]
                                ['is_Online'],
                          ),
                        ),
                      ]);
                    },
                  );
                }
              },
            )
          : StreamBuilder<QuerySnapshot>(
              stream: services.hospitalStream(),
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

                      String son = data['hospitalName'] ?? '';
                      String id = data['id'] ?? '';
                      bool online = data['is_Online'] ?? '';

                      return Stack(children: [
                        Visibility(
                          child: UserList(id: id, name: son, isOnline: online),
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
