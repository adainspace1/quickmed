// ignore_for_file: prefer_const_constructors, deprecated_member_use, duplicate_ignore, use_build_context_synchronously, sort_child_properties_last

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quickmed/component/util.dart';
import 'package:quickmed/controller/storage.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/screen/user/dashboard/user_home_screen.dart';
import 'package:quickmed/model/user/user_model.dart';
import 'package:quickmed/service/user/user_service.dart';
import 'package:quickmed/util/constant.dart';

class UserForm extends StatefulWidget {
  const UserForm({super.key});

  @override
  State<UserForm> createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  var currentUser = FirebaseAuth.instance.currentUser;

  // name textcontroller
  final nameTextEditingController = TextEditingController();
  // email textcontroller
  final emailTextEditingController = TextEditingController();
  // bloodgroup text controller
  final bloodGroupTextEditingController = TextEditingController();
  // addresstextcontroller
  final addressTextEditingController = TextEditingController();
  // NiN textcontroller
  final ninTextEditingController = TextEditingController();
  //gender
  final genotypeTextEditingController = TextEditingController();
  //next of kin
  final nextOfKinTextEditingController = TextEditingController();
  //address of next of kin
  final addressOfNextOfKinTextEditingController = TextEditingController();
  //height
  final heightTextEditingController = TextEditingController();
  //data of birth
  final dateOfBirthTextEditingController = TextEditingController();
  // weight
  final weightTextEditingController = TextEditingController();
  //gender
  final genderTextEditingController = TextEditingController();

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
          SnackBar(
            backgroundColor: red,
            content: Text('Please select a profile photo.'),
            duration: Duration(seconds: 2),
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
          addressTextEditingController.text.isEmpty ||
          bloodGroupTextEditingController.text.isEmpty ||
          ninTextEditingController.text.isEmpty ||
          genotypeTextEditingController.text.isEmpty ||
          nextOfKinTextEditingController.text.isEmpty ||
          addressOfNextOfKinTextEditingController.text.isEmpty ||
          heightTextEditingController.text.isEmpty ||
          weightTextEditingController.text.isEmpty ||
          genderTextEditingController.text.isEmpty) {
        // Display an error message or handle the empty fields as needed
        // For now, we'll just return without further processing
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      var user = firebaseAuth.currentUser;
      if (user != null) {
        // Upload image to Firebase Storage
        String photoUrl = await StorageMethod().uploadImageToStorage(
            'user_profile_images/${user.uid}.jpg', _image!, false);

        UserModel user1 = UserModel(
            id: currentUser?.uid,
            name: nameTextEditingController.text.trim(),
            email: emailTextEditingController.text.trim(),
            address: addressTextEditingController.text.trim(),
            nin: ninTextEditingController.text.trim(),
            genotype: genotypeTextEditingController.text.trim(),
            nextOfKin: nextOfKinTextEditingController.text.trim(),
            addressOfKin: addressOfNextOfKinTextEditingController.text.trim(),
            height: heightTextEditingController.text.trim(),
            weight: weightTextEditingController.text.trim(),
            phone: currentUser?.phoneNumber,
            bloodGroup: bloodGroupTextEditingController.text.trim(),
            profileImageUrl: photoUrl,
            gender: genderTextEditingController.text.trim());

        await UserDataBaseServices.addUserToDatabase(user1);
      }
      changeScreenReplacement(context, UserHomeScreen());
    } else {
      // Validation failed, handle it as needed
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  Uint8List? _image;
  String? selectedGender; //add a variable to store selecte gender

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
          padding: EdgeInsets.fromLTRB(15, 20, 15, 50),
          children: [
            Column(
              children: [
                SizedBox(
                  height: 20,
                ),
                _image != null
                    ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                    : CircleAvatar(
                        radius: 55,
                        backgroundImage: NetworkImage(
                            "https://res.cloudinary.com/damufjozr/image/upload/v1703326116/imgbin_computer-icons-avatar-user-login-png_t9t5b9.png"),
                      ),
                Positioned(
                  child: IconButton(
                    onPressed: _selectImage,
                    icon: Icon(Icons.add_a_photo),
                  ),
                  bottom: -10,
                  left: 80,
                ),
                SizedBox(
                  height: 20,
                ),
                Text(
                  "Register",
                  style: TextStyle(color: Colors.black, fontSize: 30),
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
                              decoration: InputDecoration(
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
                            SizedBox(
                              height: 10,
                            ),

                            //   formfield for email
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
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
                            SizedBox(
                              height: 10,
                            ),

                            // date of birth form field
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
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
                                  addressTextEditingController.text = text;
                                });
                              },
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            //blood group form
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(2)
                              ],
                              decoration: InputDecoration(
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
                                  return "Blood Group cannot be empty";
                                }

                                if (text.length < 2) {
                                  return "please enter a valid Blood Group";
                                }
                                if (text.length > 2) {
                                  return "please enter a valid Blood Group";
                                }
                                if (text == text.toLowerCase()) {
                                  return "blood group must be in UpperCase";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  bloodGroupTextEditingController.text = text;
                                });
                              },
                            ),

                            SizedBox(
                              height: 20,
                            ),
                            // nin form field
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
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
                                  return "NIN must be 11 numbers";
                                }

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  ninTextEditingController.text = text;
                                });
                              },
                            ),

                            SizedBox(
                              height: 10,
                            ),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5)
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Weight",
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
                                  return "Weight cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  weightTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // genotype
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(3)
                              ],
                              decoration: InputDecoration(
                                hintText: "Genotype",
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
                                  return "Genotype cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  genotypeTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // height
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(5)
                              ],
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: "Height",
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
                                  return "Height cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  heightTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            // next of kin
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Next Of Kin ",
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
                                  return "Next of Kin cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  nextOfKinTextEditingController.text = text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
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
                            // address of next of kin
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(100)
                              ],
                              decoration: InputDecoration(
                                hintText: "Next Of Kin Address",
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
                                  return "Next Of Kin Address cannot be empty";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  addressOfNextOfKinTextEditingController.text =
                                      text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: COLOR_ACCENT,
                                    shape: RoundedRectangleBorder(),
                                    minimumSize: Size(double.infinity, 50)),
                                onPressed: () {
                                  _submit();
                                },
                                child: _isSubmitting
                                    ? CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Colors.white),
                                      )
                                    : Text(
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
