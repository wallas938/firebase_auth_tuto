import 'package:firebase_auth_tuto/main.dart';
import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  final AppUser user;

  const UserPage({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Column(
        children: [
          Text(user.name),
          Text(user.email)
        ],
      )),
    );
  }
}
