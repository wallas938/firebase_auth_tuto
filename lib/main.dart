import 'package:firebase_auth_tuto/firebase_options.dart';
import 'package:firebase_auth_tuto/pages/login.page.dart';
import 'package:firebase_auth_tuto/pages/signup.page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  runApp(const MyApp());

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class AppUser {
  String uid;
  String name;
  String email;

  AppUser({
    required this.uid,
    required this.name,
    required this.email,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return AppUser(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
    };
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyLoginPage(),
      routes: {
        '/login': (context) => const MyLoginPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}
