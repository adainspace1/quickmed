import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickmed/component/util.dart';
import 'package:quickmed/util/constant.dart';

class HospitalForm extends StatefulWidget {
  const HospitalForm({super.key});

  @override
  State<HospitalForm> createState() => _HospitalFormState();
}

class _HospitalFormState extends State<HospitalForm> {
  /* all my editing contoller and current user */
  var currentUser = FirebaseAuth.instance.currentUser;

  // hospitalname textcontroller
  final hospitalNameTextEditingController = TextEditingController();
  // hospitalemail textcontroller
  final hospitalEmailTextEditingController = TextEditingController();

  // hospitalRegNumbr  textcontroller
  final hospitalRegNumberTextEditingController = TextEditingController();

  //hospitaladdress textcontroller
  final hospitalAddressTextEditingController = TextEditingController();

  //hospitalEmergencyNumber controller
  final hospitalEmergencyNumberTextEditingController = TextEditingController();

  //onsitDoctor textcontroller
  final onsitDoctorTextEditingController = TextEditingController();

  //boolean variable for the submitted form
  bool _isSubmitting = false;

  // declear a global key
  final _formKey = GlobalKey<FormState>();

  //function to handle submit

  void _submit()async{

  }

  Uint8List? _image;
  Uint8List? _uploadmedicallicence;
  Uint8List? _uploadproofaddress;
  Uint8List? _uploadfrontview;

  //function to handle selected images
  void _selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery, context);

    setState(() {
      _image = img;
    });
  }

  //function to handle medicallicence images
  void _uploadMedicalLicence() async {
    Uint8List? img = await pickImage(ImageSource.gallery, context);

    setState(() {
      _uploadmedicallicence = img;
    });
  }

  //function to handle proofaddress images
  void _uploadProofAddress() async {
    Uint8List? img = await pickImage(ImageSource.gallery, context);

    setState(() {
      _uploadproofaddress = img;
    });
  }

  //function to handle proofaddress images
  void _uploadFrontView() async {
    Uint8List? img = await pickImage(ImageSource.gallery, context);

    setState(() {
      _uploadfrontview = img;
    });
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
          children: [
            Column(
              children: [
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : const CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(
                            "https://res.cloudinary.com/damufjozr/image/upload/v1703326116/imgbin_computer-icons-avatar-user-login-png_t9t5b9.png"),
                      ),
                Positioned(
                  child: IconButton(
                    onPressed: _selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
                  bottom: -10,
                  left: 80,
                ),
                //row containing licenses
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Column(
                            children: [
                              // ignore: sized_box_for_whitespace
                              Container(
                                width: 100,
                                height: 100,
                                child: _uploadmedicallicence != null
                                    ? Image.memory(_uploadmedicallicence!)
                                    : Image.asset("images/cam.jpg",
                                        width: 50, height: 50),
                              ),
                              Positioned(
                                child: IconButton(
                                  onPressed: _uploadMedicalLicence,
                                  icon: const Icon(Icons.add_a_photo),
                                ),
                                bottom: -10,
                                left: 80,
                              ),
                              const Text("upload medicallicence")
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: _uploadproofaddress != null
                                    ? Image.memory(_uploadproofaddress!)
                                    : Image.asset("images/cam.jpg",
                                        width: 50, height: 50),
                              ),
                              Positioned(
                                child: IconButton(
                                  onPressed: _uploadProofAddress,
                                  icon: const Icon(Icons.add_a_photo),
                                ),
                                bottom: -10,
                                left: 80,
                              ),
                              const Text("upload proof of address")
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 20,
                      ),
                      Card(
                        child: Padding(
                          padding:
                              const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 8.0),
                          child: Column(
                            children: [
                              Container(
                                width: 100,
                                height: 100,
                                child: _uploadfrontview != null
                                    ? Image.memory(_uploadfrontview!)
                                    : Image.asset("images/cam.jpg",
                                        width: 50, height: 50),
                              ),
                              Positioned(
                                child: IconButton(
                                  onPressed: _uploadFrontView,
                                  icon: const Icon(Icons.add_a_photo),
                                ),
                                bottom: -10,
                                left: 80,
                              ),
                              const Text("upload front view of company")
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            //full name form field
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: const InputDecoration(
                                hintText: "Full name",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Name cannot be empty";
                                }
                                if (text.length < 2) {
                                  return "please enter a valid full name";
                                }
                                if (text.length > 50) {
                                  return "please enter a valid name";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  hospitalNameTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // formfield for email
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: const InputDecoration(
                                hintText: "Email",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                // Use RegExp for email validation
                                final emailRegex = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                                if (!emailRegex.hasMatch(text)) {
                                  return "Enter a valid email address";
                                }

                                if (text.length < 2) {
                                  return "please enter a valid Email";
                                }
                                if (text.length > 50) {
                                  return "please enter a valid Email";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  hospitalEmailTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            // date of birth form field
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: const InputDecoration(
                                hintText: "Address",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Address cannot be empty";
                                }
                                if (text.length < 2) {
                                  return "please enter a valid Address";
                                }
                                if (text.length > 50) {
                                  return "please enter a valid Address";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  hospitalAddressTextEditingController.text = text;
                                });
                              },
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Hospital Emergency Number",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Hospital Emergency Number cannot be empty";
                                }
                               

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  hospitalEmergencyNumberTextEditingController.text = text;
                                });
                              },
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            // hospitalemail formfield for email
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: const InputDecoration(
                                hintText: "Company email",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        width: 0, style: BorderStyle.none)),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (text) {
                                if (text == null || text.isEmpty) {
                                  return "Email cannot be empty";
                                }
                                // Use RegExp for email validation
                                final emailRegex = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');
                                if (!emailRegex.hasMatch(text)) {
                                  return "Enter a valid email address";
                                }

                                if (text.length < 2) {
                                  return "please enter a valid Email";
                                }
                                if (text.length > 50) {
                                  return "please enter a valid Email";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  hospitalEmailTextEditingController.text = text;
                                });
                              },
                            ),

                            const SizedBox(
                              height: 10,
                            ),   

                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: COLOR_ACCENT,
                                    shape: const RoundedRectangleBorder(),
                                    minimumSize:
                                        const Size(double.infinity, 50)),
                                onPressed: () {
                                  _submit();
                                },
                                child: _isSubmitting
                                    ? const CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : const Text(
                                        "Register",
                                        // ignore: prefer_const_constructors
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ))
                          ],
                        )),
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
