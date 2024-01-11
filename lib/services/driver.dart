import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quickmed/model/ambulance/driver/driver_model.dart';

class DriverService {
  String collection = "ambulance";

   Stream<List<DriverModel>> getDrivers() {
    return FirebaseFirestore.instance.collection(collection).snapshots().map((event) =>
        event.docs.map((e) => DriverModel.fromSnapshot(e)).toList());
  }

    Future<DriverModel> getDriverById(String id) =>
      FirebaseFirestore.instance.collection(collection).doc(id).get().then((doc) {
        return DriverModel.fromSnapshot(doc);
      });

  
}
