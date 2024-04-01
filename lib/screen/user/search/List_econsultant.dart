// ignore_for_file: library_private_types_in_public_api, file_names

import 'package:provider/provider.dart';
import 'package:quickmed/provider/econsultant/econsultant_appstate.dart';
import 'package:quickmed/provider/user/user_appstate.dart' hide Show;
import 'package:quickmed/util/notification.dart';
import 'package:quickmed/widget/loading.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/service/user/user_service.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/requestloader/loader.dart';
import 'package:quickmed/widget/stars.dart';
import 'package:quickmed/model/user/user_model.dart' as model;

class ListOfEcon extends StatefulWidget {
  const ListOfEcon({super.key});

  @override
  State<ListOfEcon> createState() => _ListOfEconState();
}

class _ListOfEconState extends State<ListOfEcon> {
  UserDataBaseServices services = UserDataBaseServices();
  final TextEditingController _search = TextEditingController();
  bool _isShowUser = false;

  @override
  Widget build(BuildContext context) {
    EconsultantAppProvider appstate = Provider.of<EconsultantAppProvider>(context,);
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
                          child: ConversationList(
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
                          child: ConversationList(
                            id: id,
                            name: son,
                            imageUrl: imageUrl,
                            star: starRating,
                            isOnline: isOnline,
                            messageText: field,
                          ),
                        ),

                        Visibility(
                          visible: appstate.show == Show.SP_Found,
                          child: const SpLoading(),
                        )
                        
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

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {
  String? id;
  String name;
  String messageText;
  String imageUrl;
  bool isOnline;
  int star;

  ConversationList(
      {super.key,
      required this.id,
      required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.star,
      required this.isOnline});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  final issueTextEditingController = TextEditingController();
  NotificationMessage notify = NotificationMessage();

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserAppProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  void openModal(BuildContext context) {
    UserAppProvider appState =
        Provider.of<UserAppProvider>(context, listen: false);
    model.UserModel? user = appState.getUser;

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
            controller: issueTextEditingController,
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
              if (issueTextEditingController.text.isEmpty) {
                notify.error();
              } else {
                appState.createRequest(
                    issueTextEditingController.text, context, user!);
              }

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => openModal(context), // Pass context here
      child: Container(
        padding:
            const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  CircleAvatar(
                    backgroundImage: NetworkImage(widget.imageUrl),
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
                            widget.name,
                            style: const TextStyle(fontSize: 16),
                          ),
                          Text(
                            widget.messageText,
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(
                            height: 6,
                          ),
                          Text(
                            widget.isOnline ? 'Online' : 'Offline',
                            style: TextStyle(
                              color:
                                  widget.isOnline ? Colors.green : Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            StarsWidget(numberOfStars: widget.star),
          ],
        ),
      ),
    );
  }
}
