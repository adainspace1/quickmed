// ignore: file_names
// ignore: file_names
// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/provider/user/user_provider.dart';
import 'package:quickmed/screen/e-consultant/map/econ_map.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/screen/user/user_wallet/wallet_screen.dart';
import 'package:quickmed/widget/serviceProvider_widget.dart';

class EconsultantHomeScreen extends StatefulWidget {
  const EconsultantHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EconsultantHomeScreen> createState() => _EconsultantHomeScreenState();
}

class _EconsultantHomeScreenState extends State<EconsultantHomeScreen> {
  var scaffoldState = GlobalKey<ScaffoldState>();

  var currentUser = FirebaseAuth.instance.currentUser;
// Variable to track selected index

  

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      drawer: Consumer<UserProvider>(builder: (context, user, child) {
        return Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              const UserAccountsDrawerHeader(
                accountName: Text(
                  "",
                  style: TextStyle(color: Colors.black),
                ),
                accountEmail: Text("", style: TextStyle(color: Colors.black)),
                currentAccountPicture: CircleAvatar(
                  backgroundImage: NetworkImage(""),
                ),
                decoration: BoxDecoration(
                    gradient: LinearGradient(
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
                        image: NetworkImage(""), fit: BoxFit.cover)),
              ),
              ListTile(
                leading: const Icon(
                  Icons.person_3,
                  size: 30,
                  color: Colors.blueAccent,
                ),
                title: const Text("Profile"),
                onTap: () {
                  // Navigate to ProfileScreen with user data
                  //changeScreen(context, const ProfileScreen());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.health_and_safety,
                  size: 30,
                  color: Colors.blueAccent,
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
                  color: Colors.blueAccent,
                ),
                title: const Text("Wallet"),
                onTap: () {
                  // Navigate to ProfileScreen with user data
                  changeScreen(context, const WalletScreen());
                },
              ),
              const SizedBox(
                height: 10,
              ),
              ListTile(
                leading: const Icon(
                  Icons.exit_to_app,
                  size: 30,
                  color: Colors.blueAccent,
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
            ],
          ),
        );
      }),
      body: Stack(
        children: [
          EconsultantMapScreen(scaffoldState),
          const Visibility(
              child: SpWidget(),

          )
        ],
      ),
   
    );
  }
}
