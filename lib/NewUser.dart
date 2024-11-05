import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

// NewUser widget to handle user registration
class NewUser extends StatefulWidget {
  final Function(String, String, String) createNewUser;
  final VoidCallback onCreate;
  final String errMsg;
  const NewUser({super.key, required this.createNewUser, required this.onCreate, required this.errMsg});

  @override
  State<NewUser> createState() => _NewUserState();
}

class _NewUserState extends State<NewUser> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Controllers for input fields
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Flags to indicate validation status
  bool isEmail = false;
  bool isPassword = false;
  bool emailFlag = false;
  bool passFlag = false;

  // Regular expression for password validation
  final regex = r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$";

  // Validate email format
  void emailValidate() {
    if(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.text)) {
      setState(() {
        isEmail = true;
      });
    }
  }

  // Validate password format
  void passwordValidate() {
    if(RegExp(regex).hasMatch(password.text)) {
      setState(() {
        isPassword = true;
      });
    }
  }

  // Validate both fields before creating a new user
  void validate() {
    emailValidate();
    passwordValidate();
    isEmail && isPassword ? widget.createNewUser(username.text, email.text, password.text) : null;
  }

  // Widget for the sign-in button
  Widget signIn() {
    return ElevatedButton.icon(
      onPressed: () {
        setState(() {
          emailFlag = true;
          passFlag = true;
        });
        validate();
        if (widget.errMsg != "") {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Align(
                alignment: Alignment.center,
                child: Text("The email address is already in use by another account."),
              ),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      icon: const Icon(Icons.login),
      label: const Text(
        "SignIn",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      style: ButtonStyle(
        backgroundColor: WidgetStateProperty.all<Color>(Colors.blue),
        foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        shadowColor: WidgetStateProperty.all<Color>(Colors.black),
        overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (Set<WidgetState> states) {
            if (states.contains(WidgetState.pressed)) {
              return Colors.blueAccent;
            }
            return null;
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[300],
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: kIsWeb ? const EdgeInsets.only(bottom: 125) : const EdgeInsets.only(bottom: 180),
                child: Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(onPressed: widget.onCreate, icon: const Icon(Icons.arrow_back))
                ),
              ),
              Padding(
                padding: kIsWeb ? const EdgeInsets.only(bottom: 164) : const EdgeInsets.only(bottom: 230),
                child: Align(
                    alignment: Alignment.center,
                    child: SizedBox(
                      width: 500,
                      height: 400,
                      child: Card(
                        elevation: 5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 60, right: 60),
                              child: TextField(
                                controller: username,
                                decoration:  const InputDecoration(label: Text("Username", style: TextStyle(fontWeight: FontWeight.bold))),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 60, right: 60, top: 30),
                              child: TextField(
                                controller: email,
                                onChanged: (_) {
                                  setState(() {
                                    emailFlag = false;
                                  });
                                },
                                decoration:  InputDecoration(
                                    label: const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                                    errorText: emailFlag && !isEmail ? "Email format is incorrect" : null
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 60, right: 60, top: 30),
                              child: TextField(
                                controller: password,
                                onChanged: (_) {
                                  setState(() {
                                    passFlag = false;
                                  });
                                },
                                decoration: InputDecoration(
                                    label: const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                                    errorMaxLines: 2,
                                    errorText: passFlag && !isPassword
                                        ? "Password format is incorrect, password must exceed 7 characters, contain one uppercase and a number"
                                        : null
                                ),
                              ),
                            ),
                            Padding(
                                padding: const EdgeInsets.only(top: 30),
                                child: signIn()
                            )
                          ],
                        ),
                      ),
                    )
                ),
              )
            ],
          )
      ),
    );
  }
}