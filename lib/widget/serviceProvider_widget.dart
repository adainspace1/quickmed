// ignore_for_file: avoid_unnecessary_containers, file_names

import 'package:flutter/material.dart';

// this is a draggable widget for the user dashbaord.
class SpWidget extends StatefulWidget {
  const SpWidget({super.key});

  @override
  State<SpWidget> createState() => _SpWidgetState();
}

class _SpWidgetState extends State<SpWidget> {
  bool isLoading = false;

//  is for the draggable widget
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.3,
        minChildSize: 0.3,
        maxChildSize: 0.3,
        builder: (BuildContext context, myscrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.shade100,
                    offset: const Offset(3, 2),
                    blurRadius: 7)
              ],
            ),
            child: ListView(controller: myscrollController, children: [
              Column(
                children: [
                  Container(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          shape: const RoundedRectangleBorder(),
                          minimumSize: const Size(double.infinity, 50)),
                      onPressed: () {
                        
                      },
                      child: const Text(
                        "Go Online",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    child:  Image.network("https://res.cloudinary.com/damufjozr/image/upload/v1705519641/online_id0xhy.png", width: 
                    100,),
                  ),
                  const SizedBox(height: 20),
                 Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                    
                          Container(
                            child: ElevatedButton(style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              backgroundColor: Colors.blueAccent,
                              minimumSize: const Size(100, 40)
                            ), onPressed: (){}, child: const Text("Home", style: TextStyle(color: Colors.white),)),
                          ),
                            const SizedBox(width: 10,),
                           Container(
                            child: ElevatedButton(style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              backgroundColor: Colors.blueAccent,
                            ), onPressed: (){}, child: const Text("Treatment", style: TextStyle(color: Colors.white),)),
                          ),
                              const SizedBox(width: 10,),
                         Container(
                            child: ElevatedButton(style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(),
                              backgroundColor: Colors.blueAccent,
                            ), onPressed: (){}, child: const Text("Wallet", style: TextStyle(color: Colors.white),)),
                          ),
                      ],
                    ),
                  
                ],
              )
            ]),
          );
        });
  }
}
