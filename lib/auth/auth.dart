import 'package:firebase_auth/firebase_auth.dart';
import 'package:newsapplication/auth/login_or_register.dart';
import 'package:flutter/material.dart';
import 'package:newsapplication/views/homepage.dart';


class AuthPage extends StatelessWidget {
  const AuthPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),

        builder: (
         context,
         snapshot) {
            //user is logged in
            if (snapshot.hasData) {
              return HomePage(key: UniqueKey(),);
            }else { //user is not logged in
              return const LoginOrRegister();
            }
          },

    ),
    );


  }
}