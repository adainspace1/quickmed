import 'package:flutter/material.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/screen/medical_service.dart';
import 'package:quickmed/screen/user/userform.dart';

class AccountSelect extends StatefulWidget {
  const AccountSelect({super.key});

  @override
  State<AccountSelect> createState() => _AccountSelectState();
}

class _AccountSelectState extends State<AccountSelect> {
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

  Future<void> accountType() async {
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20.0, 16.0, 20.0, 8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Center(
              child: Text(
            "Select Account Type",
            style: TextStyle(color: Colors.blue),
          )),
          const SizedBox(
            height: 20,
          ),
          CustomCard(
            logo:
                'https://res.cloudinary.com/damufjozr/image/upload/v1703326116/imgbin_computer-icons-avatar-user-login-png_t9t5b9.png', // Replace with the path to your logo image
            text: 'User',
            onPress: () {
              accountType();
              changeScreen(context, const UserForm());
            },
          ),
          const SizedBox(
            height: 40,
          ),
          CustomCard(
            logo:
                'https://res.cloudinary.com/damufjozr/image/upload/v1701804678/useraccount_lhxmmx.png', // Replace with the path to your logo image
            text: 'Medical Service\n     Providers',
            onPress: () {
              changeScreen(context, const MedicalServiceScreen());
            },
          )
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
      required this.onPress});

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
                    width: 140,
                  ),
                ),
                const SizedBox(height: 16.0),
                Text(
                  text,
                  style: const TextStyle(fontSize: 16.0, fontFamily: 'Lato'),
                ),
              ],
            ),
          ),
        ));
  }
}
