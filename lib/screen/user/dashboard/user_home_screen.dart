// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/model/user/user_model.dart' as model;
import 'package:quickmed/provider/user/user_provider.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/screen/user/map/user_mapscreen.dart';
import 'package:quickmed/screen/user/dashboard/profile_screen.dart';
import 'package:quickmed/screen/user/user_wallet/wallet_screen.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/user_draggable.dart';

class UserHomeScreen extends StatefulWidget {
  const UserHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<UserHomeScreen> createState() => _UserHomeScreenState();
}

class _UserHomeScreenState extends State<UserHomeScreen> {
  var scaffoldState = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    model.UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      key: scaffoldState,
      drawer: Drawer(
        child: ListView(
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
                backgroundImage: NetworkImage(user?.profileImageUrl ?? ""),
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
          ],
        ),
      ),
      body: Stack(
        children: [
          UserMapScreen(scaffoldState),
           const Visibility(
            child: UserWidget(),
          )
        ],
      ),
    );
  }
}
