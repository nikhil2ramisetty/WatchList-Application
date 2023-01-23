import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:watchlist/bloc/NavigationBloc/navigation_bloc.dart';
import 'package:watchlist/bloc/SideNavigation/sidenavigation_bloc.dart';
import 'package:watchlist/model/userDetails.dart';

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
