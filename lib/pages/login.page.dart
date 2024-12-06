import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_tuto/main.dart';
import 'package:firebase_auth_tuto/pages/signup.page.dart';
import 'package:firebase_auth_tuto/pages/user.page.dart';
import 'package:firebase_auth_tuto/shared/auth/constant/index.dart';
import 'package:firebase_auth_tuto/shared/auth/model/form-logic.dart';
import 'package:flutter/material.dart';

class MyLoginPage extends StatefulWidget {
  const MyLoginPage({super.key});

  @override
  State<MyLoginPage> createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {
  bool formState = false;
  late RegExp regex = RegExp(emailPattern);
  List<String> fieldNames = ['email', 'password'];

  final Map<String, FieldData> fieldsData = {};
  final Map<String, String?> errors = {};
  String serverError = '';

  @override
  void initState() {
    // TODO: implement initState
    initFieldsData(fieldNames);
    super.initState();
  }

  void initFieldsData(List<String> fields) {
    for (var name in fields) {
      fieldsData.addAll({
        name: FieldData(
            textEditingController: TextEditingController(),
            focusNode: FocusNode(),
            isFocused: false,
            isDirty: false,
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

  void validateField(String field, String value) {
    setState(() {
      switch (field) {
        case 'email':
          {
            if (!fieldsData[field]!.isDirty) {
              fieldsData[field]!.isDirty = true;
            }

            if (value.isEmpty || !regex.hasMatch(value)) {
              fieldsData[field]?.errorMessage = 'Wrong email.';
              fieldsData[field]?.hasError = FieldErrorState.invalid;
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.hasError = FieldErrorState.valid;
            }
          }
        case 'password':
          {
            if (!fieldsData[field]!.isDirty) {
              fieldsData[field]!.isDirty = true;
            }

            if (value.length < 6) {
              fieldsData[field]?.errorMessage =
                  'Your password must be at least six characters long.';
              fieldsData[field]?.hasError = FieldErrorState.invalid;
            } else {
              fieldsData[field]?.errorMessage = null;
              fieldsData[field]?.hasError = FieldErrorState.valid;
            }
          }
      }
    });
  }

  bool isAllFieldsAreValid() {
    bool isValid = fieldNames.every((fieldName) =>
        fieldsData[fieldName]!.hasError == FieldErrorState.valid);
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
    disposeControllers();
    super.dispose();
  }

  void disposeControllers() {
    fieldsData.forEach((fieldName, fieldData) {
      fieldsData[fieldName]?.textEditingController.dispose();
    });
  }

  void showUserPage(AppUser user) {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => UserPage(
            user: user,
          ),
        ));
  }

  void login() async {
    final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    try {
      final String email = fieldsData['email']!.textEditingController.text;
      final String password =
          fieldsData['password']!.textEditingController.text;
      UserCredential userCredential = await firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      AppUser user =
          AppUser(uid: userCredential.user!.uid, name: '', email: email);

      showUserPage(user);
    } on FirebaseAuthException catch (e) {
      serverError = e.message!;
    }
  }

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
                onChanged: (text) {
                  validateField('email', text);
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
                  validateField('password', text);
                },
                focusNode: fieldsData['password']?.focusNode,
                controller: fieldsData['password']?.textEditingController,
                obscureText: true,
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
              TextButton(
                onPressed: isAllFieldsAreValid() ? login : null,
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
              Visibility(
                visible: serverError.isNotEmpty,
                child: Text(serverError),
              ),
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
