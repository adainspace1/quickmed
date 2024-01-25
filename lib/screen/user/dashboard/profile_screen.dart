import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/provider/user/user_provider.dart';
import 'package:quickmed/service/user/user_service.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/model/user/user_model.dart' as model;

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameTextEditingController = TextEditingController();


  UserDataBaseServices services = UserDataBaseServices();

  @override
  void initState() {
    super.initState();
    addData();
  }

  addData() async {
    UserProvider userProvider = Provider.of(context, listen: false);
    await userProvider.refreshUser();
  }

  void openBox({String? docId, String? name, String? email}) {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: TextField(
                controller: nameTextEditingController,
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    services.updateData(
                        docId!, nameTextEditingController.text,);
                    Navigator.pop(context);
                  },
                  child: const Text("Update"),
                )
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    model.UserModel? user = Provider.of<UserProvider>(context).getUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "profile",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: COLOR_ACCENT,
      ),
      //body: buildProfile(context, user!)
      body: CustomScaffold(
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  margin: const EdgeInsets.all(10.0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: NetworkImage(user?.profileImageUrl ?? ""),
                  ),
                ),
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
                      ListTile(
                        trailing: IconButton(
                          onPressed: () => openBox(docId: user?.id),
                          icon: const Icon(Icons.edit),
                        ),
                      ),

                      Text(
                        "Basic Detalis",
                        style: customBoldTextStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Name: ${user?.name ?? ''}',
                        style: customGoogleFontStyle,
                      ),

                      const SizedBox(height: 10),
                      // Display user name
                      Text(
                        'Email: ${user?.email ?? ''}',
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(height: 10),
                      // Display user email
                      Text(
                        'AccountType: ${user?.accountType ?? ''}',
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'AccountType: ${user?.gender ?? ''}',
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(height: 10),

                      Text(
                        'PhoneNumber: ${user?.phone ?? ''}',
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Next Of Kin: ${user?.nextOfKin}",
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Address Of Kin: ${user?.addressOfKin}",
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Medical Detalis",
                        style: customBoldTextStyle,
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'BloodGroup: ${user?.bloodGroup ?? ''}',
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Genotype: ${user?.genotype}",
                        style: customGoogleFontStyle,
                      ),

                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Weight: ${user?.weight}",
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        "Height: ${user?.height}",
                        style: customGoogleFontStyle,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
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
