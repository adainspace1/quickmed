// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:quickmed/helpers/screen_navigation.dart';
import 'package:quickmed/screen/account_type.dart';
import 'package:quickmed/controller/auth_service.dart';
import 'package:quickmed/screen/ambulance/dashboard/ambulance_homescreen.dart';
import 'package:quickmed/screen/e-consultant/dashboard/econ_homeScreen.dart';
import 'package:quickmed/screen/hospital/dashboard/hospitalHomescreen.dart';
import 'package:quickmed/screen/user/dashboard/user_home_screen.dart';
import 'package:quickmed/util/constant.dart';
import 'package:quickmed/util/notification.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final TextEditingController _phoneContoller = TextEditingController();
  final TextEditingController _otpContoller = TextEditingController();
  bool isLoading = false; // Add this boolean variable
  bool isChecked = false; // Add this boolean variable

  NotificationMessage notify = NotificationMessage();

  final _formKey = GlobalKey<FormState>();
  final _formKey1 = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 7,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  padding: const EdgeInsets.fromLTRB(25.0, 60.0, 25.0, 20.0),
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          colors: [COLOR_PRIMARY, COLOR_ACCENT],
                          begin: Alignment.bottomLeft,
                          end: Alignment.topRight),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(50),
                          bottomRight: Radius.circular(50))),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "images/logo.png",
                        width: 100,
                        height: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      Text(
                        "Powered by Adain",
                        style: GoogleFonts.montserrat(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Text(
                        "Register With Phone Number",
                        style: customGoogleFontStyle,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            controller: _phoneContoller,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              prefix: Row(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Image.asset(
                                    'images/flag.png',
                                    width: 20,
                                    height: 20,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  const Text(" +234")
                                ],
                              ),
                              // prefixText: "+234 ",
                              labelText: "Enter your phone number",
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(32)),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 16),
                            ),
                            validator: (value) {
                              if (value!.length != 10) {
                                return "Invalid phone number";
                              }
                              return null;
                            },
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: [
                              Checkbox(
                                value: isChecked,
                                onChanged: (bool? value) {
                                  setState(() {
                                    isChecked = value ?? false;
                                  });
                                },
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isChecked = !isChecked;
                                  });
                                },
                                child: const Text(
                                  'I agree to the Terms and Conditions',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.blue,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          SizedBox(
                            height: 50,
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() &&
                                    isChecked) {
                                  // Proceed with OTP
                                  setState(() {
                                    isLoading = true; // Set loading to true
                                  });

                                  AuthService.sentOtp(
                                    phone: _phoneContoller.text,
                                    errorStep: () {
                                      setState(() {
                                        isLoading =
                                            false; // Set loading to false on error
                                      });

                                      notify.OtpError();
                                    },
                                    nextStep: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: const Text("OTP Verification"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text("Enter 6 digit OTP"),
                                              const SizedBox(
                                                height: 12,
                                              ),
                                              Form(
                                                key: _formKey1,
                                                child: TextFormField(
                                                  keyboardType:
                                                      TextInputType.number,
                                                  controller: _otpContoller,
                                                  decoration: InputDecoration(
                                                    labelText:
                                                        "Enter your phone number",
                                                    border: OutlineInputBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              32),
                                                    ),
                                                  ),
                                                  validator: (value) {
                                                    if (value!.length != 6) {
                                                      return "Invalid OTP";
                                                    }
                                                    return null;
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () {
                                                if (_formKey1.currentState!
                                                    .validate()) {
                                                  AuthService.loginWithOtp(
                                                    otp: _otpContoller.text,
                                                  ).then((value) async {
                                                    if (value == "Success") {
                                                      // Get account type after successful login
                                                      String? accountType =
                                                          await AuthService
                                                              .getAccountType();
                                                      Navigator.pop(context);
                                                      if (accountType != null) {
                                                        switch (accountType) {
                                                          case "User":
                                                            changeScreenReplacement(
                                                                context,
                                                                const UserHomeScreen());
                                                            break;

                                                          case "ambulance":
                                                            changeScreenReplacement(
                                                                context,
                                                                const AmbulanceHomeScreen());
                                                            break;
                                                          case "econsultants":
                                                            changeScreenReplacement(
                                                                context,
                                                                const EconsultantHomeScreen());
                                                            break;

                                                          case "hospital":
                                                            changeScreenReplacement(
                                                                context,
                                                                const HospitalScreen());
                                                            break;
                                                        }
                                                      } else {
                                                        changeScreenReplacement(
                                                            context,
                                                            const AccountSelect());
                                                      }
                                                    } else {
                                                      Navigator.pop(context);
                                                      setState(() {
                                                        isLoading = false;
                                                      });
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                        SnackBar(
                                                          content: Text(
                                                            value,
                                                            style:
                                                                const TextStyle(
                                                              color:
                                                                  Colors.white,
                                                            ),
                                                          ),
                                                          backgroundColor:
                                                              Colors.red,
                                                        ),
                                                      );
                                                    }
                                                  });
                                                }
                                              },
                                              child: const Text("Submit"),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  // Validation failed, set loading to false
                                  setState(() {
                                    isLoading = false;
                                  });
                                  if (!isChecked) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Please accept the Terms and Conditions',
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                        backgroundColor: Colors.red,
                                      ),
                                    );
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: COLOR_PRIMARY,
                                foregroundColor: Colors.white,
                              ),
                              child: isLoading
                                  ? const CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    )
                                  : Text(
                                      "Sign In",
                                      style: GoogleFonts.lato(
                                        color: Colors.white,
                                        fontSize: 14,
                                      ),
                                    ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
