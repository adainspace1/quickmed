import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:quickmed/model/e-consultant/econsultant_model.dart';

class EconsultantServices {
  // this function adds user to realtime database
static  Future addtoRealtime(EconsultantModel user) async {
    try {
      DatabaseReference databaseReference = FirebaseDatabase.instance.ref();
      databaseReference
          .child("${user.name}")
          .child("${user.name}")
          .update(user.toJson());
      // ignore: empty_catches
    } catch (e) {}
  }

  // this function add user to the firestore database
  static Future addUserToDatabase(EconsultantModel user) async {
    try {
      var db = FirebaseFirestore.instance;
      //await db.collection('users').add(user.toJson());
      await db
          .collection('econsultants')
          .doc(user.id)
          .set(user.toJson(), SetOptions(merge: true));
      // ignore: empty_catches
    } catch (e) {}
  }

  //this function gets user UID
 static Future<EconsultantModel?> getUserByUid(String? userId) async {
    try {
      var db = FirebaseFirestore.instance;
      var useRef = db.collection("econsultant").doc(userId);
      var snapShot = await useRef.get();

      if (snapShot.exists) {
        EconsultantModel? user = EconsultantModel.fromSnapshot(snapShot);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<QuerySnapshot> searchByName(String searchField) {
    return FirebaseFirestore.instance
        .collection("user")
        .where('userName', isEqualTo: searchField)
        .limit(20)
        .get();
  }

  Future<void> addChatRoom(
      Map<String, dynamic> chatRoom, String chatRoomId) async {
    // Implement logic to add chat room details to your database
    // Example using Firestore:
    await FirebaseFirestore.instance
        .collection('chatRooms')
        .doc(chatRoomId)
        .set(chatRoom);
  }
}
