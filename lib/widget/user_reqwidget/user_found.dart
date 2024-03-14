import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/model/user/user_model.dart' as model;
import 'package:quickmed/provider/econsultant/econsultant_appstate.dart';
import 'package:quickmed/provider/user/user_appstate.dart';
import 'package:quickmed/service/ride_request.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/loading.dart';

class UserFoundWidget extends StatefulWidget {
  const UserFoundWidget({Key? key}) : super(key: key);

  @override
  State<UserFoundWidget> createState() => _UserFoundWidgetState();
}

RideRequest _request = RideRequest();

class _UserFoundWidgetState extends State<UserFoundWidget> {
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserAppProvider appProvider = Provider.of(context, listen: false);
    await appProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    //user provider
    //UserAppProvider appProvider =Provider.of<UserAppProvider>(context, listen: false);
    //usermodel
    model.UserModel? user = Provider.of<UserAppProvider>(context, listen: false).getUser;

    

    //econsultant provider
    EconsultantAppProvider econsultantAppProvider = Provider.of(context, listen: false);

    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: _request.requestStream(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading(); // Show a loading indicator while data is being fetched
          }
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error occurred while fetching data.'),
            );
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No data available.'),
            );
          }

          List<QueryDocumentSnapshot> userDocuments = snapshot.data!.docs;

          return ListView.builder(
            itemCount: userDocuments.length,
            itemBuilder: (context, index) {
              DocumentSnapshot document = userDocuments[index];
              Map<String, dynamic> data =
                  document.data() as Map<String, dynamic>;

              String imageUrl = data['img'] ?? '';
              String name = data['name'] ?? '';
              String issue = data['issue'] ?? '';

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(40),
                    alignment: Alignment.center,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundColor: Colors.amber,
                      backgroundImage: NetworkImage(
                        imageUrl,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  //name of the individual
                  Text(name),
                  const SizedBox(
                    height: 10,
                  ),
                  //issues
                  Text(issue),
                  const SizedBox(
                    height: 120,
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green),
                        onPressed: () {
                          // Handle accepting the request
                          econsultantAppProvider.acceptRequest();
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
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red),
                        onPressed: () async {
                          // Handle declining the request
                          econsultantAppProvider.cancelRequest(user!.id);
                        },
                        child: const Text(
                          'Declined',
                          style: TextStyle(color: COLOR_BACKGROUND),
                        ),
                      ),
                    ],
                  )
                ],
              );
            },
          );
        },
      ),
    );
  }
}
