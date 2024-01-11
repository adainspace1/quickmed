import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {

  String? id;
  String? companyName;
  String? companyAddress;
  String? companyPhoneNumber;
  String? companyEmail;
  String? companyRegNumber;
  String? carType;
  String? plateNumber;
  String? color;
  String? uploadProofOfAddress;
  String? uploadFrontViewOfCompany;
  String? uploadMedicalLicense;
  String? name;
  String? nin;
  String? email;
  String? accountType;
  String? profileImageUrl;

   late double _rating;
   late int _votes;
   late DriverPosition _position;

  // getters
  DriverPosition get position => _position;
  double get rating => _rating;
  int get votes => _votes;

 
  // the driver model constructors..........
  DriverModel({
    this.id,
    this.companyAddress,
    this.companyName,
    this.companyPhoneNumber,
    this.companyEmail,
    this.companyRegNumber,
    this.carType,
    this.plateNumber,
    this.color,
    this.uploadProofOfAddress,
    this.uploadFrontViewOfCompany,
    this.uploadMedicalLicense,
    this.nin,
    this.name,
    this.email,
    this.profileImageUrl,
    this.accountType,
  });
  
  // this data is heading to the firestore database.....
  factory DriverModel.fromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;
    return DriverModel(
      id: snapshot.id,
      companyName: userData['companyName'] ?? "",
      companyAddress: userData['companyAddress'] ?? "",
      companyPhoneNumber: userData['companyPhoneNumber'] ?? "",
      companyEmail: userData["companyEmail"] ?? "",
      companyRegNumber: userData["companyRegNumber"] ?? "",
      carType: userData['carType'] ?? "",
      plateNumber: userData['plateNumber'] ?? "",
      color: userData['color'] ?? "",
      uploadProofOfAddress: userData['proofOfAddress'] ?? "",
      uploadFrontViewOfCompany: userData['frontViewOfCompany'] ?? "",
      uploadMedicalLicense: userData['medicalLicense'] ?? "",
      name: userData['name'] ?? "",
      accountType: userData['accountType'] ?? "",
      email: userData['email'] ?? "",
      nin: userData["nin"] ?? "",
      profileImageUrl: userData['profileImageUrl'] ?? "",
    
    );
  }

  // this is the maped string that would be displayed ont the firestore database......
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "companyAddress": companyAddress,
      "companyName": companyName,
      "companyPhoneNumber": companyPhoneNumber,
      "companyRegNumber": companyRegNumber,
      "companyEmail": companyEmail,
      "carType": carType,
      "plateNumber": plateNumber,
      "color": color,
      "proofOfAddress": uploadProofOfAddress,
      "frontViewOfCompany": uploadFrontViewOfCompany,
      "medicalLicense": uploadMedicalLicense,
      "nin": nin,
      "name": name,
      "email": email,
      "accountType": "ambulance",
      "profileImageUrl": profileImageUrl,
    };
  }
}



 

// this class handles the logic to send the data to the database..........
class DatabaseService {
  // funciion that adds user to the database
  static Future addUserToDatabase(DriverModel user) async {
    try {
      var db = FirebaseFirestore.instance;
      //await db.collection('users').add(user.toJson());
      await db
          .collection('ambulance')
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
      // ignore: empty_catches
    } catch (e) {}
  }

  // function that gets the userId
  static Future<DriverModel?> getUserByUid(String userId) async {
    try {
      var db = FirebaseFirestore.instance;
      var useRef = db.collection("ambulance").doc(userId);
      var snapShot = await useRef.get();

      if (snapShot.exists) {
        return DriverModel.fromSnapshot(snapShot);
      } else {
        return null;
      }
    } catch (e) {
      // print('Error getting user from Firestore: $e\n$stackTrace');
      return null;
    }
  }
}





//this class handles driver position class
 class DriverPosition{
  final double lat;
  final double lng;
  final double heading;

  DriverPosition({required this.lat, required this.lng, required this.heading});
 }
