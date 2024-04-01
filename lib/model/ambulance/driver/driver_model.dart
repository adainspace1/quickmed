import 'package:cloud_firestore/cloud_firestore.dart';

class DriverModel {
  String? id;
  String? phone;
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
  double? latitude;
  double? longitude;
  String? name;
  String? nin;
  String? email;
  String? accountType;
  String? profileImageUrl;
  double? amount;
  bool? isOnline;
  bool? verified;
  int? rating;

  // the driver model constructors..........
  DriverModel(
      {this.id,
      this.phone,
      this.companyAddress,
      this.companyName,
      this.companyPhoneNumber,
      this.companyEmail,
      this.companyRegNumber,
      this.carType,
      this.latitude,
      this.longitude,
      this.plateNumber,
      this.color,
      this.verified,
      this.isOnline,
      this.uploadProofOfAddress,
      this.uploadFrontViewOfCompany,
      this.uploadMedicalLicense,
      this.nin,
      this.name,
      this.email,
      this.profileImageUrl,
      this.accountType,
      this.rating,
      this.amount});

  // this data is heading to the firestore database.....
  factory DriverModel.fromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;
    return DriverModel(
        id: snapshot.id,
        phone: userData['phone'] ?? "",
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
        latitude: userData["latitude"] ?? "",
        longitude: userData["longitude"] ?? "",
        rating: userData["rating"] ?? "",
        verified: userData['verified'] ?? "",
        amount: userData['amount'] ?? "",
        isOnline: userData['isOnline'] ?? ""
        );
  }

  // this is the maped string that would be displayed ont the firestore database......
  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "phone": phone,
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
      "latitude": 0.0,
      "longitude": 0.0,
      "rating": 0,
      "amount": 0.0,
      "verified": false,
      "isOnline":false
    };
  }
}
