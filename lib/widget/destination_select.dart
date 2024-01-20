import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/provider/user/user_appstate.dart';
import 'package:quickmed/util/constant.dart';

class DestinationSelectionWidget extends StatefulWidget {
  const DestinationSelectionWidget({super.key});

  @override
  State<DestinationSelectionWidget> createState() =>
      _DestinationSelectionWidgetState();
}

class _DestinationSelectionWidgetState
    extends State<DestinationSelectionWidget> {
  @override
  Widget build(BuildContext context) {
    UserAppProvider appstate = Provider.of<UserAppProvider>(context);
    return Material(
      child: DraggableScrollableSheet(
        initialChildSize: 0.28,
        minChildSize: 0.28,
        builder: (BuildContext context, myscrollController) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                      color: COLOR_ACCENT.withOpacity(.8),
                      offset: const Offset(3, 2),
                      blurRadius: 7)
                ]),
            child: ListView(
              controller: myscrollController,
              children: [
                const Icon(
                  Icons.remove,
                  size: 40,
                  color: Colors.red,
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 16, right: 16, bottom: 16),
                  child: Container(
                    color: COLOR_ACCENT.withOpacity(.3),
                    child: TextField(
                      onTap: () async {
                        //send request here
                      },
                      textInputAction: TextInputAction.go,
                      controller: appstate.destinationController,
                      cursorColor: Colors.blue.shade900,
                      decoration: InputDecoration(
                        icon: Container(
                          margin: const EdgeInsets.only(left: 20, bottom: 15),
                          width: 10,
                          height: 10,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.blue,
                          ),
                        ),
                        hintText: "Where to go?",
                        hintStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.all(15),
                      ),
                    ),
                  ),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange[300],
                    child: const Icon(
                      Icons.home,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text("Home"),
                  subtitle: const Text("25th avenue, 23 street"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.deepOrange[300],
                    child: const Icon(
                      Icons.work,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text("Work"),
                  subtitle: const Text("25th avenue, 23 street"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(0.18),
                    child: const Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text("Recent location"),
                  subtitle: const Text("25th avenue, 23 street"),
                ),
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.grey.withOpacity(.18),
                    child: const Icon(
                      Icons.history,
                      color: Colors.white,
                    ),
                  ),
                  title: const Text("Recent location"),
                  subtitle: const Text("25th avenue, 23 street"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
