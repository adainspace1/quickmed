import 'package:cloud_firestore/cloud_firestore.dart';

// is class will handle our ride request
class RideRequest {
  //this is the firestore collection
  String collection = "requests";

  // this is the function that create the ride request
  void createRideRequest({
    String? id,
    String? userId,
    String? name,
   
  }) {
    var db = FirebaseFirestore.instance;

    db.collection(collection).doc(id).set({
      "name": name,
      "id": id,
      "Status": "pending",
    
    });
  }

  void upDateRequest(Map<String, dynamic> values) {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(values["id"])
        .update(values);
  }

  Stream<QuerySnapshot>? requestStream() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection(collection);

    return reference.snapshots();
  }
}