// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';

// is class will handle our ride request
class RideRequest {
  //this is the firestore collection
  String collection = "requests";

  // this is the function that create the ride request
  void createRideRequest(
      {String? id, String? userId, String? name, String? img, String? issue}) {
    var db = FirebaseFirestore.instance;

    db.collection(collection).doc(userId).set({
      "name": name,
      "id": id,
      "img": img,
      "userId": userId,
      "issue": issue,
      "Status": "pending",
    });
  }

  // Function to delete a ride request
void deleteRideRequest(String userId) {
  var db = FirebaseFirestore.instance;

  db.collection('requests').doc(userId).delete().then((_) {
    print("Ride request deleted successfully");
  }).catchError((error) {
    print("Failed to delete ride request: $error");
  });
}

  //THIS FUNCTIONS CREATES A ROOM FOR THE USER AND SP
  void addRooms(String? userId, String? spId, String? message) {
    var db = FirebaseFirestore.instance;

    // Create a unique chat room ID using both user IDs
    String roomId = generateChatRoomId(userId!, spId!);
    db.collection(collection).doc(roomId).set({
      "messages": [
        {
          "sender":userId,
          "message": message,
          "timestamp":DateTime.now()
        }
      ]
    });
  }

  //THIS FUNCTION GENERATE A UNIQUE ROOMID....
  String generateChatRoomId(String userId1, String userId2) {
  // Sort user IDs alphabetically to ensure consistency
  List<String> ids = [userId1, userId2]..sort();
  
  // Concatenate user IDs to generate a unique room ID
  return '${ids[0]}_${ids[1]}';
}

  // ignore: non_constant_identifier_names
  Future<void> upDateRequest(String Status, String id) async {
    FirebaseFirestore.instance
        .collection(collection)
        .doc(id)
        .update({"Status": Status});
  }

  Stream<QuerySnapshot>? requestStream() {
    CollectionReference reference =
        FirebaseFirestore.instance.collection(collection);

    return reference.snapshots();
  }
}
