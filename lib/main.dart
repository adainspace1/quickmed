// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quickmed/provider/ambulance_profile_provider.dart';
// import 'package:quickmed/provider/app_info.dart';
import 'package:quickmed/provider/profile_provider.dart';
import 'package:quickmed/screen/splash_screen.dart';

void main() async {
  // initialized firebase.
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProfileProvider()),
        ChangeNotifierProvider(create: (context)=> AmbulanceProfileProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: SplashScreen(),
      ),
    );
    
  }
}
