import 'package:flutter/material.dart';
import 'package:quickmed/service/econsultant/econ_service.dart';
import 'package:quickmed/util/constant.dart';

class EconsultantWidget extends StatefulWidget {
  const EconsultantWidget({Key? key}) : super(key: key);

  @override
  State<EconsultantWidget> createState() => _EconsultantWidgetState();
}

class _EconsultantWidgetState extends State<EconsultantWidget> {
  String statusText = 'Now offline';
  bool isEconsultantActive = false;
  int _pageIndex = 0;
  late PageController _pageController;
  var scaffoldState = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _pageIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void onPageChanged(int page) {
    setState(() {
      _pageIndex = page;
    });
  }

  void navigationTapped(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.ease,
    );
  }

  @override
  Widget build(BuildContext context) {
    return 
          // Home Screen
          DraggableScrollableSheet(
            initialChildSize: 0.3,
            minChildSize: 0.3,
            maxChildSize: 0.5,
            builder: (BuildContext context, myscrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.shade100,
                      offset: const Offset(3, 2),
                      blurRadius: 7,
                    ),
                  ],
                ),
                child: ListView(
                  controller: myscrollController,
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (isEconsultantActive) {
                              econIsOffline();
                              statusText = 'Now offline';
                            } else {
                              econIsNowOnline();
                              statusText = 'Now online';
                            }
                            isEconsultantActive = !isEconsultantActive;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          shape: const RoundedRectangleBorder(),
                          minimumSize: const Size(double.infinity, 50),
                          backgroundColor: COLOR_ACCENT,
                        ),
                        child: Text(
                          isEconsultantActive ? 'Online' : statusText,
                          style: const TextStyle(color: COLOR_BACKGROUND),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'images/online.png',
                        width: 50,
                        height: 50,
                      ),
                    ),
                  ],
                ),
              );
            },
          );


    //   Positioned(
    //     bottom: 0,
    //         left: 0,
    //         right: 0,
    //     child: BottomNavigationBar(
    //   items: const <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: 'Home',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.wallet),
    //       label: 'Wallet',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.local_hospital),
    //       label: 'Treatment',
    //     ),
    //   ],
    //   selectedItemColor: Colors.blue,
    //   onTap: navigationTapped,
    //   currentIndex: _pageIndex,
    // ),
      
    //   )
      
      
      

      
      
      
    

    
    // bottomNavigationBar: BottomNavigationBar(
    //   items: const <BottomNavigationBarItem>[
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.home),
    //       label: 'Home',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.wallet),
    //       label: 'Wallet',
    //     ),
    //     BottomNavigationBarItem(
    //       icon: Icon(Icons.local_hospital),
    //       label: 'Treatment',
    //     ),
    //   ],
    //   selectedItemColor: Colors.blue,
    //   onTap: navigationTapped,
    //   currentIndex: _pageIndex,
    // ),
  }

  // Add your econIsNowOnline and econIsOffline functions here
  void econIsNowOnline() async {
    EconsultantServices services = EconsultantServices();
    services.updateActiveStatus(true);
  }

  void econIsOffline() {
    EconsultantServices services = EconsultantServices();
    services.updateActiveStatus(false);
  }
}
