import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addUserData(String uid, String email, bool isDriver, String name,
      String phoneNumber) async {
    try {
      await _firestore.collection('users').doc(uid).set({
        'email': email,
        'isDriver': isDriver,
        'name': name,
        'phone': phoneNumber,
        'routes': [],
      });
    } catch (e) {
      print('Error adding user data: $e');
    }
  }

  Future<String> addRoute(DateTime date, List<String> selectedValues,
      List<String> selectedTimes) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return "Error no user found!";
      }
      String uid = user.uid;
      DocumentSnapshot userDoc = await getUserData(uid);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      final docRef = await _firestore.collection('routes').add({
        'phone': userData!['phone'],
        'date': date,
        'selectedValues': selectedValues,
        'selectedTimes': selectedTimes,
      });
      await _firestore.collection('users').doc(uid).update({
        'routes': FieldValue.arrayUnion([docRef.id]),
      });
      return 'Route added successfully';
    } catch (e) {
      return 'Error adding route: $e';
    }
  }

  Future<String> editRoute(String routeId, DateTime date,
      List<String> selectedValues, List<String> selectedTimes) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return "Error no user found!";
      }
      String uid = user.uid;
      DocumentSnapshot userDoc = await getUserData(uid);
      Map<String, dynamic>? userData = userDoc.data() as Map<String, dynamic>?;
      await _firestore.collection('routes').doc(routeId).update({
        'phone': userData!['phone'],
        'date': date,
        'selectedValues': selectedValues,
        'selectedTimes': selectedTimes,
      });
      return 'Route edited successfully';
    } catch (e) {
      return 'Error editing route: $e';
    }
  }

  Future<String> removeRoute(String routeId) async {
    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        return "Error no user found!";
      }
      String uid = user.uid;
      await _firestore.collection('routes').doc(routeId).delete();
      await _firestore.collection('users').doc(uid).update({
        'routes': FieldValue.arrayRemove([routeId]),
      });
      return 'Route removed successfully';
    } catch (e) {
      return 'Error removing route: $e';
    }
  }

  Future<void> updateUserField(
      String uid, Map<String, dynamic> updatedFields) async {
    try {
      await _firestore.collection('users').doc(uid).update(updatedFields);
      print('User fields updated successfully');
    } catch (e) {
      print('Error updating user fields: $e');
    }
  }

  Future<DocumentSnapshot> getUserData(String uid) async {
    return await _firestore.collection('users').doc(uid).get();
  }

  Future<DocumentSnapshot> getRouteData(String uid) async {
    return await _firestore.collection('routes').doc(uid).get();
  }
}
