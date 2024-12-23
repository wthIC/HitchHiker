import 'package:firebase_auth/firebase_auth.dart';
import 'package:travelproject/firestore_service.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String?> signInWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return "Signed in successfully!";
    } catch (e) {
      return 'Error signing in: $e';
    }
  }

  Future<String?> registerWithEmailAndPassword(String email, String password,
      bool isDriver, String name, String phone) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (userCredential.user != null) {
        String uid = userCredential.user!.uid;

        // Add user details to Firestore
        await FirestoreService().addUserData(uid, email, isDriver, name, phone);
        return "Signed up successfully!";
      }
      return "No user";
    } catch (e) {
      return 'Error registering: $e';
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }
}
