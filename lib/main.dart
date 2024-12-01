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

class FieldData {
  TextEditingController textEditingController;
  FocusNode focusNode;
  bool isFocused;
  bool errorState;
  String? errorMessage;

  FieldData(
      {required this.textEditingController,
      required this.focusNode,
      required this.isFocused,
      required this.errorMessage,
      required this.errorState});
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

  final Map<String, FieldData> fieldsData = {};
  late Map<String, String?> errors = {};
  late String tempPassword = '';
  late RegExp regex = RegExp(widget.pattern);

  @override
  void initState() {
    super.initState();
    initFieldsData(fieldNames);
  }

  void initFieldsData(List<String> fields) {
    for (var name in fields) {
      fieldsData.addAll({
        name: FieldData(
            textEditingController: TextEditingController(),
            focusNode: FocusNode(),
            isFocused: false,
            errorMessage: null,
            errorState: false)
      });
      fieldsData[name]?.focusNode.addListener(() {
        setState(() {
          fieldsData[name]?.isFocused = fieldsData[name]!.focusNode.hasFocus;
          if (kDebugMode) {
            print(fieldsData[name]?.isFocused);
          }
        });
      });
    }
  }

  void validateFieldValues(String field, String value) {
    setState(() {
      switch (field) {
        case 'name':
          {
            if (value.isEmpty) {
              fieldsData[field]?.errorMessage = 'Name cannot be empty.';
              fieldsData[field]?.errorState = true;
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.errorState = false;
            }
          }
        case 'email':
          {
            if (value.isEmpty || !regex.hasMatch(value)) {
              fieldsData[field]?.errorMessage =
                  'Entered email is not correctly formated.';
              fieldsData[field]?.errorState = true;
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.errorState = false;
            }
          }
        case 'password':
          {
            if (value.length < 6) {
              fieldsData[field]?.errorMessage =
                  'Your password must be at least six characters long.';
              fieldsData[field]?.errorState = true;
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.errorState = false;
            }
          }
        case 'confirmedPassword':
          {
            if (tempPassword.isNotEmpty && value != tempPassword ||
                tempPassword.isEmpty) {
              fieldsData[field]?.errorMessage = 'Both passwords do not match.';
              fieldsData[field]?.errorState = true;
              errors[field] = 'Both passwords do not match';
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.errorState = false;
            }
          }
      }
    });
  }

  bool isAllFieldsIsValid() {
    return true;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void signup() {
    if (kDebugMode) {
    }
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
                onChanged: (text) {
                  validateFieldValues('name', text);
                },
                controller: fieldsData['name']?.textEditingController,
                decoration: InputDecoration(
                    hintText: 'Enter your name',
                    labelText: "Name",
                    filled: true,
                    fillColor: Colors.grey[100],
                    errorText: fieldsData['name']?.errorMessage),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                onChanged: (text) {
                  if (!fieldsData['email']!.isFocused) {
                    validateFieldValues('email', text);
                  }
                },
                focusNode: fieldsData['email']?.focusNode,
                controller: fieldsData['email']?.textEditingController,
                decoration: InputDecoration(
                    hintText: 'Enter an email',
                    labelText: "Email",
                    filled: true,
                    fillColor: Colors.grey[100],
                    errorText: fieldsData['email']?.errorMessage), // Conditionner l'affichage du message avec errorState
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                onChanged: (text) {
                  tempPassword = text;
                  validateFieldValues('password', text);
                },
                controller: fieldsData['password']?.textEditingController,
                decoration: InputDecoration(
                    hintText: 'Enter your password',
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.grey[100],
                    errorText: fieldsData['password']?.errorMessage),
              ),
              const SizedBox(
                height: 40,
              ),
              TextField(
                onChanged: (text) {
                  validateFieldValues('confirmedPassword', text);
                },
                controller:
                    fieldsData['confirmedPassword']?.textEditingController,
                decoration: InputDecoration(
                    hintText: 'Repeat your password',
                    labelText: "Confirm Password",
                    filled: true,
                    fillColor: Colors.grey[100],
                    errorText: fieldsData['confirmedPassword']?.errorMessage),
              ),
              const SizedBox(
                height: 40,
              ),
              TextButton(
                onPressed: true ? signup : null,
                style: ButtonStyle(
                  foregroundColor: WidgetStateProperty.resolveWith<Color>(
                    (Set<WidgetState> states) {
                      if (states.contains(WidgetState.disabled)) {
                        return Colors.grey;
                      }
                      return Colors.blue;
                    },
                  ),
                  overlayColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: const Text("Submit"),
              ),
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
