// ignore_for_file: use_build_context_synchronously, duplicate_ignore
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/provider/ambulance/ambulance_appstate.dart';
import 'package:quickmed/provider/econsultant/econsultant_appstate.dart';
import 'package:quickmed/provider/hospital/hospital_appstate.dart';
import 'package:quickmed/provider/user/user_appstate.dart';
import 'package:quickmed/screen/ambulance/dashboard/ambulance_homescreen.dart';
import 'package:quickmed/screen/e-consultant/dashboard/econ_homeScreen.dart';
import 'package:quickmed/screen/hospital/dashboard/hospitalHomescreen.dart';
import 'package:quickmed/screen/splash_screen.dart';
import 'package:quickmed/screen/user/dashboard/user_home_screen.dart';
import 'package:quickmed/provider/app_info.dart';


Future<void> main() async {
  // initialized firebase.
  WidgetsFlutterBinding.ensureInitialized();

  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyAgI5gBiZpxrqGDRvrLso3EW1aEL1jxRiM",
            authDomain: "quickmedapp-68e93.firebaseapp.com",
            databaseURL:"https://quickmedapp-68e93-default-rtdb.firebaseio.com",
            projectId: "quickmedapp-68e93",
            storageBucket: "quickmedapp-68e93.appspot.com",
            messagingSenderId: "200709773011",
            appId: "1:200709773011:web:da7b002bf5b3a05db16626"));
  } else {
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
  }

   await Permission.notification.isDenied.then((valueOfPermission)
  {
    if(valueOfPermission)
    {
      Permission.notification.request();
    }
  });
   
  runApp(const MyApp());
}

//this is the root directory of the entire application
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
        const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    //these are my mobile app proiders
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserAppProvider()),
        ChangeNotifierProvider(create: (context) => AmbulanceAppProvider()),
        ChangeNotifierProvider(create: (context) => EconsultantAppProvider()),
        ChangeNotifierProvider(create: (context) => HospitalAppProvider()),
        ChangeNotifierProvider(create: (context) => AppInfo()),
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home: const CheckUserLoggedIn()),
    );
  }
}

//this check if the user is logged in or not
class CheckUserLoggedIn extends StatefulWidget {
  const CheckUserLoggedIn({super.key});

  @override
  State<CheckUserLoggedIn> createState() => _CheckUserLoggedInState();
}

class _CheckUserLoggedInState extends State<CheckUserLoggedIn> {
  @override
  void initState() {
    super.initState();
    AuthService.getAccountType().then((value) {
      if (value == "User") {
        changeScreenReplacement(context, const UserHomeScreen());
      } else if (value == "ambulance") {
        changeScreenReplacement(context, const AmbulanceHomeScreen());
      } else if (value == "econsultants") {
        changeScreenReplacement(context, const EconsultantHomeScreen());
      } else if (value == "hospital") {
        changeScreenReplacement(context, const HospitalScreen());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
