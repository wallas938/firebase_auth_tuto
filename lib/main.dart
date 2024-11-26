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
  String name;
  String email;
  String password;

  AppUser({
    required this.name,
    required this.email,
    required this.password,
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
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
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 200),
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
  final String pattern =
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$';

  const SignupPage({super.key});

  @override
  State<StatefulWidget> createState() => _MySignupPageState();
}

class _MySignupPageState extends State<SignupPage> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController confirmedPassword = TextEditingController();

  late RegExp regex = RegExp(widget.pattern);
  void signup() {

    if (kDebugMode) {
      print(name.text);
      print(email.text);
      print(password.text);
      print(confirmedPassword.text);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.only(top: 200),
      child: Center(
        child: SizedBox(
          width: 500,
          child: Column(
            children: [
              TextField(
                controller: name,
                decoration: InputDecoration(
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

                  if(!regex.hasMatch(email.text)) {

                  }
                },
                controller: email,

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
                controller: password,
                decoration: InputDecoration(
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
