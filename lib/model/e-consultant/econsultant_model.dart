import 'package:cloud_firestore/cloud_firestore.dart';

class EconsultantModel {
  String? id;
  String? medicalField;
  String? name;
  String? profileImage;
  double? latitude;
  double? longitude;
  String? email;
  bool? verified;
  int? vote;
  int? rating;

  EconsultantModel(
      {
      this.id,
      this.medicalField,
      this.name,
      this.email,
      this.profileImage,
      this.rating,
      this.vote,
      this.verified,
      this.latitude,
      this.longitude
      });

  factory EconsultantModel.fromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;

    return EconsultantModel(
        medicalField: userData['medicalField'] ?? "",
        id: snapshot.id,
        name: userData['name'] ?? "",
        email: userData["email"] ?? "",
        profileImage: userData['profileImage'] ?? "",
        latitude: userData["latitude"] ?? "",
        longitude: userData["longitude"] ?? "",
        rating: userData["rating"] ?? "",
        vote: userData["votes"] ?? ""
        );
        

  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "medicalField": medicalField,
      "name": name,
      "img": profileImage,
      "email": email,
      "latitude": 0.0,
      "longitude": 0.0,
      "rating": 0,
      "votes": 0,
      "verified": false
    };
  }
}
