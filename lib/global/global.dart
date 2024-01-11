import 'package:firebase_auth/firebase_auth.dart';
import 'package:quickmed/model/user/user_model.dart';

final FirebaseAuth firebaseAuth = FirebaseAuth.instance;

User? currentUser;

UserModel? userModelCurrentInfo;
String userDropOffAddress = "";

