// ignore_for_file: avoid_print, duplicate_ignore

// ignore_for_file: avoid_print
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  String? phone;
  String? address;
  String? genotype;
  String? id;
  String? name;
  String? email;
  String? gender;
  String? bloodGroup;
  String? accountType;
  String? profileImageUrl;
  String? weight;
  String? height;
  String? nin;
  String? dateOfBirth;
  String? nextOfKin;
  String? addressOfKin;
  double? latitude;
  double? longitude;
  

  UserModel(
      {this.id,
      this.phone,
      this.address,
      this.name,
      this.weight,
      this.genotype,
      this.email,
      this.gender,
      this.height,
      this.nextOfKin,
      this.addressOfKin,
      this.dateOfBirth,
      this.accountType,
      this.bloodGroup,
      this.profileImageUrl,
      this.nin,
      this.latitude,
      this.longitude,
      });

  factory UserModel.fromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;
    return UserModel(
        id: snapshot.id,
        phone: userData['phone'] ?? "",
        address: userData['address'] ?? "",
        genotype: userData['genotype'] ?? "",
        name: userData['name'] ?? "",
        email: userData['email'] ?? "",
        weight: userData['weight'] ?? "",
        height: userData['height'] ?? "",
        nextOfKin: userData['nextOfKin'] ?? "",
        addressOfKin: userData['addressOfKin'] ?? "",
        dateOfBirth: userData['dateOfBirth'] ?? "",
        accountType: userData['accountType'] ?? "",
        bloodGroup: userData['bloodGroup'] ?? "",
        gender: userData['gender'] ?? "",
        profileImageUrl: userData['profileImageUrl'] ?? "",
        nin: userData['nin'] ?? "",
        latitude: userData['latitude'] ?? "",
        longitude: userData['longitude'] ?? "",
        );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "address": address,
      "name": name,
      "phone": phone,
      "genotype": genotype,
      "email": email,
      "accountType": "User",
      "bloodGroup": bloodGroup,
      "profileImageUrl": profileImageUrl,
      "weight": weight,
      "height": height,
      "gender": gender,
      "nextOfKin": nextOfKin,
      "addressOfKin": addressOfKin,
      "nin": nin,
      "latitude": 0.0,
      "longitude": 0.0,
      
    };
  }


}


















// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// // import 'package:firebase_database/firebase_database.dart';

// // i created a usermodel class to collect the user information
// class UserModel {
//   String? phone;
//   String? address;
//   String? id;
//   String? name;
//   String? email;
//   String? bloodGroup;
//   String? accountType;
//   String? profileImageUrl;
//   String? nin;

//   UserModel(
//       {
//       this.id,
//       this.phone,
//       this.address,
//       this.name,
//       this.email,
//       this.accountType,
//       this.bloodGroup,
//       this.profileImageUrl,
//       this.nin});

//   UserModel.fromSnapshot(DocumentSnapshot snap) {
//   // Assuming 'snap' is an instance of DocumentSnapshot
//   phone = snap.get("phone");
//   name = snap.get("name");
//   id = snap.id;
//   email = snap.get("email");
//   nin = snap.get("nin");
//   address = snap.get("address");
//   profileImageUrl = snap.get("profileImageUrl");
// }

//   // UserModel.fromSnapshot(DataSnapshot snap) {
//   //   phone = (snap.value as dynamic)["phone"];
//   //   name = (snap.value as dynamic)["name"];
//   //   id = snap.key;
//   //   email = (snap.value as dynamic)["email"];
//   //   nin = (snap.value as dynamic)["nin"];
//   //   address = (snap.value as dynamic)["address"];
//   //   profileImageUrl = (snap.value as dynamic)["profileImageUrl"];
//   // }

//   Map<String, dynamic> toJson() {
//     return {
//       "address": address,
//       "name": name,
//       "email": email,
//       "accountType": "User",
//       "bloodGroup": bloodGroup,
//       "profileImageUrl": profileImageUrl,
//       "nin": nin
//     };
//   }
// }


// // usermodel database services.........
// class DatabaseService {
//   static Future addUserToDatabase(UserModel user) async {
//     try {
//       // Get the Firestore instance
//       var db = FirebaseFirestore.instance;

//       // Add the user data to the 'users' collection
//       await db.collection('users').add(user.toJson());
//     } catch (e) {
//       print('Error adding user to Firestore: $e');
//       // Handle the error as needed
//     }
//   }

//   // get the user data from firestore
//  static Future<UserModel?> getUserByUid() async {
//   try {
//     // Get the current user from Firebase Authentication
//     var currentUser =  FirebaseAuth.instance.currentUser;

    

//     // Get the Firestore instance
//     var db = FirebaseFirestore.instance;

//     // Reference to the 'users' collection
//     var userRef = db.collection('users').doc(currentUser?.uid);

//     // Get the document snapshot for the current user
//     var snapshot = await userRef.get();

//     // Check if the document exists
//     if (snapshot.exists) {
//       // Convert the snapshot data to a UserModel instance
//       var userData = snapshot.data() as Map<String, dynamic>;

//       // Handle null values by providing default values or allowing null in UserModel
//       return UserModel(
//         id: snapshot.id,
//         phone: userData['phone'] ?? "",
//         address: userData['address'] ?? "",
//         name: userData['name'] ?? "",
//         email: userData['email'] ?? "",
//         accountType: userData['accountType'] ?? "",
//         bloodGroup: userData['bloodGroup'] ?? "",
//         profileImageUrl: userData['profileImageUrl'] ?? "",
//         nin: userData['nin'] ?? "",
//       );
//     } else {
//       // Document for the current user doesn't exist
//       return null;
//     }
//   } catch (e) {
//     print('Error getting user from Firestore: $e');
//     // Handle the error as needed
//     return null;
//   }
// }

// }
