import 'package:flutter/material.dart';
import 'package:quickmed/service/econsultant/econ_service.dart';
import 'package:quickmed/util/constant.dart';

class EconsultantWidget extends StatefulWidget {
  const EconsultantWidget({super.key});

  @override
  State<EconsultantWidget> createState() => _EconsultantWidgetState();
}

class _EconsultantWidgetState extends State<EconsultantWidget> {
  String statusText = 'Now offline';
  bool isEconsultantActive = false;

  @override
  void initState() {
    super.initState();
  }

  //this function set the online status of the econsultant
  econIsNowOnline() async {
    EconsultantServices services = EconsultantServices();
    services.updateActiveStatus(true);
  }

  //read econsultant current location

  //this makes the econsultant go offline
  econIsOffline() {
    EconsultantServices services = EconsultantServices();
    services.updateActiveStatus(false);
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.3,
      minChildSize: 0.3,
      maxChildSize: 0.5,
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
            Container(
             
              alignment: Alignment.center,
              child: ElevatedButton(
                  onPressed: () {
                    if (isEconsultantActive != true) {
                      econIsNowOnline();
                      setState(() {
                        statusText = "Now online";
                        isEconsultantActive = true;
                      });
                    } else {
                      econIsOffline();
                      setState(() {
                        statusText = "Now offline";
                        isEconsultantActive = false;
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                      shape: const RoundedRectangleBorder(),
                      minimumSize: const Size(double.infinity, 50), 
                                       
                      backgroundColor: COLOR_ACCENT),
                  child: statusText == "Now offline"
                      ? Text(
                          statusText,
                          style: const TextStyle(color: COLOR_BACKGROUND),
                        )
                      : const Text(
                          "Online",
                          style: TextStyle(color: COLOR_BACKGROUND),
                        )),
            ),
            const SizedBox(
              height: 20,
            ),

            Container(
                padding: const EdgeInsets.all(40),
                child: Image.asset(
                  "images/online.png",
                  width: 100,
                  height: 100,
                )),

            const SizedBox(
              height: 20,
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: COLOR_ACCENT,
                        shape: const RoundedRectangleBorder()),
                    onPressed: () {},
                    child: const Text(
                      "Home",
                      style: TextStyle(color: COLOR_BACKGROUND),
                    )),

                const SizedBox(
                  width: 10,
                ),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: COLOR_ACCENT,
                        shape: const RoundedRectangleBorder()),
                    onPressed: () {},
                    child: const Text(
                      "Treatment",
                      style: TextStyle(color: COLOR_BACKGROUND),
                    )),

                const SizedBox(
                  width: 10,
                ),

                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: COLOR_ACCENT,
                        shape: const RoundedRectangleBorder()),
                    onPressed: () {},
                    child: const Text(
                      "Wallet",
                      style: TextStyle(color: COLOR_BACKGROUND),
                    )),
              ],
            )
          ]),
        );
      },
    );
  }
}
