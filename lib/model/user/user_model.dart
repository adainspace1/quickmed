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
  double? heading;
  double? latitude;
  double? longitude;
  bool? verified;


  UserModel({
    this.id,
    this.phone,
    this.address,
    this.name,
    this.weight,
    this.genotype,
    this.email,
    this.gender,
    this.heading,
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
    this.verified
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
        verified: userData['verified'] ?? "",
        longitude: userData['longitude'] ?? "");
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
      "dob": dateOfBirth,
      "latitude": 0.0,
      "longitude": 0.0,
      "verified": false
    };
  }
}
