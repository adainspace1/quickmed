// ignore_for_file: sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/component/current_location.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/provider/profile_provider.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/screen/user/profile_screen.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/screen/wallet_ui/wallet_screen.dart';
import 'package:quickmed/widget/user_draggable.dart';

class UserGoogleMapScreen extends StatefulWidget {
  const UserGoogleMapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserGoogleMapScreen> createState() => _UserGoogleMapScreenState();
}

class _UserGoogleMapScreenState extends State<UserGoogleMapScreen> {
  var scaffoldState = GlobalKey<ScaffoldState>();

  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    super.initState();
    // Initialize the ProfileProvider and set the current user
    Provider.of<UserProfileProvider>(context, listen: false).initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldState,
      drawer: Consumer<UserProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.user != null) {
            return FutureBuilder<UserModel?>(
              future: profileProvider.getUserByUid(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error ${snapshot.error}");
                  }

                  // If user data is available, display the drawer content
                  if (snapshot.data != null) {
                    UserModel user = snapshot.data!;

                    return Drawer(
                      child: ListView(
                        padding: EdgeInsets.zero,
                        children: [
                          UserAccountsDrawerHeader(
                            accountName: Text(
                              user.name ?? "",
                              style: const TextStyle(color: Colors.black),
                            ),
                            accountEmail: Text(user.email ?? "",
                                style: const TextStyle(color: Colors.black)),
                            currentAccountPicture: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(user.profileImageUrl ?? ""),
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
                                    image: NetworkImage(
                                        user.profileImageUrl ?? ""),
                                    fit: BoxFit.cover)),
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
                              changeScreen(context, const ProfileScreen());
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
                              changeScreenReplacement(
                                  context, const SignInScreen());
                            },
                          )
                        ],
                      ),
                    );
                  }
                }

                // You can return a placeholder widget or loading indicator here
                return const CircularProgressIndicator();
              },
            );
          } else {
            // User is not signed in
            return const Text("No data"); // or any other widget
          }
        },
      ),
      body: Stack(
        children: [
          CurrentLocationScreen(
            scaffoldState,
          ),
          Visibility(
            child: const UserWidget(),
            visible: currentUser != null,
          ),
        ],
      ),
    );
  }
}
