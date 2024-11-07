import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:recipeapp_flutter/NewUser.dart';
import 'package:recipeapp_flutter/ProductListScreen.dart';
import 'package:recipeapp_flutter/Login.dart';

// Main authentication widget managing login, sign-up, and navigation based on user state
class Authentication extends StatefulWidget {
  const Authentication({super.key});

  @override
  State<Authentication> createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  // Firebase authentication instance for user management
  final FirebaseAuth auth = FirebaseAuth.instance;

  bool create = false;

  String errMsg = "";

  // Method to create a new user account with Firebase Authentication
  Future<User?> createNewUser(String userName, String email, String password) async{
    try {
      // Creates a new user with email and password
      UserCredential userCredential= await auth.createUserWithEmailAndPassword(email: email, password: password);
      User? user = userCredential.user;
      await user?.updateDisplayName(userName);
      await user?.reload();
      user = auth.currentUser;
      // Navigates to ProductListScreen upon successful registration
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen(user: user, cartItems: {},)));
      return userCredential.user;
    } catch (e) {
      // Error handling: Updates error message in case of failure
      print("Error in creating new user: $e");
      setState(() {
        errMsg = "Failed to create user: ${e.toString()}";
      });
      return null;
    }
  }

  // Method to sign in an existing user
  Future<void> signIn(String email, String password) async{
    try {
      // Signs in with email and password
      UserCredential userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
      // Navigates to ProductListScreen upon successful sign-in
      Navigator.push(context, MaterialPageRoute(builder: (context) => ProductListScreen(user: userCredential.user, cartItems: {},)));
      print("SignedIn Successfully: ${userCredential.user}");
    } catch (e) {
      // Error handling: Updates error message in case of failure
      print(e.toString());
      setState(() {
        errMsg = "SignIn Failed: ${e.toString()}";
      });
    }
  }

  // Method to sign out the user
  Future<void> signOut() async{
    await auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return create
        ? NewUser(createNewUser : createNewUser, onCreate : () => setState(() {create = false;}, ), errMsg: errMsg)
        : Login(signIn : signIn, onCreate : () => setState(() {create = true;}), errMsg: errMsg,);
  }
}