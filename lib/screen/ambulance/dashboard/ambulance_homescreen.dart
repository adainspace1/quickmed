// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart' as model;
import 'package:quickmed/screen/ambulance/dashboard/ambulance_profile.dart';
import 'package:quickmed/screen/ambulance/tabpages/wallet.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/service/ambulance/ambulance_service.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/loading.dart';
import 'package:quickmed/screen/ambulance/tabpages/hometab.dart';

class AmbulanceHomeScreen extends StatefulWidget {
  const AmbulanceHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AmbulanceHomeScreen> createState() => _AmbulanceHomeScreenState();
}

class _AmbulanceHomeScreenState extends State<AmbulanceHomeScreen>
    with SingleTickerProviderStateMixin {
  var scaffoldState = GlobalKey<ScaffoldState>();

  AmbulanceDatabaseService services = AmbulanceDatabaseService();

  TabController? tabController;
  int selectedScreen = 0;

  onItemClicked(int index) {
    setState(() {
      selectedScreen = index;
      tabController!.index = selectedScreen;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: scaffoldState,
        drawer: Drawer(
          child: StreamBuilder<model.DriverModel>(
            stream: services.getUserStreamByUid(), // Add your user stream here
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Loading(); // to show a loading indicator while waiting for data
              }

              model.DriverModel? user = snapshot.data;

              return ListView(
                padding: EdgeInsets.zero,
                children: [
                  UserAccountsDrawerHeader(
                    accountName: Text(
                      user?.name ?? "",
                      style: const TextStyle(color: Colors.white),
                    ),
                    accountEmail: Text(user?.email ?? "",
                        style: const TextStyle(color: Colors.white)),
                    currentAccountPicture: CircleAvatar(
                      backgroundImage:
                          NetworkImage(user?.profileImageUrl ?? ""),
                    ),
                    decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment(0.8, 1),
                          colors: <Color>[
                            Color(0xff1f005c),
                            Color(0xff5b0060),
                            Color(0xff870160),
                            Color(0xffac255e),
                            Color(0xffca485c),
                            Color(0xffe16b5c),
                            Color(0xfff39060),
                            Color(0xffffb56b),
                          ], // Gradient from https://learnui.design/tools/gradient-generator.html
                        ),
                        image: DecorationImage(
                            image: NetworkImage(user?.profileImageUrl ?? ""),
                            fit: BoxFit.cover)),
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.person_3,
                      size: 30,
                      color: COLOR_ACCENT,
                    ),
                    title: const Text("Profile"),
                    onTap: () {
                      changeScreen(context, const AmbulanceProfileScreen());
                      // Navigate to ProfileScreen with user data
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.health_and_safety,
                      size: 30,
                      color: COLOR_ACCENT,
                    ),
                    title: const Text("Insurance"),
                    onTap: () {
                      // Navigate to ProfileScreen with user data
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.wallet,
                      size: 30,
                      color: COLOR_ACCENT,
                    ),
                    title: const Text("Wallet"),
                    onTap: () {
                      // Navigate to ProfileScreen with user data
                      changeScreen(context, const AmbulanceWalletScreen());
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ListTile(
                    leading: const Icon(
                      Icons.exit_to_app,
                      size: 30,
                      color: COLOR_ACCENT,
                    ),
                    title: const Text("Log out"),
                    // this is the logout button
                    onTap: () async {
                      // signOut
                      await AuthService.logout();

                      // ignore: use_build_context_synchronously
                      changeScreenReplacement(context, const SignInScreen());
                    },
                  )

                  // ... (add more ListTile widgets for other drawer items)
                ],
              );
            },
          ),
        ),
        body: Stack(
          children: [
            AmbulanceMapScreen(scaffoldState),
          ],
        ));
  }
}
