// ignore_for_file: sort_child_properties_last, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart' as model;
import 'package:quickmed/provider/econsultant/econsultant_appstate.dart';
import 'package:quickmed/screen/e-consultant/dashboard/econ_profile.dart';
import 'package:quickmed/screen/e-consultant/tabPages/treatment.dart';
import 'package:quickmed/screen/e-consultant/tabPages/wallet.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/service/econsultant/econ_service.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/loading.dart';
import 'package:quickmed/screen/e-consultant/tabPages/home.dart';
import 'package:quickmed/widget/user_reqwidget/user_found.dart';

class EconsultantHomeScreen extends StatefulWidget {
  const EconsultantHomeScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<EconsultantHomeScreen> createState() => _EconsultantHomeScreenState();
}

class _EconsultantHomeScreenState extends State<EconsultantHomeScreen>
    with SingleTickerProviderStateMixin {
  var scaffoldState = GlobalKey<ScaffoldState>();

  EconsultantServices services = EconsultantServices();

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
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    EconsultantAppProvider appProvider = Provider.of<EconsultantAppProvider>(context);

    return Scaffold(
      key: scaffoldState,
      drawer: Drawer(
        child: StreamBuilder<model.EconsultantModel>(
          stream: services.getUserStreamByUid(), // Add your user stream here
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Loading(); // You can show a loading indicator while waiting for data
            }

            model.EconsultantModel? user = snapshot.data;

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
                    backgroundImage: NetworkImage(user?.profileImage ?? ""),
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
                          image: NetworkImage(user?.profileImage ?? ""),
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
                    changeScreen(context, const EconsultantProfileScreen());
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
                    changeScreen(context, const EconsultantWalletScreen());
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
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: [
          Visibility(
            child: EconsultantMapScreen(scaffoldState),
          ),
          const Visibility(
            child: EconsultantTreatMent(),
          ),

          Visibility(
          visible: appProvider.show == Show.User_Loading,
            child:const UserFoundWidget(),
          ),

          
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.health_and_safety), label: 'Treatment'),
        BottomNavigationBarItem(
              icon: Icon(Icons.person_add), label: 'User'),
        ],
        unselectedItemColor: COLOR_BACKGROUND,
        selectedItemColor: COLOR_PRIMARY,
        backgroundColor: COLOR_ACCENT,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        currentIndex: selectedScreen,
        onTap: onItemClicked,
      ),
    );
  }
}
