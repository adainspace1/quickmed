// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart' as model;
import 'package:quickmed/provider/ambulance/ambulance_user_provider.dart';
import 'package:quickmed/screen/ambulance/ambulance_profile.dart';
import 'package:quickmed/screen/ambulance/map/Ambulance_map.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/screen/user/user_wallet/wallet_screen.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/serviceProvider_widget.dart';

class AmbulanceHomeScreen extends StatefulWidget {
  const AmbulanceHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<AmbulanceHomeScreen> createState() => _AmbulanceHomeScreenState();
}

class _AmbulanceHomeScreenState extends State<AmbulanceHomeScreen> {
  var scaffoldState = GlobalKey<ScaffoldState>();


  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    AmbulanceProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }


  @override
  Widget build(BuildContext context) {
    model.DriverModel? user = Provider.of<AmbulanceProvider>(context).getUser;

    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        drawer: Drawer(
          child: ListView(
               
                  children: [
                    UserAccountsDrawerHeader(
                      
                      accountName: Text(user.name ?? " "),
                      accountEmail: Text(user.email ??" "),
                      currentAccountPicture: CircleAvatar(
                        backgroundImage:
                            NetworkImage(user.profileImageUrl ?? ""),
                      ),
                          decoration: BoxDecoration(
                            image: DecorationImage(
                                  image: NetworkImage(user.profileImageUrl ??""),
                                  fit: BoxFit.cover
                            ),
                          ),
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
                        changeScreen(context, const AmbulanceProfileScreen());
                      },
                    ),
                    const SizedBox(height: 10,),
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
        )),
        body: Stack(
          children: [
             AmbulanceMapScreen(scaffoldState),
            const Visibility(
              child: SpWidget(),
            ),
          ],
        ),
      ),
    );
  }
}
