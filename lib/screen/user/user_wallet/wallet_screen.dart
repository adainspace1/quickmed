// ignore_for_file: library_private_types_in_public_api, unused_element

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'package:quickmed/model/user/user_model.dart' as model;
import 'package:quickmed/provider/user/user_appstate.dart';
import 'package:quickmed/util/constant.dart';

class WalletScreen extends StatefulWidget {
  const WalletScreen({Key? key}) : super(key: key);

  @override
  _WalletScreenState createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  final amountTextEditingController = TextEditingController();
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final phoneTextEditingController = TextEditingController();
  //this code is exceuted at the start of the app.....
  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserAppProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  void _fundwallet(
      {String? amount,
      String? name,
      String? email,
      String? phone,
      String? id}) async {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Fund Wallet"),
              content: Column(
                children: [
                  TextField(
                    controller: amountTextEditingController,
                    decoration: const InputDecoration(labelText: "amount"),
                  ),
                  TextField(
                    controller: nameTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "name",
                    ),
                  ),
                  TextField(
                    controller: emailTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "email",
                    ),
                  ),
                  TextField(
                    controller: phoneTextEditingController,
                    decoration: const InputDecoration(
                      labelText: "phone",
                    ),
                  ),
                ],
              ),
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: COLOR_ACCENT,
        title: const Text(
          "Wallet",
          style: TextStyle(color: COLOR_BACKGROUND),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 18, right: 18, top: 34),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(
                height: 30,
              ),
              Text(
                'Account Overview',
                style: customBoldTextStyle,
              ),
              const SizedBox(
                height: 16,
              ),
              _contentOverView(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Send Money', style: customGoogleFontStyle),
                ],
              ),
              const SizedBox(height: 16),
              _contentSendMoney(),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text('Receipt', style: customGoogleFontStyle),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _contentOverView() {
    return Container(
      padding: const EdgeInsets.only(left: 18, right: 18, top: 22, bottom: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('0.0', style: customBoldTextStyle),
              const SizedBox(
                height: 12,
              ),
              Text('Current Balance', style: customGoogleFontStyle)
            ],
          ),
          GestureDetector(
            onTap: () {
              // print("object");
              _fundwallet(id: '1');
            },
            child: Container(
              height: 55,
              width: 55,
              decoration: BoxDecoration(
                color: const Color(0xffFFAC30),
                borderRadius: BorderRadius.circular(80),
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvatarContainer(String label, String avatarAsset) {
    return Card(
      margin: const EdgeInsets.only(right: 10),
      child: Container(
        padding: const EdgeInsets.all(16),
        width: 100,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Theme.of(context).cardColor,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xffD8D9E4)),
              ),
              child: CircleAvatar(
                radius: 22.0,
                backgroundColor: COLOR_BACKGROUND,
                child: ClipOval(
                  child: Image.network(
                    avatarAsset,
                    fit: BoxFit.cover,
                    width: 44.0,
                    height: 44.0,
                  ),
                ),
              ),
            ),
            Text(
              label,
              style: customGoogleFontStyle,
            ),
          ],
        ),
      ),
    );
  }

  Widget _contentSendMoney() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          Container(
            width: 100,
            padding: const EdgeInsets.all(16),
            child: Container(
              height: 100,
              width: 100,
              decoration: const BoxDecoration(
                color: Color(0xffFFAC30),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.add,
                  size: 40,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          _buildAvatarContainer('Josh',
              'https://res.cloudinary.com/damufjozr/image/upload/v1703414009/5172568_add_contact_user_icon_hojgvo.png'),
          _buildAvatarContainer('Ash',
              'https://res.cloudinary.com/damufjozr/image/upload/v1701804678/useraccount_lhxmmx.png'),
          _buildAvatarContainer('Ash',
              'https://res.cloudinary.com/damufjozr/image/upload/v1701804678/useraccount_lhxmmx.png'),
          _buildAvatarContainer('Ash',
              'https://res.cloudinary.com/damufjozr/image/upload/v1701804678/useraccount_lhxmmx.png'),
        ],
      ),
    );
  }
}
