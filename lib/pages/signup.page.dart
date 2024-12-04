import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_tuto/main.dart';
import 'package:firebase_auth_tuto/pages/login.page.dart';
import 'package:firebase_auth_tuto/pages/user.page.dart';
import 'package:flutter/material.dart';

enum FieldErrorState { initial, invalid, valid }

class FieldData {
  TextEditingController textEditingController;
  FocusNode focusNode;
  bool isFocused;
  FieldErrorState hasError;
  String? errorMessage;

  FieldData(
      {required this.textEditingController,
      required this.focusNode,
      required this.isFocused,
      required this.errorMessage,
      required this.hasError});
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
  final Map<String, String?> errors = {};
  String tempPassword = '';
  bool formState = false;
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
            hasError: FieldErrorState.initial)
      });
      fieldsData[name]?.focusNode.addListener(() {
        setState(() {
          fieldsData[name]?.isFocused = fieldsData[name]!.focusNode.hasFocus;
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
              fieldsData[field]?.hasError = FieldErrorState.invalid;
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.hasError = FieldErrorState.valid;
            }
          }
        case 'email':
          {
            if (value.isEmpty || !regex.hasMatch(value)) {
              fieldsData[field]?.errorMessage =
                  'Entered email is not correctly formated.';
              fieldsData[field]?.hasError = FieldErrorState.invalid;
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.hasError = FieldErrorState.valid;
            }
          }
        case 'password':
          {
            if (value.length < 6) {
              fieldsData[field]?.errorMessage =
                  'Your password must be at least six characters long.';
              fieldsData[field]?.hasError = FieldErrorState.invalid;
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.hasError = FieldErrorState.valid;
            }
          }
        case 'confirmedPassword':
          {
            if (tempPassword.isNotEmpty && value != tempPassword ||
                tempPassword.isEmpty) {
              fieldsData[field]?.errorMessage = 'Both passwords do not match.';
              fieldsData[field]?.hasError = FieldErrorState.invalid;
              errors[field] = 'Both passwords do not match';
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.hasError = FieldErrorState.valid;
            }
          }
      }
      isAllFieldsIsValid();
    });
  }

  bool isAllFieldsIsValid() {
    bool isValid = fieldNames
        .every((name) => fieldsData[name]!.hasError == FieldErrorState.valid);
    setState(() {
      if (isValid) {
        formState = true;
        return;
      }
      formState = false;
    });

    return formState;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  void signup() async {
    final name = fieldsData['name']!.textEditingController.text;
    final email = fieldsData['email']!.textEditingController.text;
    final password = fieldsData['password']!.textEditingController.text;

    FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final UserCredential userCredential =
        await firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    // create user
    AppUser user = AppUser(
      uid: userCredential.user!.uid,
      email: email,
      name: name,
    );

    // the newly created user is stored into the firestore database in users collection
    await firestore.collection("users").doc(user.uid).set(user.toJson());

    showUserPage(user);
  }

  showUserPage(AppUser user) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPage(
            user: user,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.only(top: screenH / 8),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
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
                      errorText: !fieldsData['name']!.isFocused &&
                              fieldsData['name']!.hasError ==
                                  FieldErrorState.invalid
                          ? fieldsData['name']?.errorMessage
                          : null),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  onChanged: (text) {
                    validateFieldValues('email', text);
                  },
                  focusNode: fieldsData['email']?.focusNode,
                  controller: fieldsData['email']?.textEditingController,
                  decoration: InputDecoration(
                      hintText: 'Enter an email',
                      labelText: "Email",
                      filled: true,
                      fillColor: Colors.grey[100],
                      errorText: !fieldsData['email']!.isFocused &&
                              fieldsData['email']!.hasError ==
                                  FieldErrorState.invalid
                          ? fieldsData['email']?.errorMessage
                          : null),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextField(
                  onChanged: (text) {
                    tempPassword = text;
                    validateFieldValues('password', text);
                  },
                  focusNode: fieldsData['password']?.focusNode,
                  controller: fieldsData['password']?.textEditingController,
                  decoration: InputDecoration(
                      hintText: 'Enter your password',
                      labelText: "Password",
                      filled: true,
                      fillColor: Colors.grey[100],
                      errorText: !fieldsData['password']!.isFocused &&
                              fieldsData['password']!.hasError ==
                                  FieldErrorState.invalid
                          ? fieldsData['password']?.errorMessage
                          : null),
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
                      errorText: !fieldsData['confirmedPassword']!.isFocused &&
                              fieldsData['confirmedPassword']!.hasError ==
                                  FieldErrorState.invalid
                          ? fieldsData['confirmedPassword']?.errorMessage
                          : null),
                ),
                const SizedBox(
                  height: 40,
                ),
                TextButton(
                  onPressed: isAllFieldsIsValid() ? signup : null,
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
      ),
    ));
  }
}
