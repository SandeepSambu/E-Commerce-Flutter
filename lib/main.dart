import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:recipeapp_flutter/ProductListScreen.dart';
import "firebase_options.dart";

// Main function to initialize the app
void main() async{
  // Ensures all widgets are properly initialized before running the app
  WidgetsFlutterBinding.ensureInitialized();
  // Initializes Firebase with platform-specific options
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const ProductsApp());
}

// Root widget of the application
class ProductsApp extends StatelessWidget {
  const ProductsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: "/",
      routes: {
        // Sets the initial route to ProductListScreen, passing a default empty cart
        "/" : (context) => const ProductListScreen(user: null, cartItems: {},)
      },
    );
  }
}