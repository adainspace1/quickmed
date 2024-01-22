// ignore: file_names
// ignore_for_file: file_names, duplicate_ignore

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/global/global.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';
import 'package:quickmed/screen/e-consultant/dashboard/econ_homeScreen.dart';
import 'package:quickmed/screen/signin_screen.dart';
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
          medicalFieldTextEditingController.text.isEmpty
          ) {
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      var user = firebaseAuth.currentUser;
      if (user != null) {
        EconsultantModel user1 = EconsultantModel(
            name: nameTextEditingController.text.toString(),
            email: emailTextEditingController.text.toString(),
            medicalField: medicalFieldTextEditingController.text.toString(),
            id: user.uid
            
            );

        await EconsultantServices.addUserToDatabase(user1);
      }
      // ignore: use_build_context_synchronously
      changeScreenReplacement(context, const EconsultantHomeScreen());
    } else {
      // Validation failed, handle it as needed
      AuthService.logout();
      changeScreenReplacement(context, const SignInScreen());
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
                const Text(
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
                            const SizedBox(height: 10,),

                            TextFormField(
                              inputFormatters: [
                                LengthLimitingTextInputFormatter(50)
                              ],
                              decoration: const InputDecoration(
                                hintText: "Select Medical Field eg doctor, nurse, dentis etc",
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
