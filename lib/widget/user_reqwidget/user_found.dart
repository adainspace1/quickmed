import 'package:flutter/material.dart';
import 'package:quickmed/util/constant.dart';

class UserFoundWidget extends StatefulWidget {
  const UserFoundWidget({Key? key}) : super(key: key);

  @override
  State<UserFoundWidget> createState() => _UserFoundWidgetState();
}


class _UserFoundWidgetState extends State<UserFoundWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: [
        Container(
          padding: const EdgeInsets.all(40),
          alignment: Alignment.center,
          child: const CircleAvatar(
            radius: 55,
            backgroundColor: Colors.amber,
            backgroundImage: NetworkImage(
              "imageUrl",
            ),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        //name of the individual
        const Text("name"),
        const SizedBox(
          height: 10,
        ),
        //issues
        const Text("issue"),
        const SizedBox(
          height: 120,
        ),

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
              onPressed: () {
                // Handle accepting the request
              },
              child: const Text(
                "Accepted",
                style: TextStyle(color: COLOR_BACKGROUND),
              ),
            ),
            const SizedBox(
              width: 20,
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                // Handle declining the request
              },
              child: const Text(
                'Declined',
                style: TextStyle(color: COLOR_BACKGROUND),
              ),
            ),
          ],
        )
      ],
    ));
  }
}
