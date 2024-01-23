import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/provider/ambulance/ambulance_user_provider.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/stars.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart' as model;


class AmbulanceProfileScreen extends StatefulWidget {
  const AmbulanceProfileScreen({
    super.key,
  });

  @override
  State<AmbulanceProfileScreen> createState() => _AmbulanceProfileScreenState();
}

class _AmbulanceProfileScreenState extends State<AmbulanceProfileScreen> {

  @override
  void initState() {
    super.initState();
    addData();

  }

  addData() async {
    AmbulanceProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();

  }

  @override
  Widget build(BuildContext context) {
  model.DriverModel? user = Provider.of<AmbulanceProvider>(context).getUser;
  
       return Scaffold(
        appBar: AppBar(
          title: const Text(
            "profile",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: COLOR_ACCENT,
        ),
        body: buildProfile(context, user!));
  }
}

Widget buildProfile(BuildContext context, DriverModel user) {
  return CustomScaffold(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              margin: const EdgeInsets.all(10.0),
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(user.profileImageUrl ?? ""),
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 25.0, 20.0),
                child:
                     StarsWidget(numberOfStars: user.rating!)),
          ],
        ),

        const Expanded(
          flex: 5,
          child: SizedBox(
            height: 10,
          ),
        ),
        Expanded(
          flex: 40,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.fromLTRB(60.0, 60.0, 25.0, 20.0),
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                )),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Basic Detalis",
                    style: customBoldTextStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    'Name: ${user.name ?? ''}',
                    style: customGoogleFontStyle,
                  ),

                  const SizedBox(height: 10),
                  // Display user name
                  Text(
                    'Email: ${user.email ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(height: 10),
                  // Display user email
                  Text(
                    'AccountType: ${user.accountType ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(height: 10),

                  Text(
                    'PhoneNumber: ${user.phone ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                              
                  Text(
                    'Car Type: ${user.carType ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  
                  Text(
                    'Car Color: ${user.color ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  
                  Text(
                    'Company Address: ${user.companyAddress ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),                
                  Text(
                    'Company Email: ${user.companyEmail ?? ''}',
                    style: customGoogleFontStyle,
                  ),

                const SizedBox(height: 10,),
                  Text(
                    'Company Reg Number: ${user.companyRegNumber ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),           
                  Text(
                    'Company PhoneNumber: ${user.companyPhoneNumber ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  Divider(),
                  Column(
                    children: [
                      const Text("uploaded Front View of Company"),
                      const SizedBox(height: 10,),
                      Image.network(user.uploadFrontViewOfCompany ?? ""),

                      const SizedBox(height: 20,),
                      const Text("uploaded Medical Licence"),
                      const SizedBox(height: 10,),
                      Image.network(user.uploadMedicalLicense ?? ""),
                      const SizedBox(height: 20,),

                      const Text("uploaded proof address"),
                      const SizedBox(height: 10,),
                      Image.network(user.uploadProofOfAddress ?? ""),
                    ],
                  )
             
                ],
              ),
            ),
          ),
        ),

        // Add more details as needed
      ],
    ),
  );
}

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_BLUE,
      extendBody: true,
      body: Stack(
        children: [SafeArea(child: child!)],
      ),
    );
  }
}


