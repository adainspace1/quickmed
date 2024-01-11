import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickmed/component/util.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/screen/ambulance/ambulance_googlemap_homescreen.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:quickmed/util/constant.dart';

class AmbulanceForm extends StatefulWidget {
  const AmbulanceForm({super.key});

  @override
  State<AmbulanceForm> createState() => _AmbulanceFormState();
}

class _AmbulanceFormState extends State<AmbulanceForm> {
  var currentUser = FirebaseAuth.instance.currentUser;

  // AmbulanceDetails form controller
  final carTypeTextEditingController = TextEditingController();
  final colorTextEditingController = TextEditingController();
  final plateNumberTextEditingController = TextEditingController();

  // CompanyDetails text controllers
  final companyNameTextEditingController = TextEditingController();
  final companyEmailTextEditingController = TextEditingController();
  final companyPhoneNumberTextEditingController = TextEditingController();
  final companyRegNumberTextEditingController = TextEditingController();
  final companyAddressTextEditingController = TextEditingController();

  // Document
  final uploadMedicalLicenseTextEditingController = TextEditingController();
  final uploadClearProofAddressTextEditingController = TextEditingController();
  final uploadFrontViewOfCompanyTextEditingController = TextEditingController();

  // DriverDetails
  final nameTextEditingController = TextEditingController();
  final emailTextEditingController = TextEditingController();
  final ninTextEditingController = TextEditingController();
  final addressTextEditingController = TextEditingController();

  int _index = 0;

  // i declear a bool for the circular indicator
  bool _isSubmitting = false;

  // declear a global key
  final _formKey = GlobalKey<FormState>();

  // function to handle submit
  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // set the state for the progress
      setState(() {
        _isSubmitting = true;
      });

