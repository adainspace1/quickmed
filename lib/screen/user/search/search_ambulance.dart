// ignore_for_file: library_private_types_in_public_api

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/model/user/user_model.dart';
//import 'package:quickmed/model/user/user_model.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController searchEditingController = TextEditingController();
QuerySnapshot? searchResultSnapshot;
bool isLoading = false;
bool haveUserSearched = false;

initiateSearch() async {
  if (searchEditingController.text.isNotEmpty) {
    setState(() {
      isLoading = true;
    });

    try {
      var snapshot = await DatabaseService().searchByName(searchEditingController.text);
      if (snapshot.docs.isNotEmpty) {
        setState(() {
          searchResultSnapshot = snapshot;
          isLoading = false;
          haveUserSearched = true;
        });
      } else {
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
      }
    } catch (e) {
      print(e);
    }
  }
}

Widget userList() {
  return haveUserSearched
      ? ListView.builder(
          shrinkWrap: true,
          itemCount: searchResultSnapshot?.docs.length ?? 0,
          itemBuilder: (context, index) {
            return userTile(
             searchResultSnapshot?.docs[index]["email"],
              searchResultSnapshot?.docs[index]["userName"]
            );
          },
        )
      : Container();
}



// 1.create a chatroom, send user to the chatroom, other userdetails
  // sendMessage(String userName) {
  //   List<String> users = [Constants.myName, userName];

  //   String chatRoomId = getChatRoomId(Constants.myName, userName);

  //   Map<String, dynamic> chatRoom = {
  //     "users": users,
  //     "chatRoomId": chatRoomId,
  //   };

  //   DatabaseService().addChatRoom(chatRoom, chatRoomId);

  //   Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //           builder: (context) => Chat(
  //                 chatRoomId: chatRoomId,
  //               )));
  // }

  // getChatRoomId(String a, String b) {
  //   if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
  //     return "$b\_$a";
  //   } else {
  //     return "$a\_$b";
  //   }
  // }

  @override
  void initState() {
    super.initState();
  }

  Widget userTile(String userName, String userEmail) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                userName,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              ),
              Text(
                userEmail,
                style: const TextStyle(color: Colors.black, fontSize: 16),
              )
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // sendMessage(userName);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(24)),
              child: const Text(
                "Message",
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Container(
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            )
          : Container(
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    color: const Color(0x54FFFFFF),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: searchEditingController,
                            style: const TextStyle(),
                            decoration: const InputDecoration(
                                hintText: "search username ...",
                                hintStyle: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                                border: InputBorder.none),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            initiateSearch();
                          },
                          child: Container(
                              height: 40,
                              width: 40,
                              decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                      colors: [
                                        Color(0x36FFFFFF),
                                        Color(0x0FFFFFFF)
                                      ],
                                      begin: FractionalOffset.topLeft,
                                      end: FractionalOffset.bottomRight),
                                  borderRadius: BorderRadius.circular(40)),
                              padding: const EdgeInsets.all(12),
                              child: const Icon(
                              Icons.search,
                              size: 30,
                              color: Colors.blueAccent,
                            ),
                              
                              ),

                              // child: Image.asset(
                              //   "assets/images/search_white.png",
                              //   height: 25,
                              //   width: 25,
                              // )),
                        )
                      ],
                    ),
                  ),
                  userList()
                ],
              ),
            ),
    );
  }
}
