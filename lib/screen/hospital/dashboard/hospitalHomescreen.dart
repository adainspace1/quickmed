// ignore_for_file: sort_child_properties_last, file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/hospital/hospital_model.dart' as model;
import 'package:quickmed/provider/hospital/hospital_appstate.dart';
import 'package:quickmed/screen/ambulance/dashboard/ambulance_profile.dart';
import 'package:quickmed/screen/ambulance/tabpages/treatment.dart';
import 'package:quickmed/screen/hospital/tabpages/hometab.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/screen/user/user_wallet/wallet_screen.dart';
import 'package:quickmed/util/constant.dart';



class HospitalScreen extends StatefulWidget {
  const HospitalScreen({
    Key? key,
  }) : super(key: key);

  @override
  State<HospitalScreen> createState() => _HospitalScreenState();
}

class _HospitalScreenState extends State<HospitalScreen>
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
    tabController = TabController(length: 3, vsync: this);
  }

  addData() async {
    HospitalAppProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    model.HospitalModel? user = Provider.of<HospitalAppProvider>(context).getUser;

    

    return SafeArea(
      child: Scaffold(
        key: scaffoldState,
        drawer: Drawer(
            child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(user?.hospitalName ?? " "),
              accountEmail: Text(user?.hospitalemail ?? " "),
              currentAccountPicture: const CircleAvatar(
                backgroundImage: NetworkImage("https://res.cloudinary.com/damufjozr/image/upload/v1701761462/hos2_qtpkzs.png"),
              ),
               decoration: const BoxDecoration(
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
                            image: NetworkImage("https://res.cloudinary.com/damufjozr/image/upload/v1701761462/hos2_qtpkzs.png"),
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
                HospitalMapScreen(scaffoldState),
                const TreatMent(),
                const WalletScreen()

          ],
        ),
        bottomNavigationBar: BottomNavigationBar(

          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.health_and_safety), label: 'Treatment'),
            BottomNavigationBarItem(icon: Icon(Icons.wallet), label: 'Wallet'),



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
