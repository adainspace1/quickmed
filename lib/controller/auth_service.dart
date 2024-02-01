// ignore_for_file: unused_local_variable, avoid_print
//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  static String verifyId = "";
  // to sent and otp to user
  static Future sentOtp({
    required String phone,
    required Function errorStep,
    required Function nextStep,
  }) async {
    await _firebaseAuth
        .verifyPhoneNumber(
      timeout: const Duration(seconds: 50),
      phoneNumber: "+234$phone",
      verificationCompleted: (phoneAuthCredential) async {
        return;
      },
      verificationFailed: (error) async {
        return;
      },
      codeSent: (verificationId, forceResendingToken) async {
        verifyId = verificationId;
        nextStep();
      },
      codeAutoRetrievalTimeout: (verificationId) async {
        return;
      },
    )
      .onError((error, stackTrace) {
      errorStep();
    });
  }

  // verify the otp code and login
  static Future loginWithOtp({required String otp}) async {
    final cred =
        PhoneAuthProvider.credential(verificationId: verifyId, smsCode: otp);

    try {
      final user = await _firebaseAuth.signInWithCredential(cred);
      if (user.user != null) {
        return "Success";
      } else {
        return "Error in Otp login";
      }
    } on FirebaseAuthException catch (e) {
      return e.message.toString();
    } catch (e) {
      return e.toString();
    }
  }

  // to logout the user
  static Future logout() async {
    await _firebaseAuth.signOut();
  }

  // check whether the user is logged in or not
  static Future<bool> isLoggedIn() async {
    var user = _firebaseAuth.currentUser;
    return user != null;
  }

  //THIS FUNCTION AUTHENTICATE ALREADY REGISTERED USERS
  static Future<String?> getAccountType() async {
  try {
    User? user = _firebaseAuth.currentUser;

    if (user != null) {
      // Check each collection for the user's account type
      List<String> collections = ['users', 'ambulance', 'econsultants', 'hospital'];

      for (String collection in collections) {
        DocumentSnapshot userProfileDoc = await FirebaseFirestore.instance
            .collection(collection)
            .doc(user.uid)
            .get();

        if (userProfileDoc.exists) {
          return userProfileDoc.get('accountType');
        }
      }
    }

    return null;
  } catch (e) {
    print("Error getting account type: $e");
    return null;
  }
} 
}
