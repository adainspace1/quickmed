// ignore_for_file: sort_child_properties_last, unused_field, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/screen/ambulance/ambulance_homescreen.dart';
import 'package:quickmed/screen/ambulance/service/ambulance_service.dart';
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
          ninTextEditingController.text.isEmpty ||
          companyEmailTextEditingController.text.isEmpty ||
          companyNameTextEditingController.text.isEmpty ||
          companyPhoneNumberTextEditingController.text.isEmpty ||
          companyRegNumberTextEditingController.text.isEmpty ||
          companyAddressTextEditingController.text.isEmpty ||
          carTypeTextEditingController.text.isEmpty||
          colorTextEditingController.text.isEmpty||
          plateNumberTextEditingController.text.isEmpty
          ) {
        // Display an error message or handle the empty fields as needed

        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      var currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser?.uid != null) {
        DriverModel user1 = DriverModel(
          id: currentUser?.uid,
          phone: currentUser?.phoneNumber,
          companyName: companyNameTextEditingController.text.trim(),
          companyAddress: companyAddressTextEditingController.text.trim(),
          companyEmail: companyEmailTextEditingController.text.trim(),
          companyRegNumber: companyRegNumberTextEditingController.text.trim(),
          carType: carTypeTextEditingController.text.trim(),
          color: colorTextEditingController.text.trim(),
          plateNumber: plateNumberTextEditingController.text.trim(),
          companyPhoneNumber:companyPhoneNumberTextEditingController.text.trim(),
          name: nameTextEditingController.text.trim(),
          email: emailTextEditingController.text.trim(),
          nin: ninTextEditingController.text.trim(),
        );

        await AmbulanceDatabaseService.addUserToDatabase(user1);
      }
      // ignore: use_build_context_synchronously
      changeScreenReplacement(context, const AmbulanceHomeScreen());
    } else {
      // Validation failed, handle it as needed
    }

    setState(() {
      _isSubmitting = false;
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
                                  emailTextEditingController.text = text;
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
                                  addressTextEditingController.text = text;
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

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  ninTextEditingController.text = text;
                                });
                              },
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            // company email formfield for email
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
                                  companyEmailTextEditingController.text = text;
                                });
                              },
                            ),

                            const SizedBox(
                              height: 10,
                            ),

                            //compay full name form field
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: const InputDecoration(
                                hintText: "Company name",
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
                                  companyNameTextEditingController.text = text;
                                });
                              },
                            ),

                            const SizedBox(
                              height: 10,
                            ),
                            //company phone number
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(11)
                              ],
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                hintText: "Company Phone Number",
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
                                  return "phone cannot be empty";
                                }

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  companyPhoneNumberTextEditingController.text =
                                      text;
                                });
                              },
                            ),
                            const SizedBox(
                              height: 10,
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
                                hintText: "Company Registration Number",
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
                                  return "Company Registration Number cannot be empty";
                                }

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  companyRegNumberTextEditingController.text =
                                      text;
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
                                hintText: "Company Address",
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
                                  return "Company Address cannot be empty";
                                }
                                if (text.length < 2) {
                                  return "please enter a valid full Company Address";
                                }
                                if (text.length > 50) {
                                  return "please enter a valid Company Address";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  companyAddressTextEditingController.text =
                                      text;
                                });
                              },
                            ),
                            //car type
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: const InputDecoration(
                                hintText: "Car Type",
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
                                  return "Car Type cannot be empty";
                                }
                                if (text.length < 2) {
                                  return "please enter a valid full Car Type";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  carTypeTextEditingController.text = text;
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
                                hintText: "Color of car",
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
                                  return " Color of car cannot be empty";
                                }
                                if (text.length < 2) {
                                  return "please enter a valid color";
                                }
                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  colorTextEditingController.text = text;
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
                                hintText: "Plate Number",
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
                                  return "Plate Number cannot be empty";
                                }

                                return null;
                              },
                              onChanged: (text) {
                                setState(() {
                                  plateNumberTextEditingController.text =
                                      text;
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
