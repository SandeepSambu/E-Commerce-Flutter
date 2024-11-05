import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

// The Login class is a StatefulWidget that handles user authentication.
class Login extends StatefulWidget {
  final Function(String, String) signIn;
  final VoidCallback onCreate;
  final String errMsg;
  const Login({super.key, required this.signIn, required this.onCreate, required this.errMsg});


  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  // Controllers for the email and password input fields.
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  // Flags to indicate validation status.
  bool isEmail = false;
  bool isPassword = false;
  bool emailFlag = false;
  bool passFlag = false;

  // Regular expression for password validation.
  final regex = r"^(?=.*\d)(?=.*[a-z])(?=.*[A-Z])(?=.*[a-zA-Z]).{8,}$";

  // Method to validate the email format.
  void emailValidate() {
    if(RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email.text)) {
      setState(() {
        isEmail = true;
      });
    }
  }

  // Method to validate the password format.
  void passwordValidate() {
    if(RegExp(regex).hasMatch(password.text)) {
      setState(() {
        isPassword = true;
      });
    }
  }

  // Method to validate email and password and call the sign-in function.
  void validate() {
    emailValidate();
    passwordValidate();
    isEmail && isPassword ? widget.signIn(email.text, password.text) : null;
  }

  // Widget for the sign-in button with an icon.
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
                child: Text("Email/Password is incorrect, please check and try again."),
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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey[300],
        child: Align(
            alignment: Alignment.center,
            child: SizedBox(
              width: 500,
              height: 400,
              child: Card(
                elevation: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 60, top: 80),
                      child: TextField(
                        decoration: InputDecoration(
                            label: const Text("Email", style: TextStyle(fontWeight: FontWeight.bold)),
                            errorText: emailFlag && !isEmail ? "Email is incorrect" : null
                        ),
                        onChanged: (_) {
                          setState(() {
                            emailFlag = false;
                          });
                        },
                        controller: email,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 60, right: 60, top: 60),
                      child: TextField(
                        decoration: InputDecoration(
                            label: const Text("Password", style: TextStyle(fontWeight: FontWeight.bold)),
                            errorMaxLines: 2,
                            errorText: passFlag && !isPassword
                                ? "Password format is incorrect, password must exceed 7 characters, contain one uppercase and a number"
                                : null
                        ),
                        onChanged: (_) {
                          setState(() {
                            passFlag = false;
                          });
                        },
                        controller: password,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                            padding: const EdgeInsets.only(top: 50),
                            child: ElevatedButton.icon(
                              onPressed: widget.onCreate,
                              icon: const Icon(Icons.account_circle_rounded),
                              label:const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold)),
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
                            )
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50),
                          child: signIn()
                        )
                      ],
                    ),
                  ],
                ),
              ),
            )
        ),
      ),
    );
  }
}