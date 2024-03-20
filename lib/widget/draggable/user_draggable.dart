import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/screen/user/search/List_econsultant.dart';
import 'package:quickmed/widget/loading.dart';

// this is a draggable widget for the user dashbaord.
class UserWidget extends StatefulWidget {
  const UserWidget({super.key});

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  bool isLoading = false;

//  is for the draggable widget
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.5,
        builder: (BuildContext context, myscrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade100,
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ],
            ),
            child: ListView(controller: myscrollController, children: [
              ListTile(
                  onTap: () async {
                    setState(() {
                      isLoading = true; // Set loading to true when tapped
                    });

                    // Add a delay using Future.delayed
                    await Future.delayed(const Duration(
                        seconds: 2)); // Adjust the duration as needed

                    // Perform the phone call
                    await FlutterPhoneDirectCaller.callNumber('+2349074235666');

                    setState(() {
                      isLoading =
                          false; // Set loading to false after the call is complete
                    });
                    // await FlutterPhoneDirectCaller.callNumber('+2349074235666');
                  },
                  leading: Image.network(
                    "https://res.cloudinary.com/damufjozr/image/upload/v1703405431/Pngtree_phone_icon_isolated_on_abstract_5261328_eyymfy.png",
                    width: 40,
                    height: 40,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      // Loader widget
                      if (isLoading)
                        const Center(
                          child: Loading(),
                        ),
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "Quick Call",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: TextStyle(color: Colors.black))),
                    ],
                  )),
              ListTile(
                  onTap: () {
                    changeScreen(context, const ListOfEcon());
                  },
                  leading: Image.network(
                    "https://res.cloudinary.com/damufjozr/image/upload/v1701761216/pers_jfroff.png",
                    width: 40,
                    height: 40,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "E-consultant",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: TextStyle(color: Colors.black))),
                    ],
                  )),
              ListTile(
                  onTap: () {
                  },
                  leading: Image.network(
                    "https://res.cloudinary.com/damufjozr/image/upload/v1701760812/amb2_gpa3lp.jpg",
                    width: 40,
                    height: 40,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "Ambulance",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: TextStyle(color: Colors.black))),
                    ],
                  )),
              ListTile(
                  leading: Image.network(
                    "https://res.cloudinary.com/damufjozr/image/upload/v1701761462/hos2_qtpkzs.png",
                    width: 40,
                    height: 40,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "Hospital",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: TextStyle(color: Colors.black))),
                    ],
                  )),
              ListTile(
                  leading: Image.network(
                    "https://res.cloudinary.com/damufjozr/image/upload/v1703414009/5172568_add_contact_user_icon_hojgvo.png",
                    width: 40,
                    height: 40,
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      RichText(
                          text: const TextSpan(children: [
                        TextSpan(
                            text: "Book for someone",
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w300)),
                      ], style: TextStyle(color: Colors.black))),
                    ],
                  )),
            ]),
          );
        });
  }
}
