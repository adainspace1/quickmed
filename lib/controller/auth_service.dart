// ignore_for_file: unused_local_variable, avoid_print
//import 'package:cloud_firestore/cloud_firestore.dart';
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

//   static Future<UserModel?> isPhoneNumberRegistered(String phone) async {
//   try {
//     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
//         .collection("users")
//         .where("phone", isEqualTo: "+234$phone")
//         .limit(1)
//         .get();

//     if (querySnapshot.docs.isNotEmpty) {
//       // User with the provided phone number exists, return the user
//       Map<String, dynamic> userData = querySnapshot.docs[0].data() as Map<String, dynamic>;
//       UserModel user = UserModel.fromSnapshot(userData as DocumentSnapshot<Object?>); // Assuming you have a method to convert Map to User
//       return user;
//     } else {
//       // User with the provided phone number does not exist
//       return null;
//     }
//   } catch (e) {
//     // Handle any errors that may occur during the database query
//     print("Error checking user registration: $e");
//     return null;
//   }
// }



  //Check if the phone number is already registered in our firestoredataBase.
  // static Future<bool> isPhoneNumberRegistered(
  //     String phone) async {
  //   try {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection("users")
  //         .where("phone", isEqualTo: "+234$phone")
  //         .limit(1)
  //         .get();

  //     // Check if the snapshot has any documents (user with the provided phone number exists)
  //      return querySnapshot.docs.isNotEmpty;
      
  //   } catch (e) {
  //     // Handle any errors that may occur during the database query
  //     print("Error checking phone number registration: $e");
  //     return false;
  //   }
  // }



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


}
