// ignore: duplicate_ignore
// ignore: duplicate_ignore
// ignore: duplicate_ignore
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore, library_private_types_in_public_api

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_ACCENT,
        title: const Text(
          'Econsultant',
          style: TextStyle(color: COLOR_BACKGROUND),
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
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

                return ConversationList(
                  name: son,
                  imageUrl: imageUrl,
                  star: starRating,
                  isOnline: isOnline,
                  messageText: field,
                );
                // return ListTile(
                //   title: Text(son),
                //   leading: CircleAvatar(
                //     backgroundImage: NetworkImage(imageUrl),
                //   ),
                //   subtitle: Row(
                //     mainAxisSize: MainAxisSize.min,
                //     children: [
                //       Text(
                //        field
                //       ),
                //       const SizedBox(width: 20,),
                //       Text(
                //         isOnline ? 'Online' : 'Offline',
                //         style: TextStyle(
                //           color: isOnline ? Colors.green : Colors.red,
                //         ),
                //       ),
                //       const SizedBox(width: 8),
                //       StarsWidget(numberOfStars: starRating),

                //     ],
                //   ),
                // );
              },
            );
          } else {
            return const Text("null");
          }
        },
      ),
    );
  }
}

// ignore: must_be_immutable
class ConversationList extends StatefulWidget {
  String name;
  String messageText;
  String imageUrl;
  bool isOnline;
  int star;
  ConversationList(
      {super.key,
      required this.name,
      required this.messageText,
      required this.imageUrl,
      required this.star,
      required this.isOnline});
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        
      },
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
