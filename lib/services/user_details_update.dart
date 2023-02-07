import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:watchlist/model/userDetails.dart';

class UserDetailsUpdate {
  // BuildContext? get context => null;

  Future<void> addWatchLater(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var ss = FirebaseFirestore.instance
          .collection("Nikhil")
          .doc(user.uid)
          .get()
          .then((value) async {
        var ss = value.data();
        UserDetails us = UserDetails.fromJson(ss!);
        var index = us.movies?.indexOf(id);
        if (index == -1) {
          us.watchLater!.add(true);
          us.movies!.add(id);
          us.alreadyWatched!.add(false);
          await FirebaseFirestore.instance
              .collection("Nikhil")
              .doc(user.uid)
              .update({
            "Movies": us.movies,
            "Already Watched": us.alreadyWatched,
            "Watch Later": us.watchLater
          });
        } else {
          List<bool>? lis = us.watchLater;
          if (index != null) {
            lis![index] = true;
            await FirebaseFirestore.instance
                .collection("Nikhil")
                .doc(user.uid)
                .update({"Watch Later": lis});
          }
        }
      });
    } else {
      throw Exception();
    }
  }

  Future<void> removeWatchLater(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var ss = FirebaseFirestore.instance
          .collection("Nikhil")
          .doc(user.uid)
          .get()
          .then((value) async {
        var ss = value.data();
        UserDetails us = UserDetails.fromJson(ss!);
        var index = us.movies?.indexOf(id);
        if (index == -1) {
        } else {
          List<bool>? wl = us.watchLater;
          List<bool>? aw = us.alreadyWatched;
          List<String>? movies = us.movies;
          if (index != null && !aw![index]) {
            movies?.removeAt(index);
            wl?.removeAt(index);
            aw.removeAt(index);
            await FirebaseFirestore.instance
                .collection("Nikhil")
                .doc(user.uid)
                .update({
              "Already Watched": aw,
              "Watch Later": wl,
              "Movies": movies
            });
          } else if (index != null) {
            wl![index] = false;
            await FirebaseFirestore.instance
                .collection("Nikhil")
                .doc(user.uid)
                .update({"Watch Later": wl});
          }
        }
      });
    }
  }

  Future<void> removeAlreadyWatched(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var ss = await FirebaseFirestore.instance
          .collection("Nikhil")
          .doc(user.uid)
          .get()
          .then((value) async {
        var ss = value.data();
        UserDetails us = UserDetails.fromJson(ss!);
        var index = us.movies?.indexOf(id);

        if (index == -1) {
        } else {
          List<bool>? lis = us.alreadyWatched;
          List<bool>? wl = us.watchLater;
          List<String>? movies = us.movies;
          if (index != null && !wl![index]) {
            movies?.removeAt(index);
            wl.removeAt(index);
            lis?.removeAt(index);
            await FirebaseFirestore.instance
                .collection("Nikhil")
                .doc(user.uid)
                .update({
              "Already Watched": lis,
              "Watch Later": wl,
              "Movies": movies
            });
          } else if (index != null) {
            lis![index] = false;
            await FirebaseFirestore.instance
                .collection("Nikhil")
                .doc(user.uid)
                .update({"Already Watched": lis});
          }
        }
      });
    }
  }

  Future<void> addAlreadyWatched(String id) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      var ss = await FirebaseFirestore.instance
          .collection("Nikhil")
          .doc(user.uid)
          .get()
          .then((value) async {
        var ss = value.data();
        UserDetails us = UserDetails.fromJson(ss!);
        var index = us.movies?.indexOf(id);
        if (index == -1) {
          us.alreadyWatched!.add(true);
          us.watchLater!.add(false);
          us.movies!.add(id);
          await FirebaseFirestore.instance
              .collection("Nikhil")
              .doc(user.uid)
              .update({
            "Movies": us.movies,
            "Already Watched": us.alreadyWatched,
            "Watch Later": us.watchLater
          });
        } else {
          List<bool>? lis = us.alreadyWatched;
          if (index != null) {
            lis![index] = true;
            await FirebaseFirestore.instance
                .collection("Nikhil")
                .doc(user.uid)
                .update({"Already Watched": lis});
          }
        }
      });
    } else {
      throw Exception();
    }
  }
}
