import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/async.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../bloc/NavigationBloc/navigation_bloc.dart';

class Account extends StatefulWidget {
  const Account({super.key});

  @override
  State<Account> createState() => _AccountState();
}

class _AccountState extends State<Account> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return const AccountLoggedIn();
          } else {
            return const AccountNotLoggedIn();
          }
        });
  }
}

class AccountLoggedIn extends StatefulWidget {
  const AccountLoggedIn({super.key});

  @override
  State<AccountLoggedIn> createState() => _AccountLoggedInState();
}

class _AccountLoggedInState extends State<AccountLoggedIn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 20, right: 20),
      child: Column(
        children: [
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