      // Check if any field is empty
      if (nameTextEditingController.text.isEmpty ||
          emailTextEditingController.text.isEmpty ||
          addressTextEditingController.text.isEmpty ||
          companyNameTextEditingController.text.isEmpty ||
          companyAddressTextEditingController.text.isEmpty ||
          companyEmailTextEditingController.text.isEmpty ||
          companyPhoneNumberTextEditingController.text.isEmpty ||
          companyRegNumberTextEditingController.text.isEmpty ||
          carTypeTextEditingController.text.isEmpty ||
          colorTextEditingController.text.isEmpty ||
          plateNumberTextEditingController.text.isEmpty||
          ninTextEditingController.text.isEmpty
          ) {
        // Display an error message or handle the empty fields as needed
       
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      DriverModel? user;
      if (user!.id != null) {
        // Upload image to Firebase Storage
        String imagePath = 'ambulance_profile_images/${user.name}.jpg';

        firebase_storage.Reference storageReference =
            firebase_storage.FirebaseStorage.instance.ref().child(imagePath);

        firebase_storage.UploadTask uploadTask =
            storageReference.putData(_image! as Uint8List);
        await uploadTask.whenComplete(() => null);

        String imageUrl = await storageReference.getDownloadURL();

        DriverModel user1 = DriverModel(
          id: currentUser?.uid,
          companyName: companyNameTextEditingController.text.trim(),
          companyAddress: companyAddressTextEditingController.text.trim(),
          companyEmail: companyEmailTextEditingController.text.trim(),
          companyRegNumber: companyRegNumberTextEditingController.text.trim(),
          carType: carTypeTextEditingController.text.trim(),
          color: colorTextEditingController.text.trim(),
          plateNumber: plateNumberTextEditingController.text.trim(),
          companyPhoneNumber: companyPhoneNumberTextEditingController.text.trim(),
          name: nameTextEditingController.text.trim(),
          email: emailTextEditingController.text.trim(),
          nin: ninTextEditingController.text.trim(),
          profileImageUrl: imageUrl,
        );

        await DatabaseService.addUserToDatabase(user1);
      }
      // ignore: use_build_context_synchronously
      changeScreenReplacement(context, const AmbulanceGoogleMapScreen());
    } else {
      // Validation failed, handle it as needed
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  //Uint8List? _image;
  List<Uint8List>? _image;

  //function to handle selected images
  // ignore: unused_element
  void _selectImage() async {
    List<Uint8List>? img = await pickImage(ImageSource.gallery, context);

    setState(() {
      _image = img;
    });
  }

  Widget getTextFormWidget(
      TextEditingController textController, String customHintText) {
    return TextFormField(
      controller: textController,
      autofocus: true,
      obscureText: false,
      decoration: InputDecoration(
        hintText: customHintText,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: COLOR_BACKGROUND_DARK,
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(
            color: Color(0x00000000),
            width: 1,
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(4.0),
            topRight: Radius.circular(4.0),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: _formKey,
        child: Stepper(
          type: StepperType.vertical,
          currentStep: _index,
          onStepCancel: () {
            if (_index > 0) {
              setState(() {
                _index -= 1;
              });
            }
          },
          onStepContinue: () {
            if (_index <= 0) {
              setState(() {
                _index += 1;
              });
            }
          },
          onStepTapped: (int index) {
            setState(() {
              _index = index;
            });
          },
          steps: <Step>[
            // Ambulance Details
            Step(
              title: const Text('AmbulanceDetails'),
              content: Column(children: [
                getTextFormWidget(carTypeTextEditingController, 'Car Type'),
                getTextFormWidget(colorTextEditingController, 'color'),
                getTextFormWidget(
                    plateNumberTextEditingController, 'Plate Number'),
              ]),
            ),
            Step(
              title: const Text('Document'),
              content: Column(
                children: [
                  getTextFormWidget(uploadMedicalLicenseTextEditingController,
                      'Upload Medical License'),
                  getTextFormWidget(uploadClearProofAddressTextEditingController,
                      'Upload a clear proof of Address'),
                  getTextFormWidget(uploadFrontViewOfCompanyTextEditingController,
                      'Front View of Company'),
                ],
              ),
            ),
            Step(
              title: const Text('DriverDetails'),
              content: Column(
                children: [
                  getTextFormWidget(nameTextEditingController, 'name'),
                  getTextFormWidget(emailTextEditingController, 'Email'),
                  getTextFormWidget(ninTextEditingController, 'NIN'),
                  getTextFormWidget(addressTextEditingController, 'Address'),
                ],
              ),
            ),
            Step(
              title: const Text('CompanyDetails'),
              content: Column(
                children: [
                  getTextFormWidget(
                      companyNameTextEditingController, 'Company name'),
                  getTextFormWidget(
                      companyEmailTextEditingController, 'company Email'),
                  getTextFormWidget(companyPhoneNumberTextEditingController,
                      'company PhoneNumber'),
                  getTextFormWidget(companyRegNumberTextEditingController,
                      'company Registration Number'),
                  getTextFormWidget(
                    companyAddressTextEditingController,
                    'company Address',
                  ),
                  ElevatedButton(
                    onPressed: _submit,
                    child: _isSubmitting
                          ? const CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation<Color>(                                                 Colors.white),
                                       )
                                      : const Text("Register",
                                          style: TextStyle(
                                              fontSize: 20, color: Colors.white),
                    )),
                    
                  
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         FocusScope.of(context).unfocus();
//       },
//       child: Scaffold(
//         body: ListView(
//           padding: EdgeInsets.fromLTRB(15, 20, 15, 50),
//           children: [
//             Column(
//               children: [
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Row(
//                   children: [
//                     _image != null
//                         ? CircleAvatar(
//                             radius: 64,
//                             backgroundImage: MemoryImage(_image! as Uint8List),
//                           )
//                         : CircleAvatar(
//                             radius: 55,
//                             backgroundImage: NetworkImage(
//                                 "https://res.cloudinary.com/damufjozr/image/upload/v1703326116/imgbin_computer-icons-avatar-user-login-png_t9t5b9.png"),
//                           ),
//                     Positioned(
//                       child: IconButton(
//                         onPressed: _selectImage,
//                         icon: Icon(Icons.add_a_photo),
//                       ),
//                       bottom: -5,
//                       left: 80,
//                     ),
//                     _image != null
//                         ? CircleAvatar(
//                             radius: 64,
//                             backgroundImage: MemoryImage(_image! as Uint8List),
//                           )
//                         : CircleAvatar(
//                             radius: 55,
//                             backgroundImage: NetworkImage(
//                                 "https://res.cloudinary.com/damufjozr/image/upload/v1703326116/imgbin_computer-icons-avatar-user-login-png_t9t5b9.png"),
//                           ),
//                     Positioned(
//                       child: IconButton(
//                         onPressed: _selectImage,
//                         icon: Icon(Icons.add_a_photo),
//                       ),
//                       bottom: -5,
//                       left: 80,
//                     ),
//                   ],
//                 ),
//                 SizedBox(
//                   height: 20,
//                 ),
//                 Text(
//                   "Register",
//                   style: TextStyle(color: Colors.blue, fontSize: 30),
//                 ),
//                 Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Form(
//                         key: _formKey,
//                         child: Column(
//                           mainAxisAlignment: MainAxisAlignment.center,
//                           crossAxisAlignment: CrossAxisAlignment.center,
//                           children: [
//                             //full name form field
//                             TextFormField(
//                               inputFormatters: [
//                                 LengthLimitingTextInputFormatter(50)
//                               ],
//                               decoration: InputDecoration(
//                                 hintText: "Full name",
//                                 hintStyle: TextStyle(color: Colors.grey),
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         width: 0, style: BorderStyle.none)),
//                               ),
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: (text) {
//                                 if (text == null || text.isEmpty) {
//                                   return "Name cannot be empty";
//                                 }
//                                 if (text.length < 2) {
//                                   return "please enter a valid full name";
//                                 }
//                                 if (text.length > 50) {
//                                   return "please enter a valid name";
//                                 }
//                                 return null;
//                               },
//                               onChanged: (text) {
//                                 setState(() {
//                                   nameTextEditingController.text = text;
//                                 });
//                               },
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),

//                             // formfield for email
//                             TextFormField(
//                               inputFormatters: [
//                                 LengthLimitingTextInputFormatter(100)
//                               ],
//                               decoration: InputDecoration(
//                                 hintText: "Email",
//                                 hintStyle: TextStyle(color: Colors.grey),
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         width: 0, style: BorderStyle.none)),
//                               ),
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: (text) {
//                                 if (text == null || text.isEmpty) {
//                                   return "Email cannot be empty";
//                                 }

//                                 if (text.length < 2) {
//                                   return "please enter a valid Email";
//                                 }
//                                 if (text.length > 50) {
//                                   return "please enter a valid Email";
//                                 }
//                                 return null;
//                               },
//                               onChanged: (text) {
//                                 setState(() {
//                                   emailTextEditingController.text = text;
//                                 });
//                               },
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),

//                             // date of birth form field
//                             TextFormField(
//                               inputFormatters: [
//                                 LengthLimitingTextInputFormatter(100)
//                               ],
//                               decoration: InputDecoration(
//                                 hintText: "Address",
//                                 hintStyle: TextStyle(color: Colors.grey),
//                                 filled: true,
//                                 border: OutlineInputBorder(
//                                     borderSide: BorderSide(
//                                         width: 0, style: BorderStyle.none)),
//                               ),
//                               autovalidateMode:
//                                   AutovalidateMode.onUserInteraction,
//                               validator: (text) {
//                                 if (text == null || text.isEmpty) {
//                                   return "Address cannot be empty";
//                                 }
//                                 if (text.length < 2) {
//                                   return "please enter a valid Address";
//                                 }
//                                 if (text.length > 50) {
//                                   return "please enter a valid Address";
//                                 }
//                                 return null;
//                               },
//                               onChanged: (text) {
//                                 setState(() {
//                                   addressTextEditingController.text = text;
//                                 });
//                               },
//                             ),
//                             SizedBox(
//                               height: 10,
//                             ),

//                             ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                     primary: COLOR_ACCENT,
//                                     shape: RoundedRectangleBorder(),
//                                     minimumSize: Size(double.infinity, 50)),
//                                 onPressed: () {
//                                   _submit();
//                                 },
//                                 child: _isSubmitting
//                                     ? CircularProgressIndicator(
//                                         valueColor:
//                                             AlwaysStoppedAnimation<Color>(
//                                                 Colors.white),
//                                       )
//                                     : Text(
//                                         "Register",
//                                         // ignore: prefer_const_constructors
//                                         style: TextStyle(
//                                             fontSize: 20, color: Colors.white),
//                                       ))
//                           ],
//                         )),
//                   ],
//                 )
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
