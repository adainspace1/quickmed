import 'package:flutter/material.dart';

// this is the custom screen widget that wraps the sigin screnn page
class CustomScreen extends StatelessWidget {
  const CustomScreen({super.key, this.child});

  final Widget? child;


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          Image.network("https://res.cloudinary.com/damufjozr/image/upload/v1703154694/nurs1_rmqopd.jpg",
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          SafeArea(child: child!)
        ],
      ),
    );
  }
}

