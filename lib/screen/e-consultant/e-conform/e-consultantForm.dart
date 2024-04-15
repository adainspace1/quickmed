// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickmed/component/util.dart';
import 'package:quickmed/controller/storage.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';
import 'package:quickmed/screen/e-consultant/dashboard/econ_homeScreen.dart';
import 'package:quickmed/service/econsultant/econ_service.dart';
import 'package:quickmed/util/constant.dart';

class EconsultantForm extends StatefulWidget {
  const EconsultantForm({super.key});

  @override
  State<EconsultantForm> createState() => _EconsultantFormState();
}

class _EconsultantFormState extends State<EconsultantForm> {
  var currentUser = FirebaseAuth.instance.currentUser;

  // name textcontroller
  final nameTextEditingController = TextEditingController();
  // email textcontroller
  final emailTextEditingController = TextEditingController();

  // medical field textcontroller
  final medicalFieldTextEditingController = TextEditingController();

  //bloodGroup textcontroller
  final bloodGroupTextEditingController = TextEditingController();

  //nin text controller
  final ninTextEditingController = TextEditingController();

  //geder text controller
  final genderTextEditingController = TextEditingController();

  //date of birth controller
  final dobTextEditingController = TextEditingController();

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

      // Check if the profile photo is empty
      if (_image == null) {
        // Show a Snackbar message if profile photo is empty
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: red,
            content: Text('Please select a profile photo.'),
            duration: Duration(seconds: 3),
          ),
        );

        setState(() {
          _isSubmitting = false;
        });

        return;
      }

      // Check if any field is empty
      if (nameTextEditingController.text.isEmpty ||
          emailTextEditingController.text.isEmpty ||
          medicalFieldTextEditingController.text.isEmpty ||
          bloodGroupTextEditingController.text.isEmpty ||
          ninTextEditingController.text.isEmpty ||
          genderTextEditingController.text.isEmpty ||
          dobTextEditingController.text.isEmpty) {
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      var user = firebaseAuth.currentUser;
      if (user != null) {
        String photoUrl = await StorageMethod().uploadImageToStorage(
            'econsultant_profile_images/${user.uid}.jpg', _image!, false);

        EconsultantModel user1 = EconsultantModel(
            name: nameTextEditingController.text.toString(),
            email: emailTextEditingController.text.toString(),
            medicalField: medicalFieldTextEditingController.text.toString(),
            id: user.uid,
            phone: user.phoneNumber,
            profileImage: photoUrl,
            gender: genderTextEditingController.text.toString(),
            nin: ninTextEditingController.text.toString(),
            bloodGroup: bloodGroupTextEditingController.text.toString(),
            dob: dobTextEditingController.text.toString());

        await EconsultantServices.addUserToDatabase(user1);
        await EconsultantServices.addtoRealtime(user1);
      }
      // ignore: use_build_context_synchronously
      changeScreenReplacement(context, const EconsultantHomeScreen());
    } else {
      // Validation failed, handle it as needed
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: red,
          content: Text('Registration Failed please try again.'),
          duration: Duration(seconds: 2),
        ),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  Uint8List? _image;
  String? selectedGender; //add a variable to store selecte gender
  DateTime? selectedDate; // Add a variable to store the selected date

  // function to show date picker
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        dobTextEditingController.text =
            "${picked.year}-${picked.month}-${picked.day}";
      });
    }
  }

  //function to handle selected images
  void _selectImage() async {
    Uint8List? img = await pickImage(ImageSource.gallery, context);

    setState(() {
      _image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: ListView(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 50),
          children: [
            Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
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
                  bottom: -10,
                  left: 80,
                  child: IconButton(
                    onPressed: _selectImage,
                    icon: const Icon(Icons.add_a_photo),
                  ),
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
                                  nameTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            //   formfield for email
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
                                  emailTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: const InputDecoration(
                                hintText:
                                    "Select Medical Field eg doctor, nurse, dentis etc",
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
                                  return "Medical Field cannot be empty";
                                }

                                if (text.length < 2) {
                                  return "please enter a valid Medical Field";
                                }

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  medicalFieldTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //blood group fprm field.........
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2)
                              ],
                              decoration: const InputDecoration(
                                hintText: "Blood Group",
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
                                  return "Blood Group Field cannot be empty";
                                }

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  bloodGroupTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            //nin form field
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "NIN",
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
                                  return "NIN cannot be empty";
                                }
                                if (text.length < 11) {
                                  return "NIN must be 11 charaters";
                                }

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  ninTextEditingController.text = text;
                                });
                              },
                            ),

                            //gender form field..........
                            DropdownButtonFormField<String>(
                              value: selectedGender,
                              hint: const Text('Select Gender'),
                              items: ['Male', 'Female', 'Other'].map((gender) {
                                return DropdownMenuItem<String>(
                                  value: gender,
                                  child: Text(gender),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedGender = value;
                                  genderTextEditingController.text =
                                      value ?? '';
                                });
                              },
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please select a gender';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                              readOnly: true,
                              controller: dobTextEditingController,
                              decoration: const InputDecoration(
                                hintText: "Date of Birth",
                                hintStyle: TextStyle(color: Colors.grey),
                                filled: true,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      width: 0, style: BorderStyle.none),
                                ),
                              ),
                              onTap: () => _selectDate(context),
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
