// ignore_for_file: sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickmed/component/current_location.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/screen/user/profile_screen.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/user_draggable.dart';

class AmbulanceGoogleMapScreen extends StatefulWidget {
  const AmbulanceGoogleMapScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AmbulanceGoogleMapScreen> createState() => _AmbulanceGoogleMapScreenState();
}

class _AmbulanceGoogleMapScreenState extends State<AmbulanceGoogleMapScreen> {
  var scaffoldState = GlobalKey<ScaffoldState>();

  var currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Ambulance"),
          backgroundColor: COLOR_ACCENT,
        ),
        key: scaffoldState,
        drawer: Drawer(
          child: FutureBuilder<DriverModel?>(
            future: DatabaseService.getUserByUid(currentUser?.uid ?? ""),
            builder: (context, snapshot) {
              if (currentUser == null) {
                // User not authenticated, handle accordingly
                return ListTile(
                  title: const Text('User not authenticated'),
                  // You may want to add a onTap action to handle this case
                  onTap: () {
                    AuthService.logout();
                    changeScreen(context, const SignInScreen());
                    
                  },
                );
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                    strokeWidth: 2.0,
                  ),
                );
              } else if (snapshot.hasError || snapshot.data == null) {
                return const Text('Error loading user data');
              } else {
                DriverModel user = snapshot.data!;

                return Column(
                  children: [
                    UserAccountsDrawerHeader(
                      
                      accountName: Text(user.name ?? " "),
                      accountEmail: Text(user.email ?? " "),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            NetworkImage(user.profileImageUrl ?? ""),
                      ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                  image: NetworkImage(user.profileImageUrl ?? ""),
                                  fit: BoxFit.cover
                            ),
                          ),
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
                    // ... other ListTile items
                  ],
                );
              }
            },
          ),
        ),
        body: Stack(
          children: [
             CurrentLocationScreen(scaffoldState),
            Visibility(
              child: const UserWidget(),
              visible: currentUser != null,
            ),
          ],
        ),
      ),
    );
  }
}
