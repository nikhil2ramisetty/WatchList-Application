import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserDetailsUpdate {
  // BuildContext? get context => null;

  Future<void> addWatchLater(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection("Nikhil").doc(user.uid).update({
        "WatchLater": FieldValue.arrayUnion([id])
      });
    } else {
      throw Exception();
    }
  }

  Future<void> addAlreadyWatched(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      FirebaseFirestore.instance.collection("Nikhil").doc(user.uid).update({
        "AlreadyWatched": FieldValue.arrayUnion([id])
      });
    } else {
      throw Exception();
    }
  }
}
