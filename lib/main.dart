import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickmed/provider/ambulance/ambulance_appstate.dart';
import 'package:quickmed/provider/econsultant/econsultant_appstate.dart';
import 'package:quickmed/provider/user/user_appstate.dart';
import 'package:quickmed/screen/splash_screen.dart';

void main() async {
  // initialized firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  //await FirebaseAPi().initNotification();
  runApp(const MyApp());
}
//this is the root directory of the entire application....
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
      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
            useMaterial3: true,
          ),
          home:  const SplashScreen()),
    );
  }
}
