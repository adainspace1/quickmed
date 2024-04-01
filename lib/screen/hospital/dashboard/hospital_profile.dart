import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickmed/component/util.dart';
import 'package:quickmed/model/hospital/hospital_model.dart' as model;
import 'package:quickmed/service/hospital/hospital.dart';
import 'package:quickmed/util/constant.dart';


class HospitalProfileScreen  extends StatefulWidget {
  const HospitalProfileScreen ({
    super.key,
  });

  @override
  State<HospitalProfileScreen > createState() => _HospitalProfileScreenState();
}

class _HospitalProfileScreenState extends State<HospitalProfileScreen > {
  final nameTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();


  HospitalServices services = HospitalServices();

  @override
  void initState() {
    super.initState();
  }

    // Function to update profile image
  Future<void> _updateProfileImage(Uint8List file) async {
    try {
      await HospitalServices.updateProfileImage(file);
      // Clear the image after a successful update
      setState(() {
        _image = null;
      });
    } catch (e) {
      // Handle any errors
      
    }
  }


  Uint8List? _image;

// Function to handle selected images
Future<void> _selectImage() async {
  Uint8List? img = await pickImage(ImageSource.gallery, context);

  if (img != null) {
    setState(() {
      _image = img;
    });

    // Update profile image after image selection
    await _updateProfileImage(_image!);
  }
}

 void openBox({String? docId, String? name, String? email, String? phoneNumber}) {
 

  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text("Edit Your Basic Details"),
      content: Column(
        children: [
          TextField(
            controller: nameTextEditingController,
            decoration: const InputDecoration(labelText: "Name"),
          ),
        
          TextField(
            controller: addressTextEditingController,
            decoration: const InputDecoration(labelText: "address",),
          ),

          TextField(
            controller: emailTextEditingController,
            decoration: const InputDecoration(labelText: "email",),
          ),
        ],
      ),
      actions: [
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: COLOR_ACCENT
          ),
          onPressed: () {
            if (nameTextEditingController.text.isEmpty||
                emailTextEditingController.text.isEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.red,
                  content: Text('All fields are required!'),
                ),
              );
            }else{
                 services.updateData(
              docId!,
              
              nameTextEditingController.text,
              addressTextEditingController.text,
              emailTextEditingController.text
              // Add additional parameters for other fields
            );
            }
                         // Clear the controllers after a successful update
              nameTextEditingController.clear();
              addressTextEditingController.clear();
              emailTextEditingController.clear();
            Navigator.pop(context);
          },
          child: const Text("Update", style: TextStyle(color: COLOR_BACKGROUND),),
        )
      ],
    ),
  );
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "profile",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: COLOR_ACCENT,
        ),
        //body: buildProfile(context, user!)
        body: StreamBuilder<model.HospitalModel>(
          stream: services.getUserStreamByUid(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // If the Future is still running, show a loading indicator
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              // If there's an error, show an error message
              return Text('Error: ${snapshot.error}');
            } else {
              // If the Future is completed successfully, display the user details
              model.HospitalModel? user = snapshot.data;

              return CustomScaffold(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          margin: const EdgeInsets.all(10.0),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage("https://res.cloudinary.com/damufjozr/image/upload/v1701761462/hos2_qtpkzs.png"),
                          ),

                          
                        ),
                         Expanded(
                           child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                             children:[ Positioned(
                              bottom: -20,
                              right: 10,
                              child: IconButton(
                                onPressed: () async {
                                await  _selectImage();
                                },
                                icon: const Icon(Icons.add_a_photo_rounded),
                              ),
                            )],
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
                        padding:
                            const EdgeInsets.fromLTRB(60.0, 60.0, 25.0, 20.0),
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
                                    onPressed: () => openBox(docId: user!.id),
                                    icon: const Icon(Icons.edit_note_rounded, size: 30,),
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
                                'Hospital Name: ${user!.hospitalName ?? ''}',
                                style: customGoogleFontStyle,
                              ),

                              const SizedBox(height: 10),
                              // Display user name
                              Text(
                                'Hospital Email: ${user.hospitalemail ?? ''}',
                                style: customGoogleFontStyle,
                              ),
                              const SizedBox(height: 10),
                              // Display user email
                              Text(
                                'AccountType: ${user.accontType ?? ''}',
                                style: customGoogleFontStyle,
                              ),
                              const SizedBox(
                                height: 10,
                              ),

                              Text(
                    'HospitalReg Number: ${user.hospitalRegNumber ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                              
                  Text(
                    'Hospital Emergency Number: ${user.hospitalEmergencyNumber ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),

                  
                  Text(
                    'Hospital Address: ${user.hospitaladdress ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text('Verified :${user.verified}'),
                  const SizedBox(height: 10,),
                  Text(
                    'Hospital Email: ${user.hospitalemail ?? ''}',
                    style: customGoogleFontStyle,
                  ),
                  const SizedBox(
                    height: 10,
                  ),                
                  Text(
                    'Hospital Onsit Doctor: ${user.onSitDoctor ?? ''}',
                    style: customGoogleFontStyle,
                  ),

                const SizedBox(height: 10,),
                  const Divider(),
                  Column(
                    children: [
                      const Text("uploaded Medical Licence"),
                      const SizedBox(height: 10,),
                      Image.network(user.uploadMedicalLicence ?? ""),
                      const Divider(),

                      const SizedBox(height: 20,),
                      const Text("uploaded Proof Of Address"),
                      const SizedBox(height: 10,),
                      Image.network(user.uploadclearProofofaddress ?? ""),
                      const Divider(),

                      const SizedBox(height: 20,),

                      const Text("uploaded Front View Of Hospital"),
                      const SizedBox(height: 10,),
                      Image.network(user.uploadfrontviewofhospital ?? ""),
                    ],
                  )

                              
                              
                             
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
          },
        ));
  }
}

class CustomScaffold extends StatelessWidget {
  const CustomScaffold({super.key, this.child});
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: COLOR_PRIMARY,
      extendBody: true,
      body: Stack(
        children: [SafeArea(child: child!)],
      ),
    );
  }
}