import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/screen/signin_screen.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/helpers/screen_navigation.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  
  @override
  void initState() {
    
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    Future.delayed(const Duration(seconds: 10), (){
      changeScreenReplacement(context, const SignInScreen());
    });
  }
  
  @override
  void dispose(){
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: SystemUiOverlay.values);
    super.dispose();
  }


  
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [COLOR_BACKGROUND, Colors.white], begin: Alignment.topRight, end: Alignment.bottomLeft),

        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FancyShimmerImage(imageUrl: "https://res.cloudinary.com/damufjozr/image/upload/v1703967240/QuickmedlogoBGpng_agpu0q.png",width: 220, height: 220,),
            
          ],
        ),
      ),
    );
  }
}
