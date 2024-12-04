import 'package:firebase_auth_tuto/pages/signup.page.dart';
import 'package:flutter/material.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: screenH / 4),
      child: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(onPressed: () {}, child: const Text("Submit")),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SignupPage(),
                      ),
                    );
                  },
                  child: const Text("Create an account?")),
            ],
          ),
        ),
      ),
    ));
  }
}
