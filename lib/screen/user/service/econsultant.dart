import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';

class DriverService {
  String collection = "econsultants";

  Stream<List<EconsultantModel>> getDrivers() {
    return FirebaseFirestore.instance.collection(collection).snapshots().map(
        (event) => event.docs.map((e) => EconsultantModel.fromSnapshot(e)).toList());
  }

  Future<DriverModel> getDriverById(String id) => FirebaseFirestore.instance
          .collection(collection)
          .doc(id)
          .get()
          .then((doc) {
        return DriverModel.fromSnapshot(doc);
      });

  Stream<QuerySnapshot> driverStream() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection(collection);
    return reference.snapshots();
  }
}
