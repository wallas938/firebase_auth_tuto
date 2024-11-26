import 'package:firebase_auth_tuto/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
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
  String? id;
  String name;
  String email;

  AppUser({
    this.id,
    required this.name,
    required this.email,
  });

  AppUser copyWith({
    String? id,
    String? name,
    String? email,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
    );
  }

  AppUser fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['uid'],
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
      home: const SignupPage(),
      routes: {
        '/login': (context) => const MyLoginPage(),
        '/signup': (context) => const SignupPage(),
      },
    );
  }
}

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    print("screenH : $screenH");
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

class SignupPage extends StatefulWidget {
  final String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<SignupPage> {

  List<String> fieldNames = ['name', 'email', 'password', 'confirmedPassword'];

  late Map<String, TextEditingController> controllers;

  late RegExp regex = RegExp(widget.pattern);

  @override
  void initState() {
    super.initState();
    fieldNames.forEach((field) {
      // ici !!!
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void signup() {

  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: screenH / 8),
      child: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: InputDecoration(
                  hintText: 'Entrer votre nom',
                  labelText: "Name",
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                onChanged: (text) {
                  if (!regex.hasMatch(email.text)) {}
                },
                controller: email,
                decoration: InputDecoration(
                  hintText: 'Entrer un email',
                  labelText: "Email",
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: password,
                decoration: InputDecoration(
                  hintText: 'Entrer un mot de passe',
                  labelText: "Password",
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                controller: confirmedPassword,
                decoration: InputDecoration(
                  hintText: 'Veuillez confirmer le mot de passe',
                  labelText: "Confirm Password",
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(onPressed: signup, child: const Text("Submit")),
              const SizedBox(
                height: 40,
              ),
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const MyLoginPage(),
                      ),
                    );
                  },
                  child: const Text("Already have an account?")),
            ],
          ),
        ),
      ),
    ));
  }
}
