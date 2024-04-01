// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart' as model;
import 'package:quickmed/screen/ambulance/dashboard/ambulance_profile.dart';
import 'package:quickmed/screen/ambulance/tabpages/earnings.dart';
import 'package:quickmed/screen/ambulance/tabpages/hometab.dart';
import 'package:quickmed/screen/ambulance/tabpages/treatment.dart';
import 'package:quickmed/screen/ambulance/tabpages/trip_page.dart';
import 'package:quickmed/screen/ambulance/tabpages/wallet.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/provider/ambulance/ambulance_appstate.dart';



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
     addData();
    tabController = TabController(length: 5, vsync: this);
  }

  addData() async {
    AmbulanceAppProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    model.DriverModel? user = Provider.of<AmbulanceAppProvider>(context).getUser;
    

    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        drawer: Drawer(
            child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.name ?? " "),
              accountEmail: Text(user?.email ?? " "),
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
                changeScreen(context, const AmbulanceProfileScreen());
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
              },
            ),
            const SizedBox(height: 20,),

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
        body: TabBarView(
          physics: const NeverScrollableScrollPhysics(),
          controller: tabController,
          children: [
                AmbulanceMapScreen(scaffoldState),
                const TreatMent(),
                const AmbulanceWalletScreen(),
                const TripsPage(),
                const EarningsPage()

          ],
        ),
        bottomNavigationBar: BottomNavigationBar(

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Treatment'),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),
            BottomNavigationBarItem(icon: Icon(Icons.trip_origin), label: 'TripPage'),
            BottomNavigationBarItem(icon: Icon(Icons.wallet_travel_rounded), label: 'Earning'),



          ],
          unselectedItemColor: COLOR_BACKGROUND,
          selectedItemColor: COLOR_PRIMARY,
          backgroundColor: COLOR_ACCENT,
          type: BottomNavigationBarType.fixed,
          showUnselectedLabels: true,
          currentIndex: selectedScreen,
          onTap: onItemClicked,
        ),
        ),
      
    );
  }
}
