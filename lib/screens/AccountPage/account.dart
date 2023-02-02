// import 'dart:async';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

import '../../bloc/NavigationBloc/navigation_bloc.dart';
import '../../model/userDetails.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        BlocProvider.of<NavigationBloc>(context).add(HomeClicked());
        return false;
      },
      child: StreamBuilder<User?>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return const AccountLoggedIn();
            } else {
              return const AccountNotLoggedIn();
            }
          }),
    );
  }
}

class AccountLoggedIn extends StatefulWidget {
  const AccountLoggedIn({super.key});

  @override
  State<AccountLoggedIn> createState() => _AccountLoggedInState();
}

class _AccountLoggedInState extends State<AccountLoggedIn> {
  XFile? image;
  final ImagePicker picker = ImagePicker();
  Future getImage(ImageSource media) async {
    var storage = FirebaseStorage.instance;
    var img = await picker.pickImage(source: media);
    var path = img?.path;
    var img_name = img!.name;
    var file = File(img.path);
    TaskSnapshot tsk = await storage.ref('$path/$img_name').putFile(file);
    final String downloadUrl = await tsk.ref.getDownloadURL();
    FirebaseFirestore.instance
        .collection("Nikhil")
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .update({"ProfilePic": downloadUrl});
    setState(() {
      image = img;
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<dynamic>(
        stream: FirebaseFirestore.instance
            .collection('Nikhil')
            .doc(FirebaseAuth.instance.currentUser?.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          var userDetails = snapshot.data.data();
          UserDetails user = UserDetails.fromJson(userDetails);
          String? url = user.url;
          return Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            child: Column(
              children: [
                const SizedBox(height: 50),
                Stack(
                  alignment: AlignmentDirectional.bottomEnd,
                  children: [
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(200),
                          border: Border.all(width: 4, color: Colors.purple)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(200),
                        child: CachedNetworkImage(
                          width: 200,
                          height: 200,
                          placeholder: (context, url) => const Center(
                            child: SizedBox(
                                width: 10,
                                height: 10,
                                child: CircularProgressIndicator()),
                          ),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.error),
                          alignment: Alignment.center,
                          fit: BoxFit.cover,
                          imageUrl: url ??
                              "https://upload.wikimedia.org/wikipedia/commons/thumb/2/2c/Default_pfp.svg/1200px-Default_pfp.svg.png",
                        ),
                      ),
                    ),
                    Container(
                        clipBehavior: Clip.hardEdge,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(200)),
                        child: ElevatedButton(
                            style: ButtonStyle(
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    const EdgeInsets.all(17))),
                            onPressed: () {
                              getImage(ImageSource.gallery);
                            },
                            child: const Icon(Icons.camera_alt))),
                  ],
                ),
                const SizedBox(height: 100),
                SizedBox(
                  width: 500,
                  child: ElevatedButton(
                      onPressed: () {
                        SignOut();
                      },
                      child: const Text("Sign Out")),
                ),
                SizedBox(
                  width: 500,
                  child: ElevatedButton(
                      onPressed: () {
                        ChangePassword();
                      },
                      child: const Text("Change Password")),
                ),
              ],
            ),
          );
        });
  }
}

class AccountNotLoggedIn extends StatefulWidget {
  const AccountNotLoggedIn({super.key});

  @override
  State<AccountNotLoggedIn> createState() => _AccountNotLoggedInState();
}

class _AccountNotLoggedInState extends State<AccountNotLoggedIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          const SizedBox(height: 250),
          SizedBox(
            height: 50,
            width: 500,
            child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<NavigationBloc>(context).add(MoviesClicked());
                },
                child: const Text("Account SignIn",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          ),
          const SizedBox(height: 30),
          SizedBox(
            height: 50,
            width: 500,
            child: ElevatedButton(
                onPressed: () {
                  BlocProvider.of<NavigationBloc>(context).add(MoviesClicked());
                },
                child: const Text("Create Account",
                    style:
                        TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
          )
        ],
      ),
    );
  }
}

Future SignOut() async {
  await FirebaseAuth.instance.signOut();
}

Future ChangePassword() async {
  final user = await FirebaseAuth.instance.currentUser;
  await user?.updatePassword("WorldHello");
}
