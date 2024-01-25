import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';
import 'package:quickmed/provider/econsultant/econ_user.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/stars.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart' as model;

class EconsultantProfileScreen extends StatefulWidget {
  const EconsultantProfileScreen({
    super.key,
  });

  @override
  State<EconsultantProfileScreen> createState() =>
      _EconsultantProfileScreenState();
}

class _EconsultantProfileScreenState extends State<EconsultantProfileScreen>
    with SingleTickerProviderStateMixin {
  //updating editing controller
  final updateTextEditingController = TextEditingController();
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    EconsultantProvider econsultantProvider =
        Provider.of(context, listen: false);
    await econsultantProvider.refreshUser();
  }

  void openBox() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: updateTextEditingController,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    model.EconsultantModel? user =
        Provider.of<EconsultantProvider>(context).getUser;

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

Widget buildProfile(BuildContext context, EconsultantModel user) {
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
                backgroundImage: NetworkImage(user.profileImage ?? ""),
              ),
            ),
            Container(
                padding: const EdgeInsets.fromLTRB(20.0, 20.0, 25.0, 20.0),
                child: StarsWidget(numberOfStars: user.rating!)),
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
                  // Display user name
                  Text(
                    'MedicalField: ${user.medicalField ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(height: 10),
                  // Display user name
                  Text(
                    'Account Type: ${user.accontType ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Gender: ${user.gender ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Blood Group: ${user.bloodGroup ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'NiN: ${user.nin ?? ''}',
                    style: customGoogleFontStyle,
                  ),

                  const SizedBox(height: 10),
                  Text(
                    'Date of birth: ${user.dob ?? ''}',
                    style: customGoogleFontStyle,
                  ),
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
