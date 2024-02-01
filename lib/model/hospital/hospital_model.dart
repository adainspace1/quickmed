import 'package:cloud_firestore/cloud_firestore.dart';

class HospitalModel {
  String? id;
  String? hospitalName;
  String? hospitalemail;
  String? hospitalRegNumber;
  String? hospitaladdress;
  String? hospitalEmergencyNumber;
  String? onSitDoctor;
  String? uploadMedicalLicence;
  String? uploadclearProofofaddress;
  String? uploadfrontviewofhospital;
  String? accontType;

  HospitalModel(
      {
      this.id,
      this.hospitalName,
      this.hospitalEmergencyNumber,
      this.hospitalRegNumber,
      this.hospitaladdress,
      this.hospitalemail,
      this.accontType,
      this.onSitDoctor,
      this.uploadMedicalLicence,
      this.uploadclearProofofaddress,
      this.uploadfrontviewofhospital});

  factory HospitalModel.fromSnapshot(DocumentSnapshot snapshot) {
    var userData = snapshot.data() as Map<String, dynamic>;

    return HospitalModel(
        id: userData['id'] ?? "",
        hospitalName: userData['hospitalName'] ?? "",
        hospitalEmergencyNumber: userData['hospitalEmergencyNumber'] ?? "",
        hospitalRegNumber: userData['hospitalRegNumber'] ?? "",
        hospitaladdress: userData['hospitaladdress'] ?? "",
        hospitalemail: userData['hospitalemail'] ?? "",
        accontType: userData["accountType"] ?? "",
        onSitDoctor: userData['onSitDoctor'] ?? "",
        uploadMedicalLicence: userData['uploadMedicalLicence'] ?? "",
        uploadclearProofofaddress: userData['uploadclearProofofaddress'] ?? "",
        uploadfrontviewofhospital: userData['uploadfrontviewofhospital'] ?? "");
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "hospitalName": hospitalName,
      "hospitalEmergencyNumber":hospitalEmergencyNumber,
      "hospitalRegNumber":hospitalRegNumber,
      "hospitaladdress": hospitaladdress,
      "hospitalemail":hospitalemail,
      "onSitDoctor":onSitDoctor,
      "uploadMedicalLicence":uploadMedicalLicence,
      "uploadclearProofofaddress":uploadclearProofofaddress,
      "uploadfrontviewofhospital":uploadfrontviewofhospital,
      "accountType": "hospital",

    };
  }
}
