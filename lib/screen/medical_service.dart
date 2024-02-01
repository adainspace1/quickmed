import 'package:flutter/material.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/screen/ambulance/ambulance_form/ambulance_form.dart';
import 'package:quickmed/screen/e-consultant/e-conform/e-consultantForm.dart';

class MedicalServiceScreen extends StatefulWidget {
  const MedicalServiceScreen({super.key});

  @override
  State<MedicalServiceScreen> createState() => _MedicalServiceScreenState();
}

class _MedicalServiceScreenState extends State<MedicalServiceScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
        body: Center(
      child: CardWidget(),
    ));
  }
}

class CardWidget extends StatelessWidget {
  const CardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text(
            "Account Type",
            style: TextStyle(color: Colors.blue),
          )),
          const SizedBox(
            height: 20,
          ),
          CustomCard(
            logo:
                'https://res.cloudinary.com/damufjozr/image/upload/v1701761216/pers_jfroff.png', // Replace with the path to your logo image
            text: 'E-consultant',

            onPress: () {
              changeScreenReplacement(context, const EconsultantForm());
            },
          ),
          const SizedBox(height: 16.0),
          CustomCard(
              logo:
                  'https://res.cloudinary.com/damufjozr/image/upload/v1701761462/hos2_qtpkzs.png', // Replace with the path to your logo image
              text: 'Hospital',
              onPress: () {}),
          const SizedBox(height: 16.0),
          CustomCard(
              logo:
                  'https://res.cloudinary.com/damufjozr/image/upload/v1701760812/amb2_gpa3lp.jpg', // Replace with the path to your logo image
              text: 'Ambulance',
              onPress: () {
                changeScreenReplacement(context, const AmbulanceForm());
              }),
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  final String logo;
  final String text;
  final VoidCallback onPress;

  const CustomCard(
      {super.key,
      required this.logo,
      required this.text,
      required this.onPress}
      );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onPress,
        child: Card(
          elevation: 4.0,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 150,
                  height: 100,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(shape: BoxShape.circle),
                  child: Image.network(
                    logo,
                    height: 80.0,
                    width: 40,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  text,
                  style: const TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ));
  }
}
