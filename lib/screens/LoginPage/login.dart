// import 'dart:html';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  int loginStatus = 0;
  Future createUserStorage() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    final doc = FirebaseFirestore.instance.collection('Nikhil').doc(uid);
    final json = {"AlreadyWatched": [], "WatchLater": []};
    await doc.set(json);
  }

  Future SignIn() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: _textEditingController.text,
          password: _passwordController.text);
    } on FirebaseAuthException catch (e) {
      String errorMessage = e.message.toString();
      if (errorMessage ==
          "There is no user record corresponding to this identifier. The user may have been deleted.") {
        setState(() {
          loginStatus = 2;
        });
      } else if (errorMessage ==
          "The password is invalid or the user does not have a password.") {
        setState(() {
          loginStatus = 1;
        });
      }
      var snackBar = SnackBar(
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Future SignUp() async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _textEditingController.text,
          password: _passwordController.text);
      createUserStorage();
    } catch (e) {
      var snackBar = SnackBar(
        content: Text(e.toString()),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _textEditingController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
          const SizedBox(height: 200),
          TextFormField(
              decoration: const InputDecoration(labelText: "Email Address"),
              controller: _textEditingController),
          TextFormField(
              decoration: const InputDecoration(labelText: "Password"),
              obscureText: true,
              controller: _passwordController),
          const SizedBox(height: 30),
          loginStatus == 1
              ? const Text("Wrong Password",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.green))
              : const Text(""),
          loginStatus == 2
              ? const Text("User Not Found",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.green))
              : const Text(""),
          SizedBox(
              width: 500,
              child: ElevatedButton(
                  onPressed: () {
                    SignIn();
                  },
                  child: const Text("Log Me In !!"))),
          SizedBox(
              width: 500,
              child: ElevatedButton(
                  onPressed: () {
                    SignUp();
                  },
                  child: const Text("Create My Account"))),
        ],
      ),
    );
  }
}
