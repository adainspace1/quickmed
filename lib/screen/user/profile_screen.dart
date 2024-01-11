import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/provider/profile_provider.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/widget/stars.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({
    super.key,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize the ProfileProvider and set the current user
    Provider.of<UserProfileProvider>(context, listen: false).initUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("profile", style: TextStyle(color: Colors.white),),
        backgroundColor: COLOR_ACCENT,
      ),
      body: Consumer<UserProfileProvider>(
        builder: (context, profileProvider, child) {
          if (profileProvider.user != null) {
            return FutureBuilder<UserModel?>(
              future: profileProvider.getUserByUid(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return Text("Error ${snapshot.error}");
                  }
                  if (snapshot.data != null) {
                    UserModel user = snapshot.data!;
                    return buildProfile(context, user);
                  }
                }

                return const Center(child: CircularProgressIndicator());
              },
            );
          } else {
            return const Text("No user");
          }
        },
      ),
    );
  }
}

Widget buildProfile(BuildContext context, UserModel user) {
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
          child :const StarsWidget(key: ValueKey<int>(5), numberOfStars: 5)

                    ),
                  ],
              ),
         
    
        const Expanded(
          flex: 5,
          child: SizedBox(height: 10,),
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
                Text("Basic Detalis", style: customBoldTextStyle,),
                      const SizedBox(height: 10,),
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
        const SizedBox(height: 10,),
        Text("Next Of Kin: ${user.nextOfKin}", style:  customGoogleFontStyle,),
        const SizedBox(height: 10,),
        Text("Address Of Kin: ${user.addressOfKin}", style:  customGoogleFontStyle,),
        const SizedBox(height: 20,),
        Text("Medical Detalis", style: customBoldTextStyle,),
        const SizedBox(height: 20),
        Text(
                  'BloodGroup: ${user.bloodGroup ?? ''}',
                  style: customGoogleFontStyle,
                ),
        const SizedBox(height: 10,),
                Text("Genotype: ${user.genotype}", style:  customGoogleFontStyle,),

        const SizedBox(height: 10,),
                Text("Weight: ${user.weight}", style:  customGoogleFontStyle,),
        const SizedBox(height: 10,),
                Text("Height: ${user.height}", style:  customGoogleFontStyle,),
        const SizedBox(height: 10,),


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
        children: [
        
          SafeArea(child: child!)
        ],
      ),
    );
  }
}